/*
 * Copyright (C) 2019-2022 The Kraken authors. All rights reserved.
 * Copyright (C) 2022-present The WebF authors. All rights reserved.
 */

import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

/// defines the types of supported image source.
enum ImageType {
  /// Network image source with memory cache.
  ///
  /// NOTE:
  /// default ImageProviderFactory implementation [CachedNetworkImage].
  /// will be called when [url] startsWith '//' ,'http://'，'https://'.
  /// [param] will be [bool], the value is true.
  cached,

  /// Network image source.
  ///
  /// NOTE:
  /// default ImageProviderFactory implementation [NetworkImage]
  /// will be called when [url] startsWith '//' ,'http://'，'https://'
  /// [param] will be [bool], the value is false.
  network,

  /// File path image source
  ///
  /// NOTE:
  /// default ImageProviderFactory implementation [FileImage]
  /// will be called when [url] startsWith 'file://'
  /// [param] will be type [File]
  file,

  /// Raw image data source
  ///
  /// NOTE:
  /// default ImageProviderFactory implementation [MemoryImage]
  /// will be called when [url] startsWith 'data://'
  /// [param]  will be [Uint8List], value is the content part of the data URI as bytes,
  /// which is converted by [UriData.contentAsBytes].
  dataUrl,

  /// Blob image source which created by URL.createObjectURL()
  ///
  blob,

  /// Assets image source.
  assets
}

class WebFResizeImage extends ResizeImage {
  WebFResizeImage(
    ImageProvider<Object> imageProvider, {
    int? width,
    int? height,
    this.objectFit,
  }) : super(imageProvider, width: width, height: height);

  BoxFit? objectFit;

  static ImageProvider<Object> resizeIfNeeded(
      int? cacheWidth, int? cacheHeight, BoxFit? objectFit, ImageProvider provider) {
    if (cacheWidth != null || cacheHeight != null) {
      return WebFResizeImage(provider, width: cacheWidth, height: cacheHeight, objectFit: objectFit);
    }
    return provider;
  }

  @override
  void resolveStreamForKey(ImageConfiguration configuration, ImageStream stream, key, ImageErrorListener handleError) {
    // This is an unusual edge case where someone has told us that they found
    // the image we want before getting to this method. We should avoid calling
    // load again, but still update the image cache with LRU information.
    if (stream.completer != null) {
      final ImageStreamCompleter? completer = PaintingBinding.instance.imageCache.putIfAbsent(
        key,
        () => stream.completer!,
        onError: handleError,
      );
      assert(identical(completer, stream.completer));
      return;
    }
    final ImageStreamCompleter? completer = PaintingBinding.instance.imageCache.putIfAbsent(
      key,
      () => load(key, instantiateImageCodec),
      onError: handleError,
    );
    if (completer != null) {
      stream.setCompleter(completer);
    }
  }

  Future<Codec> instantiateImageCodec(
    Uint8List bytes, {
    int? cacheWidth,
    int? cacheHeight,
    bool allowUpscaling = false,
  }) async {
    assert(cacheWidth == null || cacheWidth > 0);
    assert(cacheHeight == null || cacheHeight > 0);

    final ImmutableBuffer buffer = await ImmutableBuffer.fromUint8List(bytes);
    final ImageDescriptor descriptor = await ImageDescriptor.encoded(buffer);

    double naturalWidth = descriptor.width.toDouble();
    double naturalHeight = descriptor.height.toDouble();

    int? targetWidth;
    int? targetHeight;

    // Image will be resized according to its aspect radio if object-fit is not fill.
    // https://www.w3.org/TR/css-images-3/#propdef-object-fit
    if (cacheWidth != null && cacheHeight != null) {
      // When targetWidth or targetHeight is not set at the same time,
      // image will be resized according to its aspect radio.
      // https://github.com/flutter/flutter/blob/master/packages/flutter/lib/src/painting/box_fit.dart#L152
      if (objectFit == BoxFit.contain) {
        if (cacheWidth / cacheHeight > naturalWidth / naturalHeight) {
          targetHeight = cacheHeight;
        } else {
          targetWidth = cacheWidth;
        }

        // Resized image should maintain its intrinsic aspect radio event if object-fit is fill
        // which behaves just like object-fit cover otherwise the cached resized image with
        // distorted aspect ratio will not work when object-fit changes to not fill.
      } else if (objectFit == BoxFit.fill || objectFit == BoxFit.cover) {
        if (cacheWidth / cacheHeight > naturalWidth / naturalHeight) {
          targetWidth = cacheWidth;
        } else {
          targetHeight = cacheHeight;
        }

        // Image should maintain its aspect radio and not resized if object-fit is none.
      } else if (objectFit == BoxFit.none) {
        targetWidth = descriptor.width;
        targetHeight = descriptor.height;

        // If image size is smaller than its natural size when object-fit is contain,
        // scale-down is parsed as none, otherwise parsed as contain.
      } else if (objectFit == BoxFit.scaleDown) {
        if (cacheWidth / cacheHeight > naturalWidth / naturalHeight) {
          if (cacheHeight > descriptor.height * window.devicePixelRatio) {
            targetWidth = descriptor.width;
            targetHeight = descriptor.height;
          } else {
            targetHeight = cacheHeight;
          }
        } else {
          if (cacheWidth > descriptor.width * window.devicePixelRatio) {
            targetWidth = descriptor.width;
            targetHeight = descriptor.height;
          } else {
            targetWidth = cacheWidth;
          }
        }
      }
    } else {
      targetWidth = cacheWidth;
      targetHeight = cacheHeight;
    }

    // Resize image size should not be larger than its natural size.
    if (!allowUpscaling) {
      if (targetWidth != null && targetWidth > descriptor.width * window.devicePixelRatio) {
        targetWidth = descriptor.width;
      }
      if (targetHeight != null && targetHeight > descriptor.height * window.devicePixelRatio) {
        targetHeight = descriptor.height;
      }
    }

    return descriptor.instantiateCodec(
      targetWidth: targetWidth,
      targetHeight: targetHeight,
    );
  }
}

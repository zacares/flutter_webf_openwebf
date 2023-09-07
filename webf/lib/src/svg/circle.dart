/*
 * Copyright (C) 2022-present The WebF authors. All rights reserved.
 */

import 'package:webf/svg.dart';
import 'package:webf/foundation.dart';
import 'rendering/circle.dart';

class SVGCircleElement extends SVGGeometryElement {
  late final RenderSVGCircle _renderer;

  @override
  get renderBoxModel => _renderer;

  @override
  get presentationAttributeConfigs => super.presentationAttributeConfigs
    ..addAll([
      SVGPresentationAttributeConfig('cx'),
      SVGPresentationAttributeConfig('cy'),
      SVGPresentationAttributeConfig('r'),
    ]);

  SVGCircleElement([BindingContext? context]): super(context) {
    _renderer = RenderSVGCircle(renderStyle: renderStyle, element: this);
  }
}

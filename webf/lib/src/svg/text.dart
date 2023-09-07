/*
 * Copyright (C) 2022-present The WebF authors. All rights reserved.
 */

import 'package:webf/svg.dart';
import 'package:webf/foundation.dart';

import 'rendering/text.dart';

class SVGTextElement extends SVGTextPositioningElement {
  late final RenderSVGText _renderer;

  @override
  get renderBoxModel => _renderer;

  @override
  get presentationAttributeConfigs => super.presentationAttributeConfigs..addAll([
  ]);

  SVGTextElement([BindingContext? context]): super(context) {
    _renderer = RenderSVGText(renderStyle: renderStyle, element: this);
  }
}

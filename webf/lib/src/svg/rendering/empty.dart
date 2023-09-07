/*
 * Copyright (C) 2022-present The WebF authors. All rights reserved.
 */

import 'package:flutter/rendering.dart';
import 'container.dart';
import 'package:webf/css.dart';
import 'package:webf/svg.dart';

// don't render anything
class RenderSVGEmpty extends RenderSVGContainer {
  RenderSVGEmpty({required CSSRenderStyle renderStyle, SVGElement? element})
      : super(renderStyle: renderStyle, element: element);

  @override
  void performLayout() {
    size = Size(0, 0);
    dispatchResize(contentSize, boxSize ?? Size.zero);
  }

  @override
  void performPaint(PaintingContext context, Offset offset) {
    return;
  }
}

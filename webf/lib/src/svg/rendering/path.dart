/*
 * Copyright (C) 2022-present The WebF authors. All rights reserved.
 */

import 'dart:ui';
import 'package:webf/css.dart';
import 'package:webf/svg.dart';
import 'shape.dart';

class RenderSVGPath extends RenderSVGShape {
  RenderSVGPath({required CSSRenderStyle renderStyle, SVGGeometryElement? element})
      : super(renderStyle: renderStyle, element: element);

  @override
  Path asPath() {
    final d = renderStyle.d;
    final path = Path();
    d.applyTo(path);
    return path;
  }
}

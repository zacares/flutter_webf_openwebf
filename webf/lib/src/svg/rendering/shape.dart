/*
 * Copyright (C) 2022-present The WebF authors. All rights reserved.
 */

import 'package:flutter/rendering.dart';
import 'package:webf/rendering.dart';
import 'package:webf/svg.dart';
import 'package:webf/css.dart';

abstract class RenderSVGShape extends RenderBoxModel {
  bool _needUpdateShape = true;

  SVGGeometryElement? element;

  RenderSVGShape({
    required CSSRenderStyle renderStyle,
    this.element,
  }): super(renderStyle: renderStyle);

  Path? _path;
  Path get path => _path ??= asPath();

  @override
  void performPaint(PaintingContext context, Offset offset) {
    final fill = renderStyle.fill;
    final stroke = renderStyle.stroke;
    final fillRule = renderStyle.fillRule;

    path.fillType = getFillType(fillRule);

    if (!fill.isNone) {
      context.canvas.drawPath(
          path.shift(offset),
          Paint()
            ..color = fill.resolve(renderStyle)
            ..style = PaintingStyle.fill);
    }

    if (!stroke.isNone) {
      final strokeWidth = renderStyle.strokeWidth.computedValue;
      final strokeCap = getStrokeCap(renderStyle.strokeLinecap);
      final strokeJoin = getStrokeJoin(renderStyle.strokeLinejoin);
      context.canvas.drawPath(
          path.shift(offset),
          Paint()
            ..color = stroke.resolve(renderStyle)
            ..style = PaintingStyle.stroke
            ..strokeWidth = strokeWidth
            ..strokeCap = strokeCap
            ..strokeJoin = strokeJoin);
    }
  }

  @override
  void performLayout() {
    if (_needUpdateShape || _path == null) {
      _path = asPath();
      _needUpdateShape = false;
      size = _path!.getBounds().size;
      dispatchResize(contentSize, boxSize ?? Size.zero);
    }
  }

  @override
  void paintBoxModel(PaintingContext context, Offset offset) {
    performPaint(context, offset);
  }

  Path asPath();

  markNeedUpdateShape() {
    _needUpdateShape = true;
    // PERF: use paint instead of layout
    markNeedsLayout();
  }

  @override
  double? computeDistanceToActualBaseline(TextBaseline baseline) {
    return null;
  }
}

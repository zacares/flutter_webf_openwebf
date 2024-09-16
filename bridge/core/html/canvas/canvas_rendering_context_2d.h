/*
 * Copyright (C) 2022-present The WebF authors. All rights reserved.
 */

#ifndef BRIDGE_CORE_HTML_CANVAS_CANVAS_RENDERING_CONTEXT_2D_H_
#define BRIDGE_CORE_HTML_CANVAS_CANVAS_RENDERING_CONTEXT_2D_H_

#include "canvas_gradient.h"
#include "canvas_pattern.h"
#include "path_2d.h"
#include "canvas_rendering_context.h"
#include "qjs_union_dom_stringcanvas_gradient.h"
#include "qjs_unionhtml_image_elementhtml_canvas_element.h"
#include "qjs_unionpath_2_d_dom_string.h"

namespace webf {

class CanvasRenderingContext2D : public CanvasRenderingContext {
  DEFINE_WRAPPERTYPEINFO();

 public:
  using ImplType = CanvasRenderingContext2D*;
  CanvasRenderingContext2D() = delete;
  explicit CanvasRenderingContext2D(ExecutingContext* context, NativeBindingObject* native_binding_object);

  NativeValue HandleCallFromDartSide(const AtomicString& method,
                                     int32_t argc,
                                     const NativeValue* argv,
                                     Dart_Handle dart_object) override;
  CanvasGradient* createLinearGradient(double x0,
                                       double y0,
                                       double x1,
                                       double y1,
                                       ExceptionState& exception_state) const;
  CanvasGradient* createRadialGradient(double x0,
                                       double y0,
                                       double r0,
                                       double x1,
                                       double y1,
                                       double r1,
                                       ExceptionState& exception_state) const;
  CanvasPattern* createPattern(const std::shared_ptr<QJSUnionHTMLImageElementHTMLCanvasElement>& init,
                               const AtomicString& repetition,
                               ExceptionState& exception_state);
  std::shared_ptr<QJSUnionDomStringCanvasGradient> fillStyle();
  void setFillStyle(const std::shared_ptr<QJSUnionDomStringCanvasGradient>& style, ExceptionState& exception_state);
  bool IsCanvas2d() const override;

  void fill(ExceptionState& exception_state);
  void fill(std::shared_ptr<const QJSUnionPath2DDomString> pathOrPattern, ExceptionState& exception_state);
  void fill(std::shared_ptr<const QJSUnionPath2DDomString> pathOrPattern, const AtomicString& fillRule, ExceptionState& exception_state);

  std::shared_ptr<QJSUnionDomStringCanvasGradient> strokeStyle();
  void setStrokeStyle(const std::shared_ptr<QJSUnionDomStringCanvasGradient>& style, ExceptionState& exception_state);

  void Trace(GCVisitor* visitor) const override;

 private:
  std::shared_ptr<QJSUnionDomStringCanvasGradient> fill_style_ = nullptr;
  std::shared_ptr<QJSUnionDomStringCanvasGradient> stroke_style_ = nullptr;
};

}  // namespace webf

#endif  // BRIDGE_CORE_HTML_CANVAS_CANVAS_RENDERING_CONTEXT_2D_H_

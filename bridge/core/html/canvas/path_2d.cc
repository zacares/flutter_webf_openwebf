/*
 * Copyright (C) 2022-present The WebF authors. All rights reserved.
 */

#include "path_2d.h"
#include "binding_call_methods.h"
#include "foundation/native_value_converter.h"

namespace webf {

Path2D* Path2D::Create(ExecutingContext* context, ExceptionState& exception_state) {
  return MakeGarbageCollected<Path2D>(context, exception_state);
}

Path2D* Path2D::Create(ExecutingContext* context,
                       const std::shared_ptr<QJSUnionPath2DDomString>& init,
                       ExceptionState& exception_state) {
  return MakeGarbageCollected<Path2D>(context, init, exception_state);
}

Path2D::Path2D(ExecutingContext* context, ExceptionState& exception_state)
  : BindingObject(context->ctx()) {
  NativeValue arguments[0];
  GetExecutingContext()->dartMethodPtr()->createBindingObject(GetExecutingContext()->isDedicated(),
                                                              GetExecutingContext()->contextId(), bindingObject(),
                                                              CreateBindingObjectType::kCreatePath2D, arguments, 0);
}

Path2D::Path2D(ExecutingContext* context,
               const std::shared_ptr<QJSUnionPath2DDomString>& init,
               ExceptionState& exception_state)
  : BindingObject(context->ctx()) {
  NativeValue arguments[1];
  if (init->IsDomString()) {
    arguments[0] = NativeValueConverter<NativeTypeString>::ToNativeValue(ctx(), init->GetAsDomString());
  } else if (init->IsPath2D()) {
    arguments[0] = NativeValueConverter<NativeTypePointer<Path2D>>::ToNativeValue(init->GetAsPath2D());
  }

  GetExecutingContext()->dartMethodPtr()->createBindingObject(GetExecutingContext()->isDedicated(),
                                                              GetExecutingContext()->contextId(), bindingObject(),
                                                              CreateBindingObjectType::kCreatePath2D, arguments, 1);
}

void Path2D::addPath(Path2D* path, DOMMatrixReadonly* dom_matrix, ExceptionState& exception_state) const {
  NativeValue arguments[] = {NativeValueConverter<NativeTypePointer<Path2D>>::ToNativeValue(path),
                            NativeValueConverter<NativeTypePointer<DOMMatrixReadonly>>::ToNativeValue(dom_matrix)};
  InvokeBindingMethod(binding_call_methods::kaddPath, 2, arguments, FlushUICommandReason::kDependentsOnElement,
                      exception_state);
}

void Path2D::addPath(webf::Path2D* path, webf::ExceptionState& exception_state) const {
  NativeValue arguments[] = {NativeValueConverter<NativeTypePointer<Path2D>>::ToNativeValue(path)};
  InvokeBindingMethod(binding_call_methods::kaddPath, 1, arguments, FlushUICommandReason::kDependentsOnElement,
                      exception_state);
}

NativeValue Path2D::HandleCallFromDartSide(const AtomicString& method,
                                          int32_t argc,
                                          const NativeValue* argv,
                                          Dart_Handle dart_object) {
  return Native_NewNull();
}

}  // namespace webf

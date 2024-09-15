/*
 * Copyright (C) 2022-present The WebF authors. All rights reserved.
 */

#include "dom_matrix_readonly.h"
#include "foundation/native_value_converter.h"

namespace webf {

DOMMatrixReadonly* DOMMatrixReadonly::Create(ExecutingContext* context,
                                             const std::shared_ptr<QJSUnionDomStringSequenceDouble>& init,
                                             ExceptionState& exception_state) {
  return MakeGarbageCollected<DOMMatrixReadonly>(context, init, exception_state);
}

DOMMatrixReadonly::DOMMatrixReadonly(ExecutingContext* context,
                                     const std::shared_ptr<QJSUnionDomStringSequenceDouble>& init,
                                     ExceptionState& exception_state)
    : BindingObject(context->ctx()) {
  NativeValue arguments[1];
  if (init->IsDomString()) {
    arguments[0] = NativeValueConverter<NativeTypeString>::ToNativeValue(ctx(), init->GetAsDomString());
  } else if (init->IsSequenceDouble()) {
    arguments[0] = NativeValueConverter<NativeTypeArray<NativeTypeDouble>>::ToNativeValue(init->GetAsSequenceDouble());
  }
  GetExecutingContext()->dartMethodPtr()->createBindingObject(GetExecutingContext()->isDedicated(),
                                                              GetExecutingContext()->contextId(), bindingObject(),
                                                              CreateBindingObjectType::kCreateDOMMatrix, arguments, 1);
}

DOMMatrixReadonly::DOMMatrixReadonly(webf::ExecutingContext* context, webf::ExceptionState& exception_state)
    : BindingObject(context->ctx()) {
  GetExecutingContext()->dartMethodPtr()->createBindingObject(GetExecutingContext()->isDedicated(),
                                                              GetExecutingContext()->contextId(), bindingObject(),
                                                              CreateBindingObjectType::kCreateDOMMatrix, nullptr, 0);
}

NativeValue DOMMatrixReadonly::HandleCallFromDartSide(const AtomicString& method,
                                                      int32_t argc,
                                                      const NativeValue* argv,
                                                      Dart_Handle dart_object) {
  return Native_NewNull();
}

}  // namespace webf
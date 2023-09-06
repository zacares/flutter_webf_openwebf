/*
 * Copyright (C) 2019-2022 The Kraken authors. All rights reserved.
 * Copyright (C) 2022-present The WebF authors. All rights reserved.
 */

import 'dart:ffi';
import 'package:flutter/foundation.dart';
import 'package:webf/module.dart';
import 'package:webf/launcher.dart';

import 'binding.dart';
import 'from_native.dart';
import 'to_native.dart';
import 'dedicated_worker_protocol.dart';

int _contextId = 0;

int newContextId() {
  return ++_contextId;
}

class DartContext {
  DartContext() : pointer = initDartIsolateContext(makeDartMethodsData()) {
    initDartDynamicLinking();
    registerDartContextFinalizer(this);
  }
  final Pointer<Void> pointer;
}

DartContext? dartContextForUIThread;

/// Init bridge
int initBridge(WebFViewController view) {
  if (kProfileMode) {
    PerformanceTiming.instance().mark(PERF_BRIDGE_REGISTER_DART_METHOD_START);
  }

  // Setup binding bridge.
  BindingBridge.setup();

  if (kProfileMode) {
    PerformanceTiming.instance().mark(PERF_BRIDGE_REGISTER_DART_METHOD_END);
  }

  int pageId = newContextId();

  if (view.dedicatedJSThread == true) {
    view.sendMessageToDedicatedThread(AllocateNewPage(view.dedicatedDartContext!, pageId));
  } else {
    dartContextForUIThread = DartContext();
    allocateNewPage(dartContextForUIThread!, pageId);
  }

  return pageId;
}

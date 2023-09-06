/*
 * Copyright (C) 2022-present The WebF authors. All rights reserved.
 */

import 'package:webf/bridge.dart';

class DedicatedProtocol {
  static int initBridge = 0;
}

class AllocateNewPage {
  int pageId;
  DartContext dartContext;

  AllocateNewPage(this.dartContext, this.pageId);
}

class InitDartContext {}
class InitDartContextResponse {
  DartContext dartContext;
  InitDartContextResponse(this.dartContext);
}

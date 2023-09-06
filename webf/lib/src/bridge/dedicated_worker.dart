/*
 * Copyright (C) 2022-present The WebF authors. All rights reserved.
 */

import 'dart:isolate';
import 'package:webf/bridge.dart';

void initializeDedicatedWorker(SendPort sendPort) {
  ReceivePort mainToIsolateStream = ReceivePort();
  sendPort.send(mainToIsolateStream.sendPort);
  mainToIsolateStream.listen((data) {
    if (data is InitDartContext) {
      DartContext dartContext = DartContext();
      sendPort.send(InitDartContextResponse(dartContext));
    } else if (data is AllocateNewPage) {
      allocateNewPage(data.dartContext, data.pageId);
    }
    print('data: $data');
  });
}

class DedicatedWorker {

}

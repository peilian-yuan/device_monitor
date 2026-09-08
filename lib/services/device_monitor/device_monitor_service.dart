import 'dart:ffi';

import 'package:ffi/ffi.dart';

import 'device_monitor_ffi.dart';

class DeviceMonitorService {
  DeviceMonitorService._internal();

  static final DeviceMonitorService instance =
      DeviceMonitorService._internal();

  final DeviceMonitorFFI _ffi =
      DeviceMonitorFFI();

  Pointer<Void>? _handle;

  bool get isCreated =>
      _handle != null;

  Pointer<Void> get _nativeHandle {
    final handle = _handle;

    if (handle == null) {
      throw StateError(
        'DeviceMonitor has not been created.',
      );
    }

    return handle;
  }

  // --------------------------------------------------
  // Create
  // --------------------------------------------------

  void create() {
    if (_handle != null) {
      return;
    }

    final handle = _ffi.create();

    if (handle == nullptr) {
      throw Exception(
        'Failed to create DeviceMonitor.',
      );
    }

    _handle = handle;
  }

  // --------------------------------------------------
  // Destroy
  // --------------------------------------------------

  void destroy() {
    final handle = _handle;

    if (handle == null) {
      return;
    }

    _ffi.destroy(handle);

    _handle = null;
  }

  // --------------------------------------------------
  // Start
  // --------------------------------------------------

  bool start({
    required String port,
    required int baud,
    required int webSocketPort,
  }) {
    final portPtr = port.toNativeUtf8();

    try {
      final result = _ffi.start(
        _nativeHandle,
        portPtr,
        baud,
        webSocketPort,
      );

      return result != 0;
    } finally {
      malloc.free(portPtr);
    }
  }

  // --------------------------------------------------
  // Stop
  // --------------------------------------------------

  void stop() {
    _ffi.stop(_nativeHandle);
  }

  // --------------------------------------------------
  // Running
  // --------------------------------------------------

  bool get isRunning {
    return _ffi.isRunning(
          _nativeHandle,
        ) !=
        0;
  }

  // --------------------------------------------------
  // Last error
  // --------------------------------------------------

  String get lastError {
    return _ffi.getLastError(
      _nativeHandle,
    );
  }

  // --------------------------------------------------
  // Version
  // --------------------------------------------------

  String get version {
    return _ffi.getVersion();
  }

  // --------------------------------------------------
  // Send command
  // --------------------------------------------------

  bool send({
    required String name,
    required List<int> data,
  }) {
    final nameBytes = name.codeUnits;

    final namePtr =
        malloc.allocate<Uint8>(
      nameBytes.length + 1,
    );

    final dataPtr =
        data.isEmpty
            ? nullptr
            : malloc.allocate<Uint8>(
                data.length,
              );

    try {
      // name
      for (int i = 0;
          i < nameBytes.length;
          i++) {
        namePtr[i] = nameBytes[i];
      }

      // C-style string terminator
      namePtr[nameBytes.length] = 0;

      // data
      for (int i = 0; i < data.length; i++) {
        dataPtr[i] = data[i];
      }

      final result = _ffi.send(
        _nativeHandle,
        namePtr,
        dataPtr,
        data.length,
      );

      return result != 0;
    } finally {
      malloc.free(namePtr);

      if (dataPtr != nullptr) {
        malloc.free(dataPtr);
      }
    }
  }

  // --------------------------------------------------
  // Broadcast
  // --------------------------------------------------

  void broadcast(List<int> data) {
    if (data.isEmpty) {
      return;
    }

    final dataPtr =
        malloc.allocate<Uint8>(
      data.length,
    );

    try {
      for (int i = 0; i < data.length; i++) {
        dataPtr[i] = data[i];
      }

      _ffi.broadcast(
        _nativeHandle,
        dataPtr,
        data.length,
      );
    } finally {
      malloc.free(dataPtr);
    }
  }
}
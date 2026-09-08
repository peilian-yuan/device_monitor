import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';

class DeviceMonitorFFI {
  late final DynamicLibrary _library;

  late final Pointer<Void> Function()
      _dmCreate;

  late final void Function(
    Pointer<Void> handle,
  ) _dmDestroy;

  late final int Function(
    Pointer<Void> handle,
    Pointer<Utf8> port,
    int baud,
    int webSocketPort,
  ) _dmStart;

  late final void Function(
    Pointer<Void> handle,
  ) _dmStop;

  late final int Function(
    Pointer<Void> handle,
    Pointer<Uint8> name,
    Pointer<Uint8> data,
    int size,
  ) _dmSend;

  late final void Function(
    Pointer<Void> handle,
    Pointer<Uint8> data,
    int size,
  ) _dmBroadcast;

  late final int Function(
    Pointer<Void> handle,
  ) _dmIsRunning;

  late final Pointer<Utf8> Function(
    Pointer<Void> handle,
  ) _dmGetLastError;

  late final Pointer<Utf8> Function()
      _dmGetVersion;

  DeviceMonitorFFI() {
    _library = _loadLibrary();

    _dmCreate = _library.lookupFunction<
        Pointer<Void> Function(),
        Pointer<Void> Function()>(
      'dm_create',
    );

    _dmDestroy = _library.lookupFunction<
        Void Function(Pointer<Void>),
        void Function(Pointer<Void>)>(
      'dm_destroy',
    );

    _dmStart = _library.lookupFunction<
        Int32 Function(
          Pointer<Void>,
          Pointer<Utf8>,
          Uint32,
          Int32,
        ),
        int Function(
          Pointer<Void>,
          Pointer<Utf8>,
          int,
          int,
        )>(
      'dm_start',
    );

    _dmStop = _library.lookupFunction<
        Void Function(Pointer<Void>),
        void Function(Pointer<Void>)>(
      'dm_stop',
    );

    _dmSend = _library.lookupFunction<
        Int32 Function(
          Pointer<Void>,
          Pointer<Uint8>,
          Pointer<Uint8>,
          Uint32,
        ),
        int Function(
          Pointer<Void>,
          Pointer<Uint8>,
          Pointer<Uint8>,
          int,
        )>(
      'dm_send',
    );

    _dmBroadcast = _library.lookupFunction<
        Void Function(
          Pointer<Void>,
          Pointer<Uint8>,
          Uint32,
        ),
        void Function(
          Pointer<Void>,
          Pointer<Uint8>,
          int,
        )>(
      'dm_broadcast',
    );

    _dmIsRunning = _library.lookupFunction<
        Int32 Function(Pointer<Void>),
        int Function(Pointer<Void>)>(
      'dm_is_running',
    );

    _dmGetLastError = _library.lookupFunction<
        Pointer<Utf8> Function(Pointer<Void>),
        Pointer<Utf8> Function(Pointer<Void>)>(
      'dm_get_last_error',
    );

    _dmGetVersion = _library.lookupFunction<
        Pointer<Utf8> Function(),
        Pointer<Utf8> Function()>(
      'dm_get_version',
    );
  }

  DynamicLibrary _loadLibrary() {
    if (!Platform.isWindows) {
      throw UnsupportedError(
        'DeviceMonitor is currently supported only on Windows.',
      );
    }

    return DynamicLibrary.open(
      'DeviceMonitor.dll',
    );
  }

  Pointer<Void> create() {
    return _dmCreate();
  }

  void destroy(Pointer<Void> handle) {
    _dmDestroy(handle);
  }

  int start(
    Pointer<Void> handle,
    Pointer<Utf8> port,
    int baud,
    int webSocketPort,
  ) {
    return _dmStart(
      handle,
      port,
      baud,
      webSocketPort,
    );
  }

  void stop(Pointer<Void> handle) {
    _dmStop(handle);
  }

  int send(
    Pointer<Void> handle,
    Pointer<Uint8> name,
    Pointer<Uint8> data,
    int size,
  ) {
    return _dmSend(
      handle,
      name,
      data,
      size,
    );
  }

  void broadcast(
    Pointer<Void> handle,
    Pointer<Uint8> data,
    int size,
  ) {
    _dmBroadcast(
      handle,
      data,
      size,
    );
  }

  int isRunning(Pointer<Void> handle) {
    return _dmIsRunning(handle);
  }

  String getLastError(Pointer<Void> handle) {
    final ptr = _dmGetLastError(handle);

    if (ptr == nullptr) {
      return '';
    }

    return ptr.toDartString();
  }

  String getVersion() {
    final ptr = _dmGetVersion();

    if (ptr == nullptr) {
      return '';
    }

    return ptr.toDartString();
  }
}
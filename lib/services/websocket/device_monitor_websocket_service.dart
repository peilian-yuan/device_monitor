import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

///
///DeviceMonitorService
///         │
///         │ FFI
///         ↓
/// DeviceMonitorDLL
///         │
///         │ WebSocket Server
///         ↓
/// DeviceMonitorWebSocketService
///         │
///         ↓
/// Flutter UI
///
///
///import 'dart:async';

class DeviceMonitorWebSocketService {
  WebSocket? _socket;

  // singleton pattern
  DeviceMonitorWebSocketService._();
  static final instance =
      DeviceMonitorWebSocketService._();

  final StreamController<Uint8List> _dataController =
      StreamController<Uint8List>.broadcast();

  Stream<Uint8List> get dataStream =>
      _dataController.stream;

  bool get isConnected =>
      _socket != null;

  Future<void> connect({
    String host = '127.0.0.1',
    int port = 8080,
  }) async {
    if (_socket != null) {
      return;
    }

    final uri = 'ws://$host:$port';

    try {
      final socket = await WebSocket.connect(uri);

      _socket = socket;

      print('WebSocket connected: $uri');

      socket.listen(
        _onData,
        onError: _onError,
        onDone: _onDone,
        cancelOnError: false,
      );
    } catch (e) {
      print('WebSocket connection failed: $e');
      rethrow;
    }
  }

  void _onData(dynamic data) {
    if (data is Uint8List) { // because they are com raw data, Uint8List is used instead of String
      _dataController.add(data);
      return;
    }

    if (data is List<int>) {
      _dataController.add(
        Uint8List.fromList(data),
      );
      return;
    }

    if (data is String) {
      print('WebSocket text message: $data');
      return;
    }

    print(
      'Unknown WebSocket data type: '
      '${data.runtimeType}',
    );
  }

  void _onError(dynamic error) {
    print('WebSocket error: $error');
  }

  void _onDone() {
    print('WebSocket disconnected');

    _socket = null;
  }

  Future<void> disconnect() async {
    final socket = _socket;

    if (socket == null) {
      return;
    }

    _socket = null;

    await socket.close();

    print('WebSocket closed');
  }

  Future<void> dispose() async {
    await disconnect();

    await _dataController.close();
  }
}
// import 'dart:io';
import 'package:device_monitor/services/device_monitor/device_monitor_service.dart';
import 'package:device_monitor/services/websocket/device_monitor_websocket_service.dart';

Future<void> main() async {
  final monitor =
      DeviceMonitorService.instance;

  final websocket =
      DeviceMonitorWebSocketService.instance;

  try {
    print('--------------------------------');
    print('Device Monitor Test');
    print('--------------------------------');

    // --------------------------------
    // 1. Create
    // --------------------------------

    monitor.create();

    print(
      'DeviceMonitor version = '
      '${monitor.version}',
    );

    // --------------------------------
    // 2. Start C++ MonitorServer
    // --------------------------------

    final started = monitor.start(
      port: 'COM4',
      baud: 115200,
      webSocketPort: 8080,
    );

    print('start = $started');

    if (!started) {
      print(
        'Error: ${monitor.lastError}',
      );

      return;
    }

    print(
      'running = ${monitor.isRunning}',
    );

    // --------------------------------
    // 3. Connect WebSocket
    // --------------------------------

    await websocket.connect(
      host: '127.0.0.1',
      port: 8080,
    );

    print(
      'WebSocket connected = '
      '${websocket.isConnected}',
    );

    // --------------------------------
    // 4. Listen for device data
    // --------------------------------

    websocket.dataStream.listen(
      (data) {
        print(
          'Received ${data.length} bytes:',
        );

        print(data);
      },
    );

    print(
      'Waiting for serial data...',
    );
    // Send a command to the device to request data
    String cmd = ':0F030000000A??\r\n';
    List<int> cmdBytes = cmd.codeUnits;
    monitor.send(
      name: 'Device ID', 
      data: cmdBytes
    );
    
    // Keep application alive
    await Future.delayed(
      const Duration(minutes: 10),
    );
  } finally {
    // --------------------------------
    // 5. Cleanup
    // --------------------------------

    await websocket.disconnect();

    monitor.stop();

    monitor.destroy();

    print(
      'Device Monitor stopped.',
    );
  }
}
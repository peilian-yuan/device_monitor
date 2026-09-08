import 'package:device_monitor/services/device_monitor/device_monitor_service.dart';


void main() {
  final monitor = DeviceMonitorService.instance;
  monitor.create();

  print(
    'DeviceMonitor version = '
    '${monitor.version}',
  );

  final result = monitor.start(
    port: 'COM3',
    baud: 115200,
    webSocketPort: 8080,
  );

  print('start = $result');
  print(
    'running = ${monitor.isRunning}',
  );

  if (!result) {
    print(
      'error = ${monitor.lastError}',
    );
  }
  monitor.stop();
  monitor.destroy();
}
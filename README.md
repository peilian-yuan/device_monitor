handy app for DeviceMonitor

                 Flutter
                /       \
               /         \
          FFI             WebSocket
           ↓                  ↓
 DeviceMonitorDLL       127.0.0.1:8080
           ↓                  ↓
         COM              MonitorServer


                    Windows
┌──────────────────────────────────────┐
│                                      │
│  Flutter App                         │
│      │                               │
│      │ FFI                           │
│      ↓                               │
│  DeviceMonitor.dll                  │
│      │                               │
│      │ COM                           │
│      ↓                               │
│  SerialPortService                   │
│      │                               │
│      ↓                               │
│  MonitorServer ───── WebSocket ──────┼──→ Flutter
│                                      │
└──────────────────────────────────────┘
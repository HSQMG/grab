import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketController {
  IO.Socket? socket;
  void initSocket() {
    socket = IO.io(
        'http://192.168.1.46:3000',
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .build());

    socket?.onConnect((_) {
      print('Connected to server');
    });

    socket?.onDisconnect((_) => print('Disconnected from server'));
  }

  void sendPosition(LatLng pos) {
    socket?.emit('position', pos);
  }

  void disconnect() {
    socket?.disconnect();
  }

  void connect() {
    socket?.connect();
  }

  void requestRide() {
    socket?.emit('request_ride');
  }

  void cancelRide() {
    socket?.emit('cancel_ride');
  }
}

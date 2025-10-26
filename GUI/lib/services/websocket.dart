import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../globals/endpoints.dart';

class WsService {
  WsService._();
  static final WsService I = WsService._();

  WebSocketChannel? _ch;
  final _controller = StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get stream => _controller.stream;

  void connect() {
    disconnect();
    _ch = WebSocketChannel.connect(Uri.parse(Endpoints.ws));
    _ch!.stream.listen((raw) {
      try {
        final data = jsonDecode(raw);
        if (data is Map<String, dynamic>) {
          _controller.add(data);
        }
      } catch (_) {}
    }, onError: (_) {
      // tenter reconnect après un délai ?
    }, onDone: () {});
  }

  void disconnect() {
    _ch?.sink.close();
    _ch = null;
  }
}

import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../globals/endpoints.dart';

class WS {
  WebSocketChannel? _ch;
  final _controller = StreamController<String>.broadcast();

  Stream<String> get stream => _controller.stream;

  void connect() {
    close();
    _ch = WebSocketChannel.connect(Uri.parse(Endpoints.socket));
    _ch!.stream.listen(
      (event) => _controller.add(event.toString()),
      onError: (e) => _controller.addError(e),
      onDone: () {
        // try reconnect simple
        Future.delayed(const Duration(seconds: 2), () => connect());
      },
    );
  }

  void send(String s) => _ch?.sink.add(s);
  void close() {
    _ch?.sink.close();
    _ch = null;
  }
}

final ws = WS();

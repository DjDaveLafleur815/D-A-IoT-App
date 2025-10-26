import 'package:flutter/material.dart';
import '../services/api.dart';
import '../services/websocket.dart';
import '../globals/endpoints.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  List<Map<String, dynamic>> rooms = [];
  String lastWs = "";

  @override
  void initState() {
    super.initState();
    ws.connect();
    ws.stream.listen((msg) {
      setState(() => lastWs = msg);
    });
    _load();
  }

  Future<void> _load() async {
    final list = await api.getList(Endpoints.rooms);
    setState(() => rooms = List<Map<String, dynamic>>.from(list));
  }

  @override
  void dispose() {
    ws.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard")),
      body: Column(
        children: [
          if (lastWs.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("WS: $lastWs"),
            ),
          Expanded(
            child: ListView.separated(
              itemCount: rooms.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (_, i) {
                final r = rooms[i];
                return ListTile(
                  title: Text(r['name']),
                  subtitle: Text(r['id']),
                  trailing: IconButton(
                    icon: const Icon(Icons.sensors),
                    onPressed: () {
                      ws.send("hello from app");
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:async';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../services/api.dart';
import '../services/websocket.dart';
import '../models/device.dart';
import '../models/sensor.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});
  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  List<Device> devices = [];
  List<Sensor> sensors = [];
  final List<FlSpot> points = [];
  StreamSubscription? sub;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
    WsService.I.connect();
    sub = WsService.I.stream.listen((msg) {
      // Exemple: {topic: ".../temperature", data: {"value": 23.5}}
      final data = msg["data"];
      if (data is Map && data["value"] is num) {
        final x = (points.isEmpty ? 0.0 : points.last.x + 1.0);
        final y = (data["value"] as num).toDouble();
        setState(() {
          points.add(FlSpot(x, y));
          if (points.length > 40) points.removeAt(0);
        });
      }
    });
  }

  Future<void> _load() async {
    try {
      final dRaw = await ApiClient.I.getList("/devices");
      final sRaw = await ApiClient.I.getList("/sensors");
      setState(() {
        devices = dRaw
            .map((e) => Device.fromJson(e as Map<String, dynamic>))
            .toList();
        sensors = sRaw
            .map((e) => Sensor.fromJson(e as Map<String, dynamic>))
            .toList();
        loading = false;
      });
    } catch (_) {
      setState(() => loading = false);
    }
  }

  @override
  void dispose() {
    sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tableau de bord"),
        actions: [
          IconButton(
            tooltip: "Rafraîchir",
            onPressed: _load,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    _statCard(Icons.sensors, "Capteurs",
                        sensors.length.toString(), cs),
                    _statCard(Icons.devices_other, "Appareils",
                        devices.length.toString(), cs),
                    _statCard(Icons.meeting_room_outlined, "Pièces",
                        _countRooms().toString(), cs),
                  ],
                ),
                const SizedBox(height: 16),
                _chartCard(cs),
                const SizedBox(height: 16),
                _devicesCard(cs),
                const SizedBox(height: 16),
                _sensorsCard(cs),
              ],
            ),
    );
  }

  int _countRooms() {
    final set = <String>{};
    for (final d in devices) set.add(d.room);
    return set.length;
  }

  Widget _statCard(IconData icon, String label, String value, ColorScheme cs) {
    return SizedBox(
      width: 320,
      child: Card(
        elevation: 0,
        color: cs.surfaceContainerHighest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              CircleAvatar(radius: 26, child: Icon(icon, size: 28)),
              const SizedBox(width: 16),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(label,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                Text(value,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)),
              ])
            ],
          ),
        ),
      ),
    );
  }

  Widget _chartCard(ColorScheme cs) {
    final data = points.isEmpty
        ? List.generate(20, (i) => FlSpot(i.toDouble(), (sin(i / 2) * 3 + 22)))
        : points;

    return Card(
      elevation: 0,
      color: cs.surfaceContainerHighest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 220,
          child: LineChart(
            LineChartData(
              gridData: const FlGridData(show: false),
              titlesData: const FlTitlesData(show: false),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: data,
                  isCurved: true,
                  barWidth: 3,
                  dotData: const FlDotData(show: false),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _devicesCard(ColorScheme cs) {
    return Card(
      elevation: 0,
      color: cs.surfaceContainerHighest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Appareils",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 8),
            for (final d in devices)
              ListTile(
                leading: const Icon(Icons.developer_board),
                title: Text(d.name),
                subtitle: Text("${d.type} • ${d.room}"),
                trailing: const Icon(Icons.chevron_right),
              ),
          ],
        ),
      ),
    );
  }

  Widget _sensorsCard(ColorScheme cs) {
    return Card(
      elevation: 0,
      color: cs.surfaceContainerHighest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Capteurs",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 8),
            for (final s in sensors)
              ListTile(
                leading: const Icon(Icons.sensors),
                title: Text(s.name),
                subtitle: Text("${s.device} • ${s.unit}"),
                trailing: const Icon(Icons.chevron_right),
              ),
          ],
        ),
      ),
    );
  }
}

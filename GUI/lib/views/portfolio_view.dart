import 'package:flutter/material.dart';

class PortfolioView extends StatelessWidget {
  const PortfolioView({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text("Portfolio")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            elevation: 0,
            color: cs.surfaceContainerHighest,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: const ListTile(
              leading: CircleAvatar(child: Icon(Icons.person)),
              title: Text("D-A IoT"),
              subtitle: Text("Appli domotique temps réel"),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            elevation: 0,
            color: cs.surfaceContainerHighest,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: const ListTile(
              leading: Icon(Icons.link),
              title: Text("GitHub"),
              subtitle: Text("https://github.com/DjDaveLafleur815/D-A-IoT-App"),
            ),
          ),
        ],
      ),
    );
  }
}

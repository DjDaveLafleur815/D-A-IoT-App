import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text("Accueil")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            elevation: 0,
            color: cs.surfaceContainerHighest,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: const ListTile(
              leading: Icon(Icons.info_outline),
              title: Text("Bienvenue sur D-A IoT"),
              subtitle:
                  Text("Gère tes pièces, appareils et capteurs en temps réel."),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: const [
              _HomeTile(
                  icon: Icons.dashboard,
                  title: "Dashboard",
                  route: "/dashboard"),
              _HomeTile(
                  icon: Icons.contact_page,
                  title: "Contact",
                  route: "/contact"),
              _HomeTile(
                  icon: Icons.person, title: "Portfolio", route: "/portfolio"),
            ],
          ),
        ],
      ),
    );
  }
}

class _HomeTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String route;
  const _HomeTile(
      {required this.icon, required this.title, required this.route});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        width: 220,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(children: [
          Icon(icon),
          const SizedBox(width: 12),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          const Spacer(),
          const Icon(Icons.chevron_right),
        ]),
      ),
    );
  }
}

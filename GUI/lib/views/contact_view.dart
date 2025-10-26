import 'package:flutter/material.dart';

class ContactView extends StatelessWidget {
  const ContactView({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text("Contact")),
      body: Center(
        child: Card(
          elevation: 0,
          color: cs.surfaceContainerHighest,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: const SizedBox(
            width: 500,
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.support_agent, size: 48),
                  SizedBox(height: 12),
                  Text("Support",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text("Mail: support@d-a-iot.app\nDiscord: d-a-iot/12345"),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

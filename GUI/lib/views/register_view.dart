import 'package:flutter/material.dart';
import '../services/auth.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final nameCtrl = TextEditingController();
  bool busy = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Inscription")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: "Nom / Pseudo"),
            ),
            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: passCtrl,
              decoration: const InputDecoration(labelText: "Mot de passe"),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: busy
                  ? null
                  : () async {
                      setState(() => busy = true);
                      final ok = await auth.register(
                        emailCtrl.text,
                        passCtrl.text,
                        name: nameCtrl.text,
                      );
                      if (!mounted) return;
                      setState(() => busy = false);
                      if (ok) {
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Erreur inscription")),
                        );
                      }
                    },
              child: Text(busy ? "..." : "S'inscrire"),
            ),
          ],
        ),
      ),
    );
  }
}

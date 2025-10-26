import 'package:flutter/material.dart';
import '../services/auth.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final emailCtrl = TextEditingController(text: "alice@example.com");
  final passCtrl = TextEditingController(text: "password");
  bool busy = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Connexion")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
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
                      final ok = await auth.login(
                        emailCtrl.text,
                        passCtrl.text,
                      );
                      if (!mounted) return;
                      setState(() => busy = false);
                      if (ok) {
                        Navigator.pushReplacementNamed(context, "/dashboard");
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Erreur login")),
                        );
                      }
                    },
              child: Text(busy ? "..." : "Se connecter"),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, "/register");
              },
              child: const Text("Créer un compte"),
            ),
          ],
        ),
      ),
    );
  }
}

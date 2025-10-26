import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Card(
                elevation: 0,
                color: cs.surfaceContainerHighest,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 8),
                      Text("Bienvenue 👋",
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text("Connecte-toi pour gérer ta domotique",
                          style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: 24),
                      TextField(
                        controller: emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: "Email",
                          prefixIcon: Icon(Icons.mail_outline),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: passCtrl,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: "Mot de passe",
                          prefixIcon: Icon(Icons.lock_outline),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          icon: loading
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2))
                              : const Icon(Icons.login),
                          label: const Text("Se connecter"),
                          onPressed: loading
                              ? null
                              : () async {
                                  setState(() => loading = true);
                                  try {
                                    final ok = await context
                                        .read<AuthService>()
                                        .login(emailCtrl.text.trim(),
                                            passCtrl.text.trim());
                                    if (!mounted) return;
                                    if (ok) {
                                      Navigator.pushReplacementNamed(
                                          context, "/dashboard");
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text("Login invalide")));
                                    }
                                  } catch (e) {
                                    if (!mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text("Erreur: $e")));
                                  } finally {
                                    if (mounted)
                                      setState(() => loading = false);
                                  }
                                },
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            child: const Text("Créer un compte"),
                            onPressed: () =>
                                Navigator.pushNamed(context, "/register"),
                          ),
                          const SizedBox(width: 12),
                          TextButton(
                            child: const Text("Mot de passe oublié ?"),
                            onPressed: () {},
                          ),
                        ],
                      ),
                      const Divider(height: 32),
                      Text("ou",
                          style: Theme.of(context).textTheme.labelMedium),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              icon: const Icon(Icons.person),
                              label: const Text("Se connecter avec Auth0"),
                              onPressed: () async {
                                try {
                                  final ok = await context
                                      .read<AuthService>()
                                      .loginWithAuth0();
                                  if (!mounted) return;
                                  if (ok) {
                                    Navigator.pushReplacementNamed(
                                        context, "/dashboard");
                                  }
                                } catch (e) {
                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Auth0: $e")));
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Google / Apple / Facebook sont pris en charge via Auth0 (Universal Login).",
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

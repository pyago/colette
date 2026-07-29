import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../config/firebase_config.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key, required this.auth});

  final AuthService auth;

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _name = TextEditingController();
  bool _register = false;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _name.dispose();
    super.dispose();
  }

  Future<void> _run(Future<void> Function() action) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await action();
      if (mounted) context.go('/');
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign in'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text(
                _register ? 'Create an account' : 'Welcome back',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Sign in to share a memory for Collete. Kwai may reply to thank you.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.muted,
                    ),
              ),
              const SizedBox(height: 24),
              if (_register) ...[
                TextField(
                  controller: _name,
                  decoration: const InputDecoration(labelText: 'Your name'),
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 12),
              ],
              TextField(
                controller: _email,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _password,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                autofillHints: const [AutofillHints.password],
              ),
              const SizedBox(height: 16),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    _error!,
                    style: const TextStyle(color: Colors.redAccent),
                  ),
                ),
              FilledButton(
                onPressed: _busy
                    ? null
                    : () => _run(() async {
                          if (_register) {
                            await widget.auth.registerWithEmail(
                              email: _email.text,
                              password: _password.text,
                              displayName: _name.text,
                            );
                          } else {
                            await widget.auth.signInWithEmail(
                              _email.text,
                              _password.text,
                            );
                          }
                        }),
                child: Text(_register ? 'Register' : 'Sign in with email'),
              ),
              TextButton(
                onPressed: _busy
                    ? null
                    : () => setState(() => _register = !_register),
                child: Text(
                  _register
                      ? 'Already have an account? Sign in'
                      : 'Need an account? Register',
                ),
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              Text(
                'Or continue with',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.muted,
                    ),
              ),
              const SizedBox(height: 12),
              _ProviderButton(
                label: 'Google',
                icon: Icons.g_mobiledata,
                enabled: FirebaseConfig.enabled && !_busy,
                onPressed: () => _run(widget.auth.signInWithGoogle),
              ),
              _ProviderButton(
                label: 'Facebook',
                icon: Icons.facebook,
                enabled: FirebaseConfig.enabled && !_busy,
                onPressed: () => _run(widget.auth.signInWithFacebook),
              ),
              _ProviderButton(
                label: 'GitHub',
                icon: Icons.code,
                enabled: FirebaseConfig.enabled && !_busy,
                onPressed: () => _run(widget.auth.signInWithGithub),
              ),
              _ProviderButton(
                label: 'Apple',
                icon: Icons.apple,
                enabled: FirebaseConfig.enabled && !_busy,
                onPressed: () => _run(widget.auth.signInWithApple),
              ),
              if (!FirebaseConfig.enabled) ...[
                const SizedBox(height: 12),
                Text(
                  'Social sign-in activates after Firebase Auth providers are enabled.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.muted,
                      ),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: _busy
                      ? null
                      : () => _run(widget.auth.previewAsAdmin),
                  child: const Text('Preview as admin (local)'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ProviderButton extends StatelessWidget {
  const _ProviderButton({
    required this.label,
    required this.icon,
    required this.enabled,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: OutlinedButton.icon(
        onPressed: enabled ? onPressed : null,
        icon: Icon(icon),
        label: Text(label),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:vertecx/presentation/routes/app_routes.dart';

enum UserRole { admin, tecnico }

class User {
  final String email;
  final UserRole role;
  User(this.email, this.role);
}

class AuthService {
  static Future<User> signIn(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 450));
    if (email.trim().isEmpty || password.isEmpty) {
      throw Exception('Credenciales inválidas');
    }
    final lower = email.toLowerCase();
    final role = lower.contains('admin') ? UserRole.admin : UserRole.tecnico;
    return User(email, role);
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _form = GlobalKey<FormState>();
  bool _loading = false;
  bool _obscure = true;

  static const bg = Color(0xFF4D0E0E);
  static const red = Color(0xFFB20000);

  @override
  void dispose() {
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final user = await AuthService.signIn(_email.text.trim(), _pass.text);
      if (!mounted) return;
      if (user.role == UserRole.admin) {
        Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.adminHome, (r) => false);
      } else {
        Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.techHub, (r) => false);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
                child: Form(
                  key: _form,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 18),
                        child: Image.asset(
                          'assets/image/logo.jpg',
                          height: 68,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const Text(
                            'Logo',
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _email,
                        enabled: !_loading,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Correo electrónico',
                          prefixIcon: Icon(Icons.email_outlined),
                          filled: true,
                        ),
                        validator: (v) {
                          final value = (v ?? '').trim();
                          if (value.isEmpty) return 'Ingrese su correo';
                          final ok = RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value);
                          if (!ok) return 'Correo no válido';
                          return null;
                        },
                        onFieldSubmitted: (_) => _submit(),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _pass,
                        enabled: !_loading,
                        obscureText: _obscure,
                        decoration: InputDecoration(
                          labelText: 'Contraseña',
                          prefixIcon: const Icon(Icons.lock_outline),
                          filled: true,
                          suffixIcon: IconButton(
                            onPressed: () => setState(() => _obscure = !_obscure),
                            icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                          ),
                        ),
                        validator: (v) => (v == null || v.isEmpty) ? 'Ingrese su contraseña' : null,
                        onFieldSubmitted: (_) => _submit(),
                      ),
                      const SizedBox(height: 22),
                      SizedBox(
                        width: double.infinity,
                        height: 44,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: red,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: red.withOpacity(0.5),
                            disabledForegroundColor: Colors.white70,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: _loading ? null : _submit,
                          child: _loading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                )
                              : const Text('Acceder'),
                        ),
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

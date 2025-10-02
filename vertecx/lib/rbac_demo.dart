import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// 1) Modelado de roles
enum AppRole { admin, tecnico, vendedor, invitado }

extension RoleName on AppRole {
  String get label {
    switch (this) {
      case AppRole.admin: return 'Admin';
      case AppRole.tecnico: return 'Técnico';
      case AppRole.vendedor: return 'Vendedor';
      case AppRole.invitado: return 'Invitado';
    }
  }
}

/// 2) Estado y Cubit de Autenticación/Roles
class AuthState {
  final bool isAuthenticated;
  final String? username;
  final Set<AppRole> roles;

  const AuthState({
    required this.isAuthenticated,
    required this.roles,
    this.username,
  });

  factory AuthState.unauthenticated() =>
      const AuthState(isAuthenticated: false, roles: {AppRole.invitado});

  AuthState copyWith({
    bool? isAuthenticated,
    String? username,
    Set<AppRole>? roles,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      username: username ?? this.username,
      roles: roles ?? this.roles,
    );
  }

  bool hasAny(Iterable<AppRole> required) =>
      roles.intersection(required.toSet()).isNotEmpty;

  bool hasAll(Iterable<AppRole> required) =>
      required.every(roles.contains);
}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthState.unauthenticated());

  Future<void> signIn({
    required String user,
    required Set<AppRole> roles,
  }) async {
    emit(AuthState(isAuthenticated: true, username: user, roles: roles));
  }

  void signOut() {
    emit(AuthState.unauthenticated());
  }
}

/// 3) Gate para bloquear pantallas (rutas) por rol
class RoleGate extends StatelessWidget {
  final Widget child;
  final List<AppRole> anyOf;   // basta con uno de estos
  final List<AppRole> allOf;   // debe tener todos estos
  final Widget? fallback;      // que mostrar si no cumple

  const RoleGate({
    super.key,
    required this.child,
    this.anyOf = const [],
    this.allOf = const [],
    this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (p, n) => p.roles != n.roles || p.isAuthenticated != n.isAuthenticated,
      builder: (context, state) {
        final passAny = anyOf.isEmpty ? true : state.hasAny(anyOf);
        final passAll = allOf.isEmpty ? true : state.hasAll(allOf);
        if (passAny && passAll) return child;
        return fallback ?? const _NoAccessView();
      },
    );
  }
}

/// 4) Widget para mostrar/ocultar partes de la UI por rol
class RoleVisibility extends StatelessWidget {
  final List<AppRole> anyOf;
  final List<AppRole> allOf;
  final Widget child;
  final bool maintainSpace; // si quieres mantener el espacio al ocultar

  const RoleVisibility({
    super.key,
    required this.child,
    this.anyOf = const [],
    this.allOf = const [],
    this.maintainSpace = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (p, n) => p.roles != n.roles || p.isAuthenticated != n.isAuthenticated,
      builder: (context, state) {
        final passAny = anyOf.isEmpty ? true : state.hasAny(anyOf);
        final passAll = allOf.isEmpty ? true : state.hasAll(allOf);
        final visible = passAny && passAll;
        if (visible) return child;
        return maintainSpace ? Opacity(opacity: 0.0, child: child) : const SizedBox.shrink();
      },
    );
  }
}

/// 5) App de ejemplo con rutas protegidas y controles visibles por rol
void main() {
  runApp(
    BlocProvider(
      create: (_) => AuthCubit(),
      child: const VertecxRBACApp(),
    ),
  );
}

class VertecxRBACApp extends StatelessWidget {
  const VertecxRBACApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vertecx RBAC Demo',
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (_) => const LoginPage(),
        '/home': (_) => const HomePage(),
        '/admin': (_) => RoleGate(
              anyOf: const [AppRole.admin],
              child: const AdminPage(),
            ),
        '/tecnico': (_) => RoleGate(
              anyOf: const [AppRole.admin, AppRole.tecnico],
              child: const TecnicoPage(),
            ),
      },
      onUnknownRoute: (_) => MaterialPageRoute(builder: (_) => const _NoAccessView()),
    );
  }
}

/// 6) Páginas de ejemplo
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthCubit>();

    return Scaffold(
      appBar: AppBar(title: const Text('Login (Demo RBAC)')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Elige con qué roles deseas entrar:', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await auth.signIn(user: 'Alice', roles: {AppRole.admin});
                    if (context.mounted) Navigator.pushReplacementNamed(context, '/home');
                  },
                  child: const Text('Entrar como Admin'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await auth.signIn(user: 'Bob', roles: {AppRole.tecnico});
                    if (context.mounted) Navigator.pushReplacementNamed(context, '/home');
                  },
                  child: const Text('Entrar como Técnico'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await auth.signIn(user: 'Carla', roles: {AppRole.vendedor});
                    if (context.mounted) Navigator.pushReplacementNamed(context, '/home');
                  },
                  child: const Text('Entrar como Vendedor'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await auth.signIn(user: 'Dana', roles: {AppRole.vendedor, AppRole.tecnico});
                    if (context.mounted) Navigator.pushReplacementNamed(context, '/home');
                  },
                  child: const Text('Vendedor + Técnico'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.select((AuthCubit c) => c.state);

    return Scaffold(
      appBar: AppBar(
        title: Text('Home – ${state.username ?? 'Invitado'} (${state.roles.map((r) => r.label).join(', ')})'),
        actions: [
          IconButton(
            onPressed: () {
              context.read<AuthCubit>().signOut();
              Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
            },
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Accesos por rol', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),

          /// Botones que navegan a rutas protegidas (RoleGate en rutas)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/admin'),
                icon: const Icon(Icons.security),
                label: const Text('Zona Admin'),
              ),
              ElevatedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/tecnico'),
                icon: const Icon(Icons.build),
                label: const Text('Zona Técnico'),
              ),
            ],
          ),

          const Divider(height: 32),

          const Text('Acciones visibles por rol (RoleVisibility):',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),

          RoleVisibility(
            anyOf: const [AppRole.admin],
            child: Card(
              child: ListTile(
                leading: const Icon(Icons.person_add),
                title: const Text('Crear usuario'),
                subtitle: const Text('Solo Admin'),
                trailing: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Crear'),
                ),
              ),
            ),
          ),

          RoleVisibility(
            anyOf: const [AppRole.admin, AppRole.tecnico],
            child: Card(
              child: ListTile(
                leading: const Icon(Icons.build_circle),
                title: const Text('Cerrar solicitud de servicio'),
                subtitle: const Text('Admin o Técnico'),
                trailing: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Cerrar'),
                ),
              ),
            ),
          ),

          RoleVisibility(
            allOf: const [AppRole.vendedor],
            child: Card(
              child: ListTile(
                leading: const Icon(Icons.point_of_sale),
                title: const Text('Registrar venta'),
                subtitle: const Text('Solo Vendedor'),
                trailing: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Registrar'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Panel Admin')),
      body: const Center(child: Text('Contenido exclusivo de Administradores')),
    );
  }
}

class TecnicoPage extends StatelessWidget {
  const TecnicoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Panel Técnico')),
      body: const Center(child: Text('Herramientas para Técnicos y Admins')),
    );
  }
}

/// Vista por defecto si no tiene permisos
class _NoAccessView extends StatelessWidget {
  const _NoAccessView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sin acceso')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.block, size: 64),
            const SizedBox(height: 12),
            const Text('No tienes permisos para ver esta sección.'),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Volver'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vertecx/presentation/widgets/navigationWidgets/app_top_bar.dart';

/// ---- Modelo de datos ----
class UserProfile {
  final String id;
  final String nombre;
  final String rol; // 'Administrador', 'Técnico', 'Cliente'
  final String correo;
  final String telefono;
  final String documento; // NIT/CC
  final String avatarUrl; // puedes dejarlo vacío para placeholder
  final String empresa;
  final DateTime creadoEl;
  final int ordenes;
  final int solicitudes;
  final double rating; // 0..5

  const UserProfile({
    required this.id,
    required this.nombre,
    required this.rol,
    required this.correo,
    required this.telefono,
    required this.documento,
    required this.avatarUrl,
    required this.empresa,
    required this.creadoEl,
    required this.ordenes,
    required this.solicitudes,
    required this.rating,
  });

  UserProfile copyWith({
    String? nombre,
    String? rol,
    String? correo,
    String? telefono,
    String? documento,
    String? avatarUrl,
    String? empresa,
    DateTime? creadoEl,
    int? ordenes,
    int? solicitudes,
    double? rating,
  }) {
    return UserProfile(
      id: id,
      nombre: nombre ?? this.nombre,
      rol: rol ?? this.rol,
      correo: correo ?? this.correo,
      telefono: telefono ?? this.telefono,
      documento: documento ?? this.documento,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      empresa: empresa ?? this.empresa,
      creadoEl: creadoEl ?? this.creadoEl,
      ordenes: ordenes ?? this.ordenes,
      solicitudes: solicitudes ?? this.solicitudes,
      rating: rating ?? this.rating,
    );
  }
}

/// ---- Repositorio (mock) ----
abstract class IProfileRepository {
  Future<UserProfile> getProfile();
}

class ProfileRepositoryMock implements IProfileRepository {
  @override
  Future<UserProfile> getProfile() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return UserProfile(
      id: 'USR-001',
      nombre: 'Danier Álvarez',
      rol: 'Técnico',
      correo: 'danier@example.com',
      telefono: '+57 300 123 4567',
      documento: 'CC 1.234.567.890',
      avatarUrl: '',
      empresa: 'Vertecx',
      creadoEl: DateTime(2024, 3, 12),
      ordenes: 28,
      solicitudes: 64,
      rating: 4.7,
    );
  }
}

/// ---- Controller ----
class ProfileController extends ChangeNotifier {
  ProfileController(this._repo);

  final IProfileRepository _repo;

  UserProfile? _profile;
  String? _error;
  bool _loading = false;

  UserProfile? get profile => _profile;
  String? get error => _error;
  bool get loading => _loading;

  Future<void> load() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _profile = await _repo.getProfile();
    } catch (e) {
      _error = 'No se pudo cargar el perfil';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async => load();
}

/// ---- Página ----
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileController(ProfileRepositoryMock())..load(),
      child: const _ProfileScaffold(),
    );
  }
}

class _ProfileScaffold extends StatelessWidget {
  const _ProfileScaffold();

  @override
  Widget build(BuildContext context) {
    final brandRed = const Color(0xFFB20000);
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: const AppTopBar(
        title: 'Perfil',
        centerTitle: true,
        showBack: true,
      ),
      body: Consumer<ProfileController>(
        builder: (_, c, __) {
          if (c.loading) {
            return const _Skeleton();
          }
          if (c.error != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 40, color: Colors.red),
                    const SizedBox(height: 10),
                    Text(c.error!, style: const TextStyle(color: Colors.red)),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: c.load,
                      style: ElevatedButton.styleFrom(backgroundColor: brandRed),
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            );
          }
          final p = c.profile!;
          return RefreshIndicator(
            onRefresh: c.refresh,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _HeaderCard(profile: p),
                  const SizedBox(height: 12),
                  _StatsGrid(profile: p),
                  const SizedBox(height: 12),
                  _InfoCard(profile: p),
                  // (sin acciones abajo)
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// ---- Header (avatar + nombre + rol + rating) ----
class _HeaderCard extends StatelessWidget {
  const _HeaderCard({required this.profile});
  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    const wine = Color(0xFF5C0F0F);
    const red = Color(0xFFB20000);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 10, offset: Offset(0, 4))],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 34,
            backgroundColor: const Color(0xFFE8E8E8),
            backgroundImage: (profile.avatarUrl.isNotEmpty) ? NetworkImage(profile.avatarUrl) : null,
            child: (profile.avatarUrl.isEmpty)
                ? Text(
                    _initials(profile.nombre),
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: wine),
                  )
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Wrap(
              runSpacing: 6,
              children: [
                Text(
                  profile.nombre,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: wine),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _Chip(text: profile.rol, bg: const Color(0xFFFFF1F1), fg: red, icon: Icons.verified_user_outlined),
                    const SizedBox(width: 8),
                    _Chip(
                      text: '${profile.rating.toStringAsFixed(1)} ★',
                      bg: const Color(0xFFF8FAFC),
                      fg: wine,
                      icon: Icons.star_rate_rounded,
                    ),
                  ],
                ),
                Text(
                  profile.empresa,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) return parts.first.characters.first.toUpperCase();
    return (parts[0].characters.first + parts[1].characters.first).toUpperCase();
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.text, required this.bg, required this.fg, this.icon});
  final String text;
  final Color bg;
  final Color fg;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: fg),
            const SizedBox(width: 4),
          ],
          Text(text, style: TextStyle(color: fg, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

/// ---- Stats ----
class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.profile});
  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    const wine = Color(0xFF5C0F0F);

    Widget stat(String label, String value, IconData icon) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [BoxShadow(color: Color(0x10000000), blurRadius: 8, offset: Offset(0, 4))],
        ),
        child: Row(
          children: [
            Icon(icon, size: 24, color: wine),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: wine)),
                const SizedBox(height: 2),
                Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
              ],
            ),
          ],
        ),
      );
    }

    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 78,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      children: [
        stat('Órdenes', '${profile.ordenes}', Icons.assignment_turned_in_outlined),
        stat('Solicitudes', '${profile.solicitudes}', Icons.list_alt_outlined),
      ],
    );
  }
}

/// ---- Información de contacto / detalle ----
class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.profile});
  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    const wine = Color(0xFF5C0F0F);

    Widget row(IconData icon, String title, String value, {VoidCallback? onTap}) {
      return InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Icon(icon, size: 22, color: wine),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                    const SizedBox(height: 2),
                    Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    String fecha = '${profile.creadoEl.year}-${profile.creadoEl.month.toString().padLeft(2, '0')}-${profile.creadoEl.day.toString().padLeft(2, '0')}';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 10, offset: Offset(0, 4))],
      ),
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
      child: Column(
        children: [
          row(Icons.badge_outlined, 'Documento', profile.documento),
          const Divider(height: 1),
          row(Icons.mail_outline, 'Correo', profile.correo),
          const Divider(height: 1),
          row(Icons.phone_outlined, 'Teléfono', profile.telefono),
          const Divider(height: 1),
          row(Icons.apartment_outlined, 'Empresa', profile.empresa),
          const Divider(height: 1),
          row(Icons.calendar_today_outlined, 'Creado el', fecha),
        ],
      ),
    );
  }
}

/// ---- Skeleton (cargando) ----
class _Skeleton extends StatelessWidget {
  const _Skeleton();

  @override
  Widget build(BuildContext context) {
    Widget box({double h = 70}) => Container(
          height: h,
          decoration: BoxDecoration(
            color: const Color(0xFFEDEDED),
            borderRadius: BorderRadius.circular(16),
          ),
        );

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: Column(
        children: [
          box(h: 90),
          const SizedBox(height: 12),
          Row(children: [Expanded(child: box()), const SizedBox(width: 10), Expanded(child: box())]),
          const SizedBox(height: 12),
          box(h: 180),
          const SizedBox(height: 16),
          Row(children: [Expanded(child: box(h: 48)), const SizedBox(width: 12), Expanded(child: box(h: 48))]),
        ],
      ),
    );
  }
}

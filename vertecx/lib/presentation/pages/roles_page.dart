import 'package:flutter/material.dart';
import '../widgets/components/header/header.dart';
import '../widgets/components/search/search.dart';
import '../widgets/rolesWidgets/roles_card_widget.dart';
import 'package:vertecx/data/mocks/roles_mock_data.dart';

class RolesPage extends StatefulWidget {
  const RolesPage({super.key});

  @override
  State<RolesPage> createState() => _RolesPageState();
}

class _RolesPageState extends State<RolesPage> {
  final ScrollController _scrollController = ScrollController();
  int _rolesToShow = 4; // cantidad inicial de roles
  String _searchQuery = "";

  void _loadMoreRoles() {
    setState(() {
      _rolesToShow = (_rolesToShow + 2).clamp(0, mockRoles.length);
    });
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    // filtrar roles por búsqueda
    final filteredRoles = mockRoles
        .where((r) => r.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    final roles = filteredRoles.take(_rolesToShow).toList();
    final allRolesLoaded = _rolesToShow >= filteredRoles.length;

    return Scaffold(
      backgroundColor: const Color(0xFFE8E8E8),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            // encabezado
            const HearderUser(
              title: "Roles",
              iconPath: "assets/icons/userP.png",
              titleSize: 30,
            ),

            const SizedBox(height: 20),

            // buscador
            Buscar(
              hintText: "Buscar rol...",
              onChanged: (value) {
                setState(() => _searchQuery = value);
              },
            ),

            const SizedBox(height: 20),

            // lista de roles filtrados
            if (roles.isNotEmpty)
              ...roles.map((r) => RoleCardWidget(role: r))
            else
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  "No se encontraron roles",
                  style: TextStyle(
                    color: Color(0xFFB20000),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

            const SizedBox(height: 20),

            // botón o mensaje final
            if (filteredRoles.isNotEmpty)
              if (!allRolesLoaded)
                TextButton(
                  onPressed: _loadMoreRoles,
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/icons/Vector.png",
                        width: 20,
                        height: 20,
                      ),
                      const Text(
                        "Cargar más roles",
                        style: TextStyle(color: Color(0xFFB20000)),
                      ),
                    ],
                  ),
                )
              else
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "Ya están todos los roles",
                    style: TextStyle(
                      color: Color(0xFFB20000),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

            const SizedBox(height: 40),
          ],
        ),
      ),

      // botón flotante para subir
      floatingActionButton: FloatingActionButton(
        onPressed: _scrollToTop,
        backgroundColor: const Color(0xFFB20000),
        child: const Icon(Icons.arrow_upward, color: Colors.white),
      ),
    );
  }
}

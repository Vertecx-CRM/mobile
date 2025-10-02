import 'package:flutter/material.dart';
import 'package:vertecx/presentation/widgets/rolesWidgets/roles_card_widget.dart';
import 'package:vertecx/presentation/widgets/components/search/search.dart';
import 'package:vertecx/presentation/routes/app_routes.dart';
import 'package:vertecx/presentation/widgets/app_top_bar.dart';
import 'package:vertecx/presentation/widgets/AppBottomNav.dart';
import 'package:vertecx/data/mocks/roles_mock_data.dart';

class RolesPage extends StatefulWidget {
  const RolesPage({super.key});

  @override
  State<RolesPage> createState() => _RolesPageState();
}

class _RolesPageState extends State<RolesPage> {
  final ScrollController _scrollController = ScrollController();
  int _rolesToShow = 4;
  String _searchQuery = '';
  bool _menuOpen = false;

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

  void _goByBottomIndex(int i) {
    switch (i) {
      case 0:
        Navigator.of(context).pushReplacementNamed(AppRoutes.userList);
        break;
      case 1:
        Navigator.of(context).pushReplacementNamed(AppRoutes.categoryProduct);
        break;
      case 2:
        Navigator.of(context).pushReplacementNamed(AppRoutes.dashboard);
        break;
      case 3:
        Navigator.of(context).pushReplacementNamed(AppRoutes.appointment);
        break;
      case 4:
        setState(() => _menuOpen = !_menuOpen);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredRoles = mockRoles
        .where((r) => r.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    final roles = filteredRoles.take(_rolesToShow).toList();
    final allRolesLoaded = _rolesToShow >= filteredRoles.length;

    return Scaffold(
      appBar: const AppTopBar(),
      backgroundColor: const Color(0xFFE8E8E8),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
            child: Column(
              children: [
                Buscar(
                  hintText: "Buscar rol...",
                  onChanged: (value) => setState(() => _searchQuery = value),
                ),
                const SizedBox(height: 20),
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
          if (_menuOpen)
            Positioned.fill(
              child: GestureDetector(
                onTap: () => setState(() => _menuOpen = false),
                child: Container(color: Colors.black45),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _scrollToTop,
        backgroundColor: const Color(0xFFB20000),
        child: const Icon(Icons.arrow_upward, color: Colors.white),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vertecx/presentation/widgets/rolesWidgets/roles_card_widget.dart';
import 'package:vertecx/presentation/widgets/components/search/search.dart';
import 'package:vertecx/presentation/widgets/navigationWidgets/app_top_bar.dart';

import 'package:vertecx/data/repositories/roles/bloc/roles_bloc.dart';
import 'package:vertecx/data/repositories/roles/bloc/roles_event.dart';
import 'package:vertecx/data/repositories/roles/bloc/roles_state.dart';

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
    final state = context.read<RolesBloc>().state;
    if (state is RolesLoaded) {
      setState(() {
        _rolesToShow =
            (_rolesToShow + 2).clamp(0, state.roles.length);
      });
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<RolesBloc>().add(LoadRolesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppTopBar(),
      backgroundColor: const Color(0xFFE8E8E8),
      body: BlocBuilder<RolesBloc, RolesState>(
        builder: (context, state) {
          if (state is RolesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is RolesError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (state is RolesLoaded) {
            final roles = state.roles;

            final filteredRoles = roles
                .where((r) => r.name
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase()))
                .toList();

            final paginatedRoles =
                filteredRoles.take(_rolesToShow).toList();

            final allRolesLoaded =
                _rolesToShow >= filteredRoles.length;

            return Stack(
              children: [
                SingleChildScrollView(
                  controller: _scrollController,
                  padding:
                      const EdgeInsets.fromLTRB(16, 16, 16, 90),
                  child: Column(
                    children: [
                      Buscar(
                        hintText: "Buscar rol...",
                        onChanged: (value) =>
                            setState(() => _searchQuery = value),
                      ),
                      const SizedBox(height: 20),

                      if (paginatedRoles.isNotEmpty)
                        ...paginatedRoles
                            .map((r) => RoleCardWidget(role: r))
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
                                  style: TextStyle(
                                      color: Color(0xFFB20000)),
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
                      onTap: () =>
                          setState(() => _menuOpen = false),
                      child: Container(color: Colors.black45),
                    ),
                  ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),

      /// ⛔ ESTE ERA EL PROBLEMA DEL CRASH → AGREGAMOS heroTag ÚNICO
      floatingActionButton: FloatingActionButton(
        heroTag: "roles_fab",
        onPressed: _scrollToTop,
        backgroundColor: const Color(0xFFB20000),
        child: const Icon(Icons.arrow_upward, color: Colors.white),
      ),
    );
  }
}

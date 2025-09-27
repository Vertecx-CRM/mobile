import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vertecx/data/models/users/user_model.dart';
import '../widgets/usersWidgets/user_card_widget.dart';
import '../widgets/components/search/search.dart';
import '../widgets/components/header/header.dart';
import '../../data/repositories/userRepositories/bloc/user_bloc.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  int _usersToShow = 4;
  String _searchQuery = "";

  void _loadMoreUsers(int totalUsers) {
    setState(() {
      _usersToShow = (_usersToShow + 2).clamp(0, totalUsers);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserBloc()..add(LoadUsers()),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserLoaded) {
              // 🔎 Filtrar usuarios por búsqueda
              final filteredUsers = state.users
                  .where((u) => u.matchesQuery(_searchQuery))
                  .toList();

              final users = filteredUsers.take(_usersToShow).toList();
              final allUsersLoaded = _usersToShow >= filteredUsers.length;

              return SingleChildScrollView(
                child: Column(
                  children: [
                    // 🔹 encabezado de primeras
                    const HearderUser(
                      title: "Usuarios",
                      iconPath: "assets/icons/userP.png",
                    ),

                    const SizedBox(height: 20),

                    // 🔹 buscador
                    Buscar(
                      hintText: "Buscar usuario...",
                      onChanged: (value) {
                        setState(() => _searchQuery = value);
                      },
                    ),

                    const SizedBox(height: 20),

                    // 🔹 lista de usuarios
                    ...users.map(
                      (user) => UserCardWidget(
                        user: user,
                        onToggleStatus: () {
                          context
                              .read<UserBloc>()
                              .add(ToggleUserStatus(user.id));
                        },
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 🔹 botón o mensaje final
                    if (filteredUsers.isNotEmpty)
                      if (!allUsersLoaded)
                        TextButton(
                          onPressed: () =>
                              _loadMoreUsers(filteredUsers.length),
                          child: Column(
                            children: [
                              Image.asset(
                                "assets/icons/Vector.png",
                                width: 20,
                                height: 20,
                              ),
                              const Text(
                                "Cargar más Usuarios",
                                style: TextStyle(color: Color(0xFFB20000)),
                              ),
                            ],
                          ),
                        )
                      else
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            "✅ Ya están todos los usuarios",
                            style: TextStyle(
                              color: Color(0xFFB20000),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                    else
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          "No se encontraron usuarios",
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                    const SizedBox(height: 40),
                  ],
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

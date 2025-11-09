import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vertecx/data/models/users/user_model.dart';
import 'package:vertecx/presentation/widgets/usersWidgets/user_card_widget.dart';
import 'package:vertecx/presentation/widgets/components/search/search.dart';
import 'package:vertecx/presentation/widgets/navigationWidgets/app_top_bar.dart';
import 'package:vertecx/data/repositories/userRepositories/bloc/user_bloc.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  int _usersToShow = 4;
  String _searchQuery = "";
  final ScrollController _scrollController = ScrollController();

  void _loadMoreUsers(int totalUsers) {
    setState(() {
      _usersToShow = (_usersToShow + 2).clamp(0, totalUsers);
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
    return BlocProvider(
      create: (_) => UserBloc()..add(LoadUsers()),
      child: Scaffold(
        appBar: const AppTopBar(title: 'Usuarios'),
        backgroundColor: const Color(0xFFE8E8E8),
        body: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserLoaded) {
              final filteredUsers = state.users
                  .where((u) => u.matchesQuery(_searchQuery))
                  .toList();

              final users = filteredUsers.take(_usersToShow).toList();
              final allUsersLoaded = _usersToShow >= filteredUsers.length;

              return SingleChildScrollView(
                controller: _scrollController,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      Buscar(
                        hintText: "Buscar usuario...",
                        onChanged: (value) {
                          setState(() => _searchQuery = value);
                        },
                      ),
                      const SizedBox(height: 20),
                      ...users.map(
                        (user) => UserCardWidget(
                          user: user,
                          onToggleStatus: () {
                            context.read<UserBloc>().add(
                                  ToggleUserStatus(user.id),
                                );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (filteredUsers.isNotEmpty)
                        if (!allUsersLoaded)
                          TextButton(
                            onPressed: () => _loadMoreUsers(filteredUsers.length),
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
                              "Ya están todos los usuarios",
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
                              color: Color(0xFFB20000),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _scrollToTop,
          backgroundColor: const Color(0xFFB20000),
          child: const Icon(Icons.arrow_upward, color: Colors.white),
        ),
      ),
    );
  }
}

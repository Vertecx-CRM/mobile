import 'package:flutter/material.dart';
import 'package:vertecx/presentation/widgets/app_top_bar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppTopBar(title: 'Mi Perfil', showBack: true),
      body: const Center(
        child: Text('Aquí mostrás datos del usuario / opciones'),
      ),
    );
  }
}

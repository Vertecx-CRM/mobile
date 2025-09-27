import 'package:flutter/material.dart';
import 'presentation/routes/app_routes.dart';
import 'presentation/pages/user_list_page.dart';


void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    title: 'Gestión de Usuarios App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal), 
      ),

      // --- Configuración de Rutas ---
      initialRoute: AppRoutes.home,
      routes: {
        // 1. Ruta de inicio (HomePage simple para navegar)
        AppRoutes.home: (context) => const HomePage(), 
        // 2. Ruta de la lista de usuarios (con tu contenido estático)
        AppRoutes.userList: (context) => UserListPage(), // Usamos la versión no-const
      },
    );
  }
}

// --- HOME PAGE PLACEHOLDER ---
// Una página simple para mostrar la navegación.
class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inicio de Frontend')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'La navegación y el Frontend están listos.', 
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.people),
              label: const Text('Ir a Lista de Usuarios (Static)'),
              onPressed: () {
                // Navegamos a la lista usando la ruta constante definida en app_routes.dart
                Navigator.of(context).pushNamed(AppRoutes.userList);
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

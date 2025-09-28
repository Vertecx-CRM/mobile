import 'package:flutter/material.dart';
import 'presentation/routes/app_routes.dart';
import 'presentation/pages/user_list_page.dart';
import 'presentation/pages/categoryProducts_list_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // --- Configuración de Rutas ---
      initialRoute: AppRoutes.home,
      routes: {
        AppRoutes.home: (context) => const HomePage(), 
        AppRoutes.userList: (context) => UserListPage(), 
        AppRoutes.categoryProduct: (context) => const CategoryProductListPage(),
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
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // 🔹 Botón para ir a usuarios
            ElevatedButton.icon(
              icon: const Icon(Icons.people),
              label: const Text('Ir a Lista de Usuarios'),
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.userList);
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 Botón para ir a categorías
            ElevatedButton.icon(
              icon: const Icon(Icons.category),
              label: const Text('Ir a Categorías de Productos'),
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.categoryProduct);
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:vertecx/presentation/widgets/techniciansWidgets/technicians_card_widget.dart';
import '../widgets/components/header/header.dart';
import '../widgets/components/search/search.dart';
import 'package:vertecx/data/mocks/technicians_mock_data.dart';

class TechniciansPage extends StatefulWidget {
  const TechniciansPage({super.key});

  @override
  State<TechniciansPage> createState() => _TechniciansPageState();
}

class _TechniciansPageState extends State<TechniciansPage> {
  final ScrollController _scrollController = ScrollController();
  int _techniciansToShow = 4; // cantidad inicial de técnicos
  String _searchQuery = "";

  void _loadMoreTechnicians() {
    setState(() {
      _techniciansToShow = (_techniciansToShow + 2).clamp(
        0,
        mockTechnicians.length,
      );
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
    // filtrar técnicos por búsqueda
    final filteredTechnicians = mockTechnicians
        .where((t) => t.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    final technicians = filteredTechnicians.take(_techniciansToShow).toList();
    final allTechniciansLoaded =
        _techniciansToShow >= filteredTechnicians.length;

    return Scaffold(
      backgroundColor: const Color(0xFFE8E8E8),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            // encabezado
            const HearderUser(
              title: "Técnicos",
              iconPath: "assets/icons/userP.png",
              titleSize: 30,
            ),

            const SizedBox(height: 20),

            // buscador
            Buscar(
              hintText: "Buscar técnico...",
              onChanged: (value) {
                setState(() => _searchQuery = value);
              },
            ),

            const SizedBox(height: 20),

            // lista de técnicos filtrados
            if (technicians.isNotEmpty)
              ...technicians.map((t) => TechnicianCardWidget(technician: t))
            else
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  "No se encontraron técnicos",
                  style: TextStyle(
                    color: Color(0xFFB20000),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

            const SizedBox(height: 20),

            // botón o mensaje final
            if (filteredTechnicians.isNotEmpty)
              if (!allTechniciansLoaded)
                TextButton(
                  onPressed: _loadMoreTechnicians,
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/icons/Vector.png",
                        width: 20,
                        height: 20,
                      ),
                      const Text(
                        "Cargar más técnicos",
                        style: TextStyle(color: Color(0xFFB20000)),
                      ),
                    ],
                  ),
                )
              else
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "Ya están todos los técnicos",
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

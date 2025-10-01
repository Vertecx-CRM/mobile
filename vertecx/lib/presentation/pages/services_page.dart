import 'package:flutter/material.dart';
import 'package:vertecx/data/mocks/services_mock_data.dart';
import 'package:vertecx/presentation/widgets/servicesWidgets/services_card_widget.dart';
import '../widgets/components/header/header.dart';
import '../widgets/components/search/search.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  final ScrollController _scrollController = ScrollController();
  int _servicesToShow = 4; // cantidad inicial de servicios
  String _searchQuery = "";

  void _loadMoreServices() {
    setState(() {
      _servicesToShow = (_servicesToShow + 2).clamp(0, mockServices.length);
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
    // filtrar servicios por búsqueda
    final filteredServices = mockServices
        .where((s) => s.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    final services = filteredServices.take(_servicesToShow).toList();
    final allServicesLoaded = _servicesToShow >= filteredServices.length;

    return Scaffold(
      backgroundColor: const Color(0xFFE8E8E8),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            // encabezado
            const HearderUser(
              title: "Servicios",
              iconPath:
                  "assets/icons/userP.png", // cambia el ícono si lo tienes
              titleSize: 30,
            ),

            const SizedBox(height: 20),

            // buscador
            Buscar(
              hintText: "Buscar servicio...",
              onChanged: (value) {
                setState(() => _searchQuery = value);
              },
            ),

            const SizedBox(height: 20),

            // lista de servicios filtrados
            if (services.isNotEmpty)
              ...services.map((s) => ServiceCardWidget(service: s))
            else
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  "No se encontraron servicios",
                  style: TextStyle(
                    color: Color(0xFFB20000),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

            const SizedBox(height: 20),

            // botón o mensaje final
            if (filteredServices.isNotEmpty)
              if (!allServicesLoaded)
                TextButton(
                  onPressed: _loadMoreServices,
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/icons/Vector.png",
                        width: 20,
                        height: 20,
                      ),
                      const Text(
                        "Cargar más servicios",
                        style: TextStyle(color: Color(0xFFB20000)),
                      ),
                    ],
                  ),
                )
              else
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "Ya están todos los servicios",
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

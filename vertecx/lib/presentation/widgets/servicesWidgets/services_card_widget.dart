import 'package:flutter/material.dart';
import 'package:vertecx/data/models/services/service_model.dart';

class ServiceCardWidget extends StatelessWidget {
  final ServiceModel service;

  const ServiceCardWidget({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen del servicio
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              service.image,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(width: 14),

          // Información
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nombre
                Text(
                  service.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),

                // ID
                Text(
                  "ID: ${service.id}",
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 6),

                // Tipo
                Text(
                  service.type.name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: service.type.color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

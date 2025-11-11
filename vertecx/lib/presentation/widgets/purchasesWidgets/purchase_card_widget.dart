import 'package:flutter/material.dart';
import 'package:vertecx/presentation/animations/animated_status_chip.dart';
import 'package:vertecx/presentation/helpers/app_dialogs.dart';
import '../../../data/models/purchases/purchase_model.dart';

class PurchaseCardWidget extends StatelessWidget {
  final PurchaseModel compra;
  final VoidCallback? onToggleStatus;

  const PurchaseCardWidget({
    super.key,
    required this.compra,
    this.onToggleStatus,
  });

  // 🔹 Colores de estado (igual al UserCard)
  Color _getStatusColor(PurchaseStatus status) {
    return status == PurchaseStatus.Approved
        ? const Color(0xFFD2F5D3)
        : const Color(0xABFF8888);
  }

  Color _getStatusTextColor(PurchaseStatus status) {
    return status == PurchaseStatus.Approved
        ? const Color(0xFF168700)
        : const Color(0xFF870000);
  }

  @override
  Widget build(BuildContext context) {
    final statusBgColor = _getStatusColor(compra.estado);
    final statusTextColor = _getStatusTextColor(compra.estado);

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 15),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color(0xFFF4F4F4),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔹 Encabezado con imagen y datos principales
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 🔹 Información principal
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "OC #${compra.id}",
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 20,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              // Chip animado reutilizable
                              AnimatedStatusChip(
                                label: compra.estadoTexto,
                                bgColor: statusBgColor,
                                textColor: statusTextColor,
                                onPressed: () {
                                  if (onToggleStatus == null) return;
                                  AppDialogs.showConfirmChangeStatus(
                                    context: context,
                                    title: "Confirmar cambio de estado",
                                    message:
                                        compra.estado == PurchaseStatus.Approved
                                        ? "¿Deseas marcar la compra #${compra.id} como REVOCADA?"
                                        : "¿Deseas marcar la compra #${compra.id} como APROBADA?",
                                    onConfirm: () {
                                      onToggleStatus!();
                                      AppDialogs.showSuccessMessage(
                                        context,
                                        "Estado de la compra #${compra.id} cambiado correctamente.",
                                      );
                                    },
                                  );
                                },
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: const Color(0xFFE8E8E8),
                                ),
                                child: Text(
                                  compra.proveedor,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // 🔹 Detalles de la compra
                _buildDetailRow(
                  iconPath: "assets/icons/dinero.png",
                  text: "Total: ${compra.precioFormateado}",
                ),
                const SizedBox(height: 10),
                _buildDetailRow(
                  iconPath: "assets/icons/calendario.png",
                  text: "Fecha: ${compra.fechaFormateada}",
                ),
                const SizedBox(height: 10),
                _buildDetailRow(
                  iconPath: "assets/icons/factura.png",
                  text: "Factura: ${compra.factura}",
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildDetailRow({required String iconPath, required String text}) {
    return Row(
      children: [
        Image.asset(iconPath, width: 20, height: 20),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: Color(0xFF797979)),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

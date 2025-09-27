import 'package:flutter/material.dart';
import '../../../data/models/users/user_model.dart';
import '../../helpers/app_dialogs.dart';

class UserCardWidget extends StatelessWidget {
  final UserModel user;
  final VoidCallback? onToggleStatus;

  const UserCardWidget({super.key, required this.user, this.onToggleStatus});

  Color _getStatusColor(UserStatus status) {
    return status == UserStatus.activo
        ? const Color(0xFF7DFF7B)
        : const Color(0x68FF8888);
  }

  Color _getStatusTextColor(UserStatus status) {
    return status == UserStatus.activo
        ? const Color(0xFF168700)
        : const Color(0xFF870000);
  }

  @override
  Widget build(BuildContext context) {
    final statusBgColor = _getStatusColor(user.estado);
    final statusTextColor = _getStatusTextColor(user.estado);

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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/icons/userP.png",
                      width: 60,
                      height: 60,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.nombreCompleto,
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 20,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              // 🔹 Botón con efecto de escala
                              _AnimatedStatusChip(
                                label: user.statusString,
                                bgColor: statusBgColor,
                                textColor: statusTextColor,
                                onPressed: () {
                                  if (onToggleStatus == null) return;
                                  AppDialogs.showConfirmChangeStatus(
                                    context: context,
                                    title: "Confirmar cambio",
                                    message: user.estado == UserStatus.activo
                                        ? "¿Quieres marcar a ${user.nombreCompleto} como INACTIVO?"
                                        : "¿Quieres marcar a ${user.nombreCompleto} como ACTIVO?",
                                    onConfirm: () {
                                      onToggleStatus!();
                                      AppDialogs.showSuccessMessage(
                                        context,
                                        "Estado de ${user.nombreCompleto} cambiado correctamente",
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
                                  user.roleString,
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
                _buildContactRow(
                  iconPath: "assets/icons/usarioC.png",
                  text: user.documentoId,
                ),
                const SizedBox(height: 10),
                _buildContactRow(
                  iconPath: "assets/icons/celular.png",
                  text: user.telefono,
                ),
                const SizedBox(height: 10),
                _buildContactRow(
                  iconPath: "assets/icons/email.png",
                  text: user.email,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildContactRow({required String iconPath, required String text}) {
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

/// 🔹 Chip animado reutilizable
class _AnimatedStatusChip extends StatefulWidget {
  final String label;
  final Color bgColor;
  final Color textColor;
  final VoidCallback onPressed;

  const _AnimatedStatusChip({
    required this.label,
    required this.bgColor,
    required this.textColor,
    required this.onPressed,
  });

  @override
  State<_AnimatedStatusChip> createState() => _AnimatedStatusChipState();
}

class _AnimatedStatusChipState extends State<_AnimatedStatusChip> {
  double _scale = 1.0;

  void _onTapDown(TapDownDetails details) {
    setState(() => _scale = 0.9); // se reduce al 90%
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _scale = 1.0); // vuelve al 100%
    widget.onPressed();
  }

  void _onTapCancel() {
    setState(() => _scale = 1.0); // vuelve si se cancela
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: widget.bgColor,
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              color: widget.textColor,
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}

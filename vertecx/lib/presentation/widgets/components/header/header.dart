import 'package:flutter/material.dart';

class HearderUser extends StatelessWidget {
  final String title;
  final String iconPath;

  const HearderUser({
    super.key,
    required this.title,
    required this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // ocupa todo el ancho
      height: 69,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
        color: Color(0xfff3f3f3),
      ),
      child: Row(
        children: [
          // 🔹 Título centrado
          Expanded(
            child: Center(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFFB20000),
                ),
              ),
            ),
          ),

          // 🔹 Icono a la derecha
          Padding(
            padding: const EdgeInsets.only(right: 10, bottom: 2),
            child: SizedBox(
              width: 40,
              height: 40,
              child: Image.asset(
                iconPath,
                width: 40,
                height: 40,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

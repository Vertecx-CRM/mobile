import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onItemTap,
    required this.onProfileTap,
    this.topRadius = 18,
  });

  final int currentIndex;
  final ValueChanged<int> onItemTap;
  final VoidCallback onProfileTap;
  final double topRadius;

  BottomNavigationBarItem _item(String path, String label) => BottomNavigationBarItem(
    icon: SvgPicture.asset(
      path, width: 24, height: 24,
      colorFilter: const ColorFilter.mode(Colors.black87, BlendMode.srcIn),
    ),
    activeIcon: SvgPicture.asset(
      path, width: 24, height: 24,
      colorFilter: const ColorFilter.mode(Color(0xFFB20000), BlendMode.srcIn),
    ),
    label: label,
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Material(
        elevation: 8,
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(topRadius),
            topRight: Radius.circular(topRadius),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(topRadius),
            topRight: Radius.circular(topRadius),
          ),
          child: Container(
            color: Colors.white,
            child: BottomNavigationBar(
              currentIndex: currentIndex,
              onTap: (i) {
                if (i == 4) {
                  onProfileTap();
                } else {
                  onItemTap(i);
                }
              },
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              elevation: 0,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              selectedItemColor: const Color(0xFFB20000),
              unselectedItemColor: Colors.black87,
              items: [
                _item('assets/image/truck.svg', 'Compras'),
                _item('assets/image/tag.svg', 'Ventas'),
                _item('assets/image/home.svg', 'Dashboard'),
                _item('assets/image/user.svg', 'Usuarios'),
                _item('assets/image/userPerfil.svg', 'Perfil'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

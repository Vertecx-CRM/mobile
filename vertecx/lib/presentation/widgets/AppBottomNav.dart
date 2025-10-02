import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.menuOpen,
    required this.onItemTap,
    required this.onMenuToggle,
    this.topRadius = 18,
  });

  final int currentIndex;
  final bool menuOpen;
  final ValueChanged<int> onItemTap;
  final VoidCallback onMenuToggle;
  final double topRadius;

  BottomNavigationBarItem _item(String path) => BottomNavigationBarItem(
    icon: SvgPicture.asset(
      path, width: 24, height: 24,
      colorFilter: const ColorFilter.mode(Colors.black87, BlendMode.srcIn),
    ),
    activeIcon: SvgPicture.asset(
      path, width: 24, height: 24,
      colorFilter: const ColorFilter.mode(Color(0xFFB20000), BlendMode.srcIn),
    ),
    label: '',
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
              currentIndex: menuOpen ? 4 : currentIndex,
              onTap: (i) => i == 4 ? onMenuToggle() : onItemTap(i),
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              elevation: 0,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              items: [
                _item('assets/image/truck.svg'),
                _item('assets/image/tag.svg'),
                _item('assets/image/home.svg'),
                _item('assets/image/user.svg'),
                _item('assets/image/menu.svg'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

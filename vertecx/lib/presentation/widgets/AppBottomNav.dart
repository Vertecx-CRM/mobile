import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({super.key, this.currentIndex = 2, this.onTap});

  final int currentIndex;
  final ValueChanged<int>? onTap;

  BottomNavigationBarItem _svgItem(String path) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        path,
        width: 24,
        height: 24,
        colorFilter: const ColorFilter.mode(Colors.black54, BlendMode.srcIn),
      ),
      activeIcon: SvgPicture.asset(
        path,
        width: 24,
        height: 24,
        colorFilter: const ColorFilter.mode(Color(0xFFB20000), BlendMode.srcIn),
      ),
      label: '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      elevation: 6,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: [
        _svgItem('assets/image/user.svg'),
        _svgItem('assets/image/tag.svg'),
        _svgItem('assets/image/home.svg'),
        _svgItem('assets/image/Vector.svg'),
        _svgItem('assets/image/menu.svg'),
      ],
    );
  }
}

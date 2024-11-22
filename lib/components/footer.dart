import 'package:flutter/material.dart';
import '../styles/footerStyle.dart';

class Footer extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const Footer({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home, size: FooterStyle.iconSize),
          label: 'Início',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.star, size: FooterStyle.iconSize),
          label: 'Minha Lista',
        ),
      ],
      selectedItemColor: FooterStyle.selectedItemColor,
      unselectedItemColor: FooterStyle.unselectedItemColor,
      selectedLabelStyle: FooterStyle.labelStyle,
      unselectedLabelStyle: FooterStyle.labelStyle.copyWith(color: Colors.grey),
      backgroundColor: Colors.black,
    );
  }
}
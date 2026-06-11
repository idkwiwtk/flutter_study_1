import 'package:flutter/material.dart';

class MenuItem {
  final IconData icon;
  final String label;

  const MenuItem({required this.icon, required this.label});
}

const List<MenuItem> menuItems = [
  MenuItem(icon: Icons.dashboard_outlined, label: '대시보드'),
  MenuItem(icon: Icons.people_outline, label: '사용자'),
  MenuItem(icon: Icons.settings_outlined, label: '설정'),
];

import 'package:flutter/material.dart';
import '../models/menu_items.dart';

class SideBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const SideBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      color: const Color(0xFF1E1E20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLogo(),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                return _buildMenuTile(index, menuItems[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(20, 28, 20, 0),
      child: Text(
        'MyApp',
        style: TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildMenuTile(int index, MenuItem item) {
    final bool selected = index == selectedIndex;

    return InkWell(
      onTap: () => onItemSelected(index),
      child: Container(
        color: selected ? const Color(0xFF3699FF) : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Icon(
              item.icon,
              size: 20,
              color: selected ? Colors.white : Colors.white60,
            ),
            const SizedBox(width: 12),
            Text(
              item.label,
              style: TextStyle(
                fontSize: 15,
                color: selected ? Colors.white : Colors.white60,
                fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

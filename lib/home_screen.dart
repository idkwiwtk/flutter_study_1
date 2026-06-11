import 'package:flutter/material.dart';
import 'widgets/side_bar.dart';
import 'pages/dashboard_page.dart';
import 'pages/users_page.dart';
import 'pages/setting_page.dart';
import 'pages/ble_scan_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    DashboardPage(),
    UsersPage(),
    SettingPage(),
    BleScanPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SideBar(
            selectedIndex: _selectedIndex,
            onItemSelected: (index) => setState(() => _selectedIndex = index),
          ),
          Expanded(
            child: Container(
              color: const Color(0xFFF5F8FA),
              child: IndexedStack(index: _selectedIndex, children: _pages),
            ),
          ),
        ],
      ),
    );
  }
}

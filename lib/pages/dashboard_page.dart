import 'package:flutter/material.dart';
import 'content_scaffold.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ContentScaffold(title: "Dashboard", child: Text("dashboard"));
  }
}

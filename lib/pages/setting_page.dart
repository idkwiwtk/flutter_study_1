import 'package:flutter/material.dart';
import 'content_scaffold.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ContentScaffold(title: "Settings", child: Text("settings"));
  }
}

import 'package:flutter/material.dart';
import 'content_scaffold.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ContentScaffold(title: "Users", child: Text("users"));
  }
}

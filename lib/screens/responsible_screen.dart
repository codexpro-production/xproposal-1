import 'package:flutter/material.dart';

class ResponsibleScreen extends StatelessWidget {
  const ResponsibleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ResponsibleScreen"),
      ),
      body: const Center(
        child: Text("This is the ResponsibleScreen"),
      ),
    );
  }
}

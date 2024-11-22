// xproposal_screen.dart
import 'package:flutter/material.dart';

class XProposalPage extends StatelessWidget {
  const XProposalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("X Proposal Page"),
      ),
      body: const Center(
        child: Text("This is the XProposalPage"),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class MessageView extends StatelessWidget {
  const MessageView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: const SafeArea(
            child: Column(
          children: [],
        )),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class ModalRemedyScreen extends StatelessWidget{
  const ModalRemedyScreen({super.key, required this.instructions, required this.remedy});

  final List<Map<String, dynamic>> instructions;
  final Map<String, dynamic> remedy;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(remedy['purpose'])
        ],
      ),
    );
  }
}
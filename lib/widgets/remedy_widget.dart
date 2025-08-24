import 'package:flutter/material.dart';
import 'package:home_heal/widgets/modal_remedy_screen.dart';

class RemedyWidget extends StatelessWidget{
  const RemedyWidget({super.key, required this.instructions, required this.remedy}): small = false;
  const RemedyWidget.small({super.key, required this.instructions, required this.remedy}): small = true;

  final List<Map<String, dynamic>> instructions;
  final Map<String, dynamic> remedy;
  final bool small;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showModalBottomSheet(context: context, builder: (ctx) => ModalRemedyScreen(instructions: instructions, remedy: remedy), useSafeArea: true, isScrollControlled: true),
      child: SizedBox(
        width: 100,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Text(remedy['purpose']),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Text('Effectiveness: ${remedy['effectiveness']}'),
                      Spacer(),
                      Icon(Icons.timer),
                      Text('${remedy['avg_duration'].toString()} minutes')
                    ],
                  ),
                  SizedBox(height: 10,),
                  Text(remedy['notes']),
                ],
              ),
            ),
          ),
        )
      ),
    );
  }
}
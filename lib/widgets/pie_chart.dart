import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:home_heal/models.dart';

class PieChartWidget extends StatefulWidget{
  const PieChartWidget(this.data, {super.key});

  final List<Map<String, dynamic>> data;

  @override
  State<PieChartWidget> createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends State<PieChartWidget> {
  Attributes chosenAttribute = Attributes.severity;

  List<PieChartSectionData> get pieChartSectionData{
    final List<PieChartSectionData> result = [];
    // final List<Enum> data = widget.data.map((value) {
    //   if (chosenAttribute == Attributes.severity){
    //     return getSeverity(value['severity']);
    //   }
    //   else if (chosenAttribute == Attributes.pains){
    //     return getPainType(value['pain_type']);
    //   }
    //   else if (chosenAttribute == Attributes.symptoms){
    //     return getSymptomType(value['symptom_type']);
    //   }
    //   else {
    //     return getSeverity(value['severity']);
    //   }
    // }).toList();
    // for (Enum value in data){
    //   PieChartSectionData(value: 1, radius: 40);
    // }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DropdownMenu(dropdownMenuEntries: [
          for (Attributes attribute in Attributes.values)
            DropdownMenuEntry(value: attribute, label: attribute.toString())
        ], 
        onSelected: (value) {
          setState(() {
            chosenAttribute = value??Attributes.severity;
          });
        },),
        PieChart(
          PieChartData(
            sections: pieChartSectionData,
          )
        )
      ],
    );
  }
}
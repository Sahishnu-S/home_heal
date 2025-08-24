import 'package:flutter/material.dart';
import 'package:home_heal/models.dart';

class RemedyModalSheet extends StatefulWidget{
  const RemedyModalSheet({super.key});

  @override
  State<RemedyModalSheet> createState() => _RemedyModalSheetState();
}

class _RemedyModalSheetState extends State<RemedyModalSheet> {
  Severity _severity = Severity.mild;
  Pains _pains = Pains.aching;
  Symptoms _symptom = Symptoms.fatigue;
  bool _isLoading = false;
  final TextEditingController _notesController = TextEditingController();

 @override
  void dispose() {
    super.dispose();
    _notesController.dispose();
  }

  void generate(){
    setState(() {
      _isLoading = true;
    });
    Navigator.of(context).pop({
      'generate': true,
      'severity': _severity.toString(),
      'pain_type': _pains.toString(),
      'symptom_type': _symptom.formattedSymptom(_symptom),
      'notes': _notesController.text
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text('Tell us how severe the symptom is: ${_severity.toString().substring(9)}'),
          ),
          Slider(
            value: getSeverityNumber(_severity), 
            onChanged: (value){
              setState(() {
                _severity = getSeverityFromDouble(value);
              });
            },
            label: _severity.toString().substring(9),
            min: 1,
            max: 10,
            divisions: 10,
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 8),
            child: DropdownMenu(
              label: Text('What kind of pain or discomfort is this remedy for?'),
              initialSelection: Pains.aching,
              onSelected: (value){
                if (value != null){
                  setState(() {
                    _pains = value;
                  });
                }
              },
              dropdownMenuEntries: [
                for (Pains pain in Pains.values)
                  DropdownMenuEntry(value: pain, label: pain.toString().substring(6))
              ]
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 8),
            child: DropdownMenu(
              label: Text('What kind of symptom did you experience?'),
              initialSelection: Symptoms.irritation,
              onSelected: (value){
                if (value != null){
                  setState(() {
                    _symptom = value;
                  });
                }
              },
              dropdownMenuEntries: [
                for (Symptoms symptom in Symptoms.values)
                  DropdownMenuEntry(value: symptom, label: symptom.formattedSymptom(symptom))
              ]
            ),
          ),
          IntrinsicHeight(child: TextField(decoration: InputDecoration(label: Text('Tell us more about what you want')), controller: _notesController, maxLines: 5,)),
          Expanded(
            child: Row(
              children: [
                Spacer(),
                OutlinedButton(onPressed: (){Navigator.of(context).pop({
                  'generate': false
                });}, child: Text("Cancel")),
                SizedBox(width: 20,),
                _isLoading? CircularProgressIndicator() : ElevatedButton(onPressed: generate, child: Text('Generate')),
              ],
            ),
          )
        ],
      ),
    );
  }
}
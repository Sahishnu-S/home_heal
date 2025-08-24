import 'package:flutter/material.dart';
import 'package:home_heal/main.dart';
import 'package:home_heal/models.dart';
// import 'package:home_heal/models.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ModalSheet extends StatefulWidget{
  final DateTime date;
  final TimeOfDay time;
  final String severity;
  final String painType;
  final String symptomType;
  final String duration;
  final String notes;
  final bool isEditing;
  final int? id;

  ModalSheet({super.key}):
    date = DateTime.now(),
    time = TimeOfDay.now(), 
    severity = '',
    painType = '',
    symptomType = '',
    duration = '',
    notes = '',
    isEditing = false,
    id = null;

  ModalSheet.editing({super.key, required Map<String, dynamic> data}):
    date = DateTime.tryParse(data['event_time'])??DateTime.now(),
    time = TimeOfDay.fromDateTime(DateTime.tryParse(data['event_time'])??DateTime.now()), 
    severity = data['severity']??'',
    painType = data['pain_type']??'',
    symptomType = data['symptom_type']??'',
    duration = (data['duration']??'').toString(),
    notes = data['notes']??'',
    isEditing = true,
    id = data['id'];

  @override
  State<ModalSheet> createState() => _ModalSheetState();
}

class _ModalSheetState extends State<ModalSheet> {
  DateTime eventDate = DateTime.now();
  TimeOfDay eventTime = TimeOfDay.now();
  bool _isLoading = false;
  Severity _severity = Severity.minimal;
  Symptoms _symptom = Symptoms.irritation;
  Pains _pains = Pains.aching;
  TextEditingController duration = TextEditingController();
  TextEditingController notes = TextEditingController();

  @override
  void initState() {
    super.initState();
    eventDate = widget.date;
    eventTime = widget.time;
    _severity = getSeverity(widget.severity);
    _symptom = getSymptomType(widget.symptomType);
    _pains = getPainType(widget.painType);
    duration = TextEditingController(text: widget.duration);
    notes = TextEditingController(text: widget.notes);
  }

  //Severity severity = Severity.mild;

  @override
  void dispose() {
    duration.dispose();
    notes.dispose();
    super.dispose();
  }

  void chooseDate() async {
    eventDate = await showDatePicker(context: context, firstDate: DateTime(DateTime.now().year -1), lastDate: DateTime.now(), currentDate: eventDate)?? eventDate;
    setState(() {});
  }
  void chooseTime () async {
    eventTime = await showTimePicker(context: context, initialTime: eventTime)?? eventTime;
    setState(() {});
  }

  get formattedEventTime {
    DateTime dateTimeEventTime = DateTime.now().copyWith(hour: eventTime.hour, minute: eventTime.minute);
    return DateFormat.jm().format(dateTimeEventTime);
  }

  void addEvent() async {
    setState(() {
      _isLoading = true;
    });

    final String finalDateTime = eventDate.copyWith(hour: eventTime.hour, minute: eventTime.minute).toIso8601String();
    try {
      if (!widget.isEditing){
        await supabase.from('symptoms').insert({
        'event_time': finalDateTime,
        'severity': _severity.toString().substring(9),
        'duration': int.tryParse(duration.text)?? 1,
        'symptom_type': _symptom.formattedSymptom(_symptom),
        'notes': notes.text,
        'pain_type': _pains.toString().substring(6)
        });
      } 
      else if (widget.id != null){
        await supabase.from('symptoms').update({
          'event_time': finalDateTime,
          'severity': _severity.toString().substring(9),
          'duration': int.tryParse(duration.text)?? 1,
          'symptom_type': _symptom.formattedSymptom(_symptom),
          'notes': notes.text,
          'pain_type': _pains.toString().substring(6)
        }).eq('id', widget.id!);
      }
      
      Navigator.pop(context, true);

    } on PostgrestException{
      if(context.mounted) {Navigator.of(context).pop();}
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(15),
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: chooseDate,
              splashColor: Theme.of(context).colorScheme.inversePrimary,
              child: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(border: BoxBorder.fromLTRB(bottom: BorderSide(color: Colors.grey))),
                alignment: Alignment.centerLeft,
                child: Text(DateFormat.yMMMEd().format(eventDate)),
              ),
            ),
            InkWell(
              onTap: chooseTime,
              splashColor: Theme.of(context).colorScheme.inversePrimary,
              child: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(border: BoxBorder.fromLTRB(bottom: BorderSide(color: Colors.grey))),
                alignment: Alignment.centerLeft,
                child: Text(formattedEventTime),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text('Rate the severity of the symptom: ${_severity.toString().substring(9)}'),
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
                label: Text('What kind of pain or discomfort did you experience?'),
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
            IntrinsicHeight(child: TextField(decoration: InputDecoration(label: Text('Duration (minutes)'), hint: Text('Default 1')), controller: duration, )),
            IntrinsicHeight(child: TextField(decoration: InputDecoration(label: Text('Notes')), controller: notes, maxLines: 5,)),
            Expanded(
              child: Row(
                children: [
                  Spacer(),
                  OutlinedButton(onPressed: (){Navigator.of(context).pop(false);}, child: Text("Cancel")),
                  SizedBox(width: 20,),
                  _isLoading? CircularProgressIndicator() : ElevatedButton(onPressed: addEvent, child: Text(widget.isEditing? 'Save Changes':'Add event')),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:home_heal/main.dart';
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
  TextEditingController severityController = TextEditingController();
  TextEditingController painType = TextEditingController();
  TextEditingController duration = TextEditingController();
  TextEditingController symptomType = TextEditingController();
  TextEditingController notes = TextEditingController();

  @override
  void initState() {
    super.initState();
    eventDate = widget.date;
    eventTime = widget.time;
    severityController = TextEditingController(text: widget.severity);
    painType = TextEditingController(text: widget.painType);
    duration = TextEditingController(text: widget.duration);
    symptomType = TextEditingController(text: widget.symptomType);
    notes = TextEditingController(text: widget.notes);
  }

  //Severity severity = Severity.mild;

  @override
  void dispose() {
    severityController.dispose();
    painType.dispose();
    duration.dispose();
    symptomType.dispose();
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
        'severity': severityController.text,
        'duration': int.tryParse(duration.text)?? 1,
        'symptom_type': symptomType.text,
        'notes': notes.text,
        'pain_type': painType.text
        });
      } 
      else if (widget.id != null){
        await supabase.from('symptoms').update({
          'event_time': finalDateTime,
          'severity': severityController.text,
          'duration': int.tryParse(duration.text)?? 1,
          'symptom_type': symptomType.text,
          'notes': notes.text,
          'pain_type': painType.text
        }).eq('id', widget.id!);
      }
      
      Navigator.pop(context, true);

    } on PostgrestException catch (e) {
      print(e);
      if(context.mounted) {Navigator.of(context).pop();}
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.only(top: 15),
      // child: Column(
      //   children: [
          // Text("At what date and time did this happen?"),
          // Row(
          //   children: [
          //     InkWell(
          //       splashColor: Theme.of(context).colorScheme.inversePrimary,
          //       onTap: chooseDate,
          //       child: Container(
          //         padding: EdgeInsets.all(10),
          //         decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer),
          //         child: Text(DateFormat.yMMMEd().format(eventDate), style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer),)
          //       ),
          //     ),
          //     InkWell(
          //       splashColor: Theme.of(context).colorScheme.inversePrimary,
          //       onTap: chooseTime,
          //       child: Container(
          //         padding: EdgeInsets.all(10),
          //         decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer),
          //         child: Text(formattedEventTime, style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer),)
          //       ),
          //     ),
          //   ],
          // ),
          // Text('How severe was it?'),
          // DropdownMenu(
          //   dropdownMenuEntries: [
          //     DropdownMenuEntry(value: '', label: '')
          //   ]
          // ),
          // Expanded(
          //   child: GridView.custom(
          //     gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          //       maxCrossAxisExtent: 100,
          //       mainAxisSpacing: 5,
          //       crossAxisSpacing: 5,
          //     ), 
          //     childrenDelegate: SliverChildListDelegate([
          //       for (Severity value in Severity.values)
          //         RadioListTile(value: value, groupValue: severity, onChanged: (value){setState((){});}, title: Text(value.toString()),)
          //     ])
          //   ),
          // ),
          // Row(
          //   mainAxisSize: MainAxisSize.min,
          //   children: [
          //     for (Severity value in Severity.values)
          //       Expanded(child: RadioListTile(value: value, groupValue: severity, onChanged: (value){setState((){});}, title: Text(value.toString()),))
          //   ],
          // )
      //   ],
      // ),
      child: Column(
        children: [
          TextField(decoration: InputDecoration(label: Text(DateFormat.yMMMEd().format(eventDate)))),
          TextField(decoration: InputDecoration(label: Text(formattedEventTime)),),
          TextField(decoration: InputDecoration(label: Text('Severity')), controller: severityController),
          TextField(decoration: InputDecoration(label: Text('Pain Type')), controller: painType),
          TextField(decoration: InputDecoration(label: Text('Sypmptom type')), controller: symptomType),
          TextField(decoration: InputDecoration(label: Text('Notes')), controller: notes),
          TextField(decoration: InputDecoration(label: Text('Duration')), controller: duration),
          _isLoading? CircularProgressIndicator() : ElevatedButton(onPressed: addEvent, child: Text(widget.isEditing? 'Save Changes':'Add event')),
          OutlinedButton(onPressed: (){Navigator.of(context).pop(false);}, child: Text("Cancel"))
        ],
      ),
    );
  }
}
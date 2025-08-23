import 'package:flutter/material.dart';
import 'package:home_heal/main.dart';
// import 'package:home_heal/models.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ModalSheet extends StatefulWidget{
  const ModalSheet({super.key});

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
      await supabase.from('symptoms').insert({
        'event_time': finalDateTime,
        'severity': severityController.text,
        'duration': int.tryParse(duration.text)?? 20,
        'symptom_type': symptomType.text,
        'notes': notes.text,
        'pain_type': painType.text
      });
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
          TextField(decoration: InputDecoration(label: Text(DateFormat.yMMMEd().format(eventDate))),),
          TextField(decoration: InputDecoration(label: Text(formattedEventTime)),),
          TextField(decoration: InputDecoration(label: Text('Severity')),),
          TextField(decoration: InputDecoration(label: Text('Pain Type')),),
          TextField(decoration: InputDecoration(label: Text('Sypmptom type')),),
          TextField(decoration: InputDecoration(label: Text('Notes')),),
          TextField(decoration: InputDecoration(label: Text('Duration')),),
          _isLoading? CircularProgressIndicator() : ElevatedButton(onPressed: addEvent, child: Text('Add event')),
          OutlinedButton(onPressed: (){Navigator.of(context).pop(false);}, child: Text("Cancel"))
        ],
      ),
    );
  }
}
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:home_heal/main.dart';
import 'package:home_heal/widgets/remedy_modal_sheet.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RemediesScreen extends StatefulWidget{
  const RemediesScreen({super.key});

  @override
  State<RemediesScreen> createState() => _RemediesScreenState();
}

class _RemediesScreenState extends State<RemediesScreen> {
  final List<Widget> _currentRemedies = [];

  @override
  void initState() {
    super.initState();
    getCurrentRemedies();
  }

  void getCurrentRemedies() async {
    setState(() {
      _currentRemedies.clear();
      _currentRemedies.add(CircularProgressIndicator());
    });
    if (supabase.auth.currentUser!.userMetadata!['current_remedies'] != null && supabase.auth.currentUser!.userMetadata!['current_remedies'].length > 0){
      final List<Map<String, dynamic>> data = [];
      for (int i = 0; i > supabase.auth.currentUser!.userMetadata!['current_remedies'].length; i++){
        final List<Map<String, dynamic>> val = await supabase.from('remedies').select().eq('id', supabase.auth.currentUser!.userMetadata!['current_remedies'][i]);
        data.add(val[0]);
      }
      for (Map<String, dynamic> val in data){
        final List<Map<String, dynamic>> item = await supabase.from('instructions').select().eq('id', supabase.auth.currentUser!.userMetadata!['current_remedies'][i]);
      }
    }
  }

  void createRemedy() async {
    Map<String, dynamic>? data = await showModalBottomSheet(context: context, builder: (ctx) => RemedyModalSheet(), useSafeArea: true, isScrollControlled: true);
    if (data == null || data['generate'] == null || !data['generate']){
      return;
    }
    final FunctionResponse response1 = await supabase.functions.invoke(
      'get_remedy',
      body: {
        'severity': data['severity'],
        'pain_type': data['pain_type'],
        'symptom_type': data['symptom_type'],
        'notes': data['notes']
      }
    );
    var result = jsonDecode(response1.data['text']['content']);
    final response = await supabase.from('remedies').insert({
      'effectiveness': result['effectiveness'],
      'avg_duration': result['avg_duration'],
      'total_duration': int.parse(result['total_duration']),
      'notes': result['notes'],
      'instruction_count': int.parse(result['length'])
    }).select('id');

    for (int i = 1; i <= int.parse(result['length']); i++){
      await supabase.from('instructions').insert({
        'ingredient': result['Instruction-$i']['ingredient_list'],
        'remedy_id': response[0]['id'],
        'day': int.parse(result['Instruction-$i']['day']),
        'time': result['Instruction-$i']['time'],
        'instructions': result['Instruction-$i']['instruction'] 
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Find your fix"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text("Remedies for you:", style: Theme.of(context).textTheme.displayMedium,),
            ),
            SizedBox(height: 6,),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _currentRemedies,
              ),
            )    
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createRemedy,
        tooltip: 'Generate a new remedy',
        child: Icon(Icons.smart_toy),
      ),
    );
  }
}
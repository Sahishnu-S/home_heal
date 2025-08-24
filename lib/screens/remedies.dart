import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:home_heal/main.dart';
import 'package:home_heal/widgets/drawer.dart';
import 'package:home_heal/widgets/remedy_modal_sheet.dart';
import 'package:home_heal/widgets/remedy_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RemediesScreen extends StatefulWidget{
  const RemediesScreen({super.key});

  @override
  State<RemediesScreen> createState() => _RemediesScreenState();
}

class _RemediesScreenState extends State<RemediesScreen> {
  final List<Widget> _currentRemedies = [];
  bool _isLoading = true;
  List<Map<String, dynamic>> _remedies = [];
  final List<Map<String, dynamic>> _instructions = [];

  @override
  void initState() {
    super.initState();
    getRemedies();
    // getCurrentRemedies();
  }

  void getRemedies() async {
    _remedies = await supabase.from('remedies').select().range(0, 10);
    for (int i = 0; i < _remedies.length; i++){
      List<Map<String, dynamic>> val = await supabase.from('instructions').select().eq('remedy_id', _remedies[i]['id']);
      for (Map<String, dynamic> value in val){_instructions.add(value);}
    }
    setState(() {
      _isLoading = false;
    });
  }

  void getCurrentRemedies() async {
    supabase.auth.currentUser!.userMetadata!['current_remedies'] = ['3fe509bf-162b-49e2-872f-4c9a5efc7045'];
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
        List<Map<String, dynamic>> items = [];
        for (int i = 0; i > int.parse(val['instruction_count']); i++){
          items = await supabase.from('instructions').select().eq('remedy_id', supabase.auth.currentUser!.userMetadata!['current_remedies'][i]);
        }
        print('I reached here');
        _currentRemedies.add(RemedyWidget.small(remedy: val, instructions: items,));
      }
    }
    // setState(() {
    //   _currentRemedies.removeAt(0);
    // });
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
      'instruction_count': int.parse(result['length']),
      'purpose': data['symptom_type']
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
        actions: [
          IconButton(onPressed: getCurrentRemedies, icon: Icon(Icons.refresh))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text("Remedies for you:", style: Theme.of(context).textTheme.titleLarge,),
            ),
            SizedBox(height: 6,),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [],
              ),
            ),
            _isLoading? CircularProgressIndicator(): SizedBox(
              height: 600,
              child: ListView.builder(itemCount: _remedies.length, itemBuilder: (ctx, i){
                return RemedyWidget(instructions: _instructions, remedy: _remedies[i]);
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createRemedy,
        tooltip: 'Generate a new remedy',
        child: Icon(Icons.smart_toy),
      ),
      drawer: StyledDrawer(),
    );
  }
}
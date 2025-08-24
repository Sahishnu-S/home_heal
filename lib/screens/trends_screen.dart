import 'package:flutter/material.dart';
import 'package:home_heal/main.dart';
import 'package:home_heal/widgets/add_event_button.dart';
import 'package:home_heal/widgets/drawer.dart';
import 'package:home_heal/widgets/histogram.dart';
import 'package:intl/intl.dart';

class TrendsScreen extends StatefulWidget{
  const TrendsScreen({super.key});

  @override
  State<TrendsScreen> createState() => _TrendsScreenState();
}

class _TrendsScreenState extends State<TrendsScreen> {
  DateTime chosenDateTime = DateTime.now().copyWith(month: DateTime.now().month-1, hour: 0, minute: 0);
  final List<Map<String, dynamic>> data = [];

  Future<bool> getData() async {
    data.clear();
    List<Map<String, dynamic>> result = await supabase.from('symptoms').select().gte('event_time', chosenDateTime.toIso8601String());
    for (Map<String, dynamic> value in result){
      data.add(value);
    }
    print(data.length);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your data'),
      ),
      drawer: StyledDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () async {
              chosenDateTime = await showDatePicker(context: context, firstDate: DateTime.now().copyWith(year: DateTime.now().year-5), lastDate: DateTime.now(), initialDate: chosenDateTime)??DateTime.now().copyWith(month: DateTime.now().month-1);
              setState(() {});
            },
            child: Container(
              padding: EdgeInsets.all(12),
              width: double.infinity,
              decoration: BoxDecoration(gradient: LinearGradient(colors: [Theme.of(context).colorScheme.primaryContainer.withAlpha(200), Theme.of(context).colorScheme.primaryContainer.withAlpha(120)])),
              child: Text('Showing results from ${DateFormat('EEEE, dd MMMM yyyy').format(chosenDateTime)}')
            ),
          ),
          SizedBox(height: 20,),
          FutureBuilder(
            future: getData(),
            builder: (context, asyncSnapshot) {
              if (asyncSnapshot.hasData && asyncSnapshot.data!){
                return Expanded(
                  child: Column(
                    children: [
                      Histogram(data),
                      
                    ],
                  ),
                );
              }
              else {
                return CircularProgressIndicator();
              }
            }
          ),
        ],
      ),
      floatingActionButton: AddEventButton((){setState(() {});}),
    );
  }
}
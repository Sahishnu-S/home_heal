import 'package:flutter/material.dart';
import 'package:home_heal/main.dart';
import 'package:home_heal/widgets/add_event_button.dart';
import 'package:home_heal/widgets/drawer.dart';
import 'package:home_heal/widgets/log_item.dart';
import 'package:home_heal/widgets/modal_sheet.dart';

class LogPage extends StatefulWidget{
  const LogPage({super.key});

  @override
  State<StatefulWidget> createState() => _LogPageState();
}

class _LogPageState extends State<LogPage>{
  bool _isLodaing = false;
  final ScrollController _scrollController = ScrollController();
  int itemCount = 0;
  final List<Map<String, dynamic>> symptoms = [];

  @override
  void initState() {
    super.initState();
    getMoreItems();
    _scrollController.addListener((){
      if (_scrollController.offset == _scrollController.position.maxScrollExtent){
        getMoreItems();
      }
    });
  }

  void getMoreItems() async {
    setState(() {
      _isLodaing = true;
    });
    final List<Map<String, dynamic>> data = await supabase.from('symptoms').select().order('event_time').range(itemCount, itemCount+10);
    itemCount += (data.length);
    for (var entry in data){
      symptoms.add(entry);
    }
    setState(() {
      _isLodaing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Logs"),
        actions: [
          IconButton(icon: Icon(Icons.refresh), onPressed: (){
            symptoms.clear();
            itemCount = 0;
            getMoreItems();
          })
        ],
      ),
      drawer: StyledDrawer(),
      body: Column(
        children: [
          Expanded(
            child: !(itemCount == 0 && !_isLodaing)? ListView.builder(controller: _scrollController, itemCount: itemCount, itemBuilder: (ctx, index){

              return InkWell(
                onTap: () async {
                  bool? result = await showModalBottomSheet(isScrollControlled: true, useSafeArea: true, context: context, builder: (ctx) => ModalSheet.editing(data: symptoms[index]));
                  result?? false? setState((){}): null;
                },
                child: LogItem(symptoms[index])
              );
            }): Padding(
              padding: const EdgeInsets.all(10),
              child: Center(child: Text('No results found. Try adding some using the button at the bottom of the screen')),
            ),
          ),
          _isLodaing? CircularProgressIndicator():SizedBox()
        ]
      ),
      floatingActionButton: AddEventButton((){setState(() {});}),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
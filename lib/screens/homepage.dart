import 'package:flutter/material.dart';
import 'package:home_heal/widgets/modal_sheet.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  void refreshScreen(){setState((){});}

  void addEvent() async {
    final bool success = await showModalBottomSheet(
      context: context, 
      builder: (ctx) => ModalSheet(),
      useSafeArea: true,
      isScrollControlled: true
    );
    success? refreshScreen(): null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('lib\\assets\\images\\App_Icon.png')
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        tooltip: 'Add event',
        child: const Icon(Icons.add),
      ),
    );
  }
}
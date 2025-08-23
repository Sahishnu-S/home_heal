import 'package:flutter/material.dart';
import 'package:home_heal/widgets/add_event_button.dart';
import 'package:home_heal/widgets/drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  void refreshScreen(){setState((){});}

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
      floatingActionButton: AddEventButton(refreshScreen),
      drawer: StyledDrawer(),
    );
  }
}
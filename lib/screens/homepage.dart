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
    final bool? success = await showModalBottomSheet(
      context: context, 
      builder: (ctx) => ModalSheet(),
      useSafeArea: true,
      isScrollControlled: true
    );
    success?? false? refreshScreen(): null;
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
        onPressed: addEvent,
        tooltip: 'Add event',
        child: const Icon(Icons.add),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary.withValues(alpha: 0.7),
                      Theme.of(context).colorScheme.primary.withValues(alpha: 0.95),
                    ]
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.health_and_safety, size: 44,),
                    SizedBox(width: 12,),
                    Text("Always there", style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Theme.of(context).colorScheme.onPrimary, fontSize: 35),)
                  ],
                ),
              ),
            ),
            ListTile(title: Text('Logs'), onTap: () {
              
            },)
          ]
        ),
      ),
    );
  }
}
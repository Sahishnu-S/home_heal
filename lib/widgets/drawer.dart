import 'package:flutter/material.dart';
import 'package:home_heal/screens/homepage.dart';
import 'package:home_heal/screens/logs.dart';
import 'package:home_heal/screens/trends_screen.dart';

class StyledDrawer extends StatelessWidget{
  const StyledDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
          ListTile(title: Text('Home'), trailing: Icon(Icons.home), onTap: () {
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => HomePage()), (route) => false,);
          },),
          ListTile(title: Text('Logs'), trailing: Icon(Icons.list), onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (ctx) => LogPage()));
          },),
          ListTile(title: Text('Insights'), trailing: Icon(Icons.trending_up_outlined), onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (ctx) => TrendsScreen()));
          },),
          ListTile(title: Text('Remedies'), trailing: Icon(Icons.medical_information), onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (ctx) => TrendsScreen()));
          },),
        ]
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:home_heal/main.dart';

class ErrorScreen extends StatelessWidget{
  const ErrorScreen({super.key});



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('lib\\assets\\images\\App_Icon.png'),
            Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 8),
              child: Text('Uh oh... Something went wrong. If this issue persists try signing out and then signing back in.'),
            ),
            ElevatedButton(onPressed: (){supabase.auth.signOut();}, child: Text('Sign out'))
          ],
        )
      ),
    );
  }
}
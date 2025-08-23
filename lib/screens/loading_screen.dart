import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget{
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('lib\\assets\\images\\App_Icon.png'),
            CircularProgressIndicator()
          ],
        )
      ),
    );
  }
}
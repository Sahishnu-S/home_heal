import 'package:flutter/material.dart';

class RemediesScreen extends StatefulWidget{
  const RemediesScreen({super.key});

  @override
  State<RemediesScreen> createState() => _RemediesScreenState();
}

class _RemediesScreenState extends State<RemediesScreen> {
  void createRemedy() async {

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
            Text("Remedies for you")
            
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: createRemedy),
    );
  }
}
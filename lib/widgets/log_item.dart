import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LogItem extends StatelessWidget{
  const LogItem(this.data, {super.key});

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 8),
      child: Card(
        key: ValueKey(data['id']),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 12),
                  Icon(Icons.access_time, color: Colors.deepPurple, size: 20),
                  SizedBox(width: 4),
                  Text(
                    DateFormat('EEEE, dd MMMM yyyy, hh:mm a').format(DateTime.tryParse(data['event_time'])??DateTime.now()),
                    style: TextStyle(color: Colors.grey[700]),
                  )
                ],
              ),
              SizedBox(height: 8,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('${data['symptom_type']}: ${data['severity']}', style: Theme.of(context).textTheme.bodyLarge),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.timer, color: Colors.blueAccent, size: 20),
                      SizedBox(width: 4),
                      Text(
                        '${data['duration']} min',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ]
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.healing, color: Colors.redAccent, size: 20),
                      SizedBox(width: 4),
                      Text(
                        data['pain_type'],
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ]
                  ),
                ],
              ),
              SizedBox(height: 15,),
              Container(
                padding: EdgeInsetsDirectional.symmetric(vertical: 5, horizontal: 4),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(border: BoxBorder.fromLTRB(top: BorderSide(width: 1))),
                child: Text(data['notes']), 
              )
            ],
          ),
        )
      ),
    );
  }
}
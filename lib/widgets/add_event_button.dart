import 'package:flutter/material.dart';
import 'package:home_heal/widgets/modal_sheet.dart';

class AddEventButton extends StatelessWidget{
  const AddEventButton(this.refresh, {super.key});

  final void Function() refresh;

  void addEvent(context) async {
    final bool? success = await showModalBottomSheet(
      context: context, 
      builder: (ctx) => ModalSheet(),
      useSafeArea: true,
      isScrollControlled: true
    );
    success?? false? refresh(): null;
  }


  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: (){addEvent(context);},
      tooltip: 'Add event',
      child: const Icon(Icons.add),
    );
  }
}
import 'package:flutter/material.dart';

class DialogHeader extends StatelessWidget {
  final String title;

  const DialogHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(8.0)),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 3, 3, 3),
              child: Text(title, style: Theme.of(context).textTheme.headlineSmall),
            ),
          ),
        ),
        const Align(alignment: Alignment.topRight, child: CloseButton()),
      ],
    );
  }
}

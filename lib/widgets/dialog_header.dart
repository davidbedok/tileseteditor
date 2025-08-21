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
        Text(title, style: Theme.of(context).textTheme.headlineSmall),
        const Align(alignment: Alignment.topRight, child: CloseButton()),
      ],
    );
  }
}

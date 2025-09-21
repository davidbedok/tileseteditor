import 'package:flutter/material.dart';

class CliBox extends StatelessWidget {
  final List<String> texts;

  const CliBox({
    super.key, //
    required this.texts,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 63, 60, 60),
        border: BoxBorder.all(color: Colors.grey, width: 1.0),
        borderRadius: BorderRadius.circular(3.0),
        boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.5), spreadRadius: 2, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: RichText(
          textAlign: TextAlign.left,
          text: TextSpan(
            style: Theme.of(context).textTheme.bodyMedium,
            children: [
              for (String text in texts)
                TextSpan(
                  text: '> $text',
                  style: TextStyle(color: const Color.fromARGB(255, 208, 201, 201)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class FixedInformationBox extends StatelessWidget {
  final bool infoIcon;
  final List<InlineSpan> texts;

  const FixedInformationBox({
    super.key, //
    required this.texts,
    this.infoIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 250, 250, 250),
        border: BoxBorder.all(color: Colors.grey, width: 1.0),
        borderRadius: BorderRadius.circular(3.0),
        boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.5), spreadRadius: 2, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: RichText(
          textAlign: TextAlign.justify,
          text: TextSpan(
            style: Theme.of(context).textTheme.bodyMedium,
            children: [
              if (infoIcon) WidgetSpan(child: Icon(Icons.info_outline, size: 14, color: const Color.fromARGB(255, 64, 97, 123))),
              if (infoIcon) TextSpan(text: " "),
              for (InlineSpan span in texts) span,
            ],
          ),
        ),
      ),
    );
  }
}

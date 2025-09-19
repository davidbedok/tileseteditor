import 'package:flutter/material.dart';
import 'package:tileseteditor/widgets/dialog_header.dart';

class AppDialogWidget extends StatelessWidget {
  static final double space = 8.0;

  final String title;
  final double width;
  final bool enabled;
  final List<Widget> children;
  final String actionButton;
  final void Function() onAction;

  const AppDialogWidget({
    super.key,
    required GlobalKey<FormState> formKey,
    required this.title,
    required this.width,
    required this.children,
    required this.actionButton,
    required this.onAction,
    this.enabled = true,
  }) : _formKey = formKey;

  final GlobalKey<FormState> _formKey;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Theme(
        data: Theme.of(context),
        child: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.all(space),
            child: SizedBox(
              width: width,
              child: ListView(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: const [BoxShadow(color: Colors.grey, offset: Offset(8, 8), spreadRadius: 2, blurStyle: BlurStyle.solid)],
                    ),
                    padding: EdgeInsets.all(space),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DialogHeader(title: title),
                          SizedBox(height: space * 2),
                          for (var widget in children) widget,
                          SizedBox(height: space * 2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Close'),
                              ),
                              if (enabled)
                                Visibility(
                                  visible: enabled,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        onAction.call();
                                      }
                                    },
                                    child: Text(actionButton),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

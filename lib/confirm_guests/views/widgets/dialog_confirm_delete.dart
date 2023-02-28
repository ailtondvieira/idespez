import 'package:flutter/material.dart';

class DialogConfirmDelete extends StatelessWidget {
  final String text;
  final VoidCallback onPressedDelete;
  const DialogConfirmDelete({
    Key? key,
    required this.text,
    required this.onPressedDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        text,
      ),
      actions: <Widget>[
        TextButton(
          onPressed: onPressedDelete,
          child: const Text(
            "EXCLUIR",
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text(
            "CANCELAR",
          ),
        ),
      ],
    );
  }
}

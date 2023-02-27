import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FieldsAddExpense extends StatelessWidget {
  const FieldsAddExpense({
    Key? key,
    required this.titleController,
    required this.valueController,
  }) : super(key: key);

  final TextEditingController titleController;
  final TextEditingController valueController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          decoration: InputDecoration(
            hintText: 'Titulo',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          controller: titleController,
        ),
        const SizedBox(height: 10),
        TextFormField(
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            RealInputFormatter(),
          ],
          decoration: InputDecoration(
            hintText: 'Valor',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          controller: valueController,
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

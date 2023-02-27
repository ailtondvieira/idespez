import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FieldAddGuests extends StatelessWidget {
  const FieldAddGuests({
    Key? key,
    required this.nameController,
    required this.phoneController,
  }) : super(key: key);

  final TextEditingController nameController;
  final TextEditingController phoneController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          decoration: InputDecoration(
            hintText: 'Nome',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          controller: nameController,
        ),
        const SizedBox(height: 10),
        TextFormField(
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            TelefoneInputFormatter(),
          ],
          decoration: InputDecoration(
            hintText: 'Telefone',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          controller: phoneController,
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class CardTotalsMoney extends StatefulWidget {
  const CardTotalsMoney({
    Key? key,
    required this.totalString,
  }) : super(key: key);

  final String totalString;

  @override
  State<CardTotalsMoney> createState() => _CardTotalsMoneyState();
}

class _CardTotalsMoneyState extends State<CardTotalsMoney> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      elevation: 10,
      shadowColor: Colors.purple,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
        child: Text(
          widget.totalString,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

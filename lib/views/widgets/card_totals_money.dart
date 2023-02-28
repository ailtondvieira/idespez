import 'package:flutter/material.dart';

class CardTotalsMoney extends StatefulWidget {
  const CardTotalsMoney({
    Key? key,
    required this.totalString,
    required this.color,
  }) : super(key: key);

  final String totalString;
  final Color color;

  @override
  State<CardTotalsMoney> createState() => _CardTotalsMoneyState();
}

class _CardTotalsMoneyState extends State<CardTotalsMoney> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: widget.color,
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      elevation: 10,
      shadowColor: Colors.purple,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: Text(
          widget.totalString,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

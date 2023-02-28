import 'package:flutter/material.dart';

import '../../models/expense_model.dart';

class ListTileExpense extends StatelessWidget {
  const ListTileExpense({
    Key? key,
    required this.expense,
    required this.deleteExpense,
    required this.updateExpense,
  }) : super(key: key);

  final ExpenseModel expense;
  final VoidCallback deleteExpense;
  final VoidCallback updateExpense;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: Padding(
        padding: const EdgeInsets.only(top: 14),
        child: IconButton(
          icon: const Icon(
            Icons.delete_outline_outlined,
            color: Colors.black,
          ),
          onPressed: deleteExpense,
        ),
      ),
      leading: IconButton(
        color: expense.isPaid ? Colors.green : Colors.red,
        icon: const Icon(Icons.assignment_turned_in),
        onPressed: updateExpense,
      ),
      title: Text(expense.title),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "R\$ ${expense.value}",
          ),
          const Spacer(),
          Visibility(
            visible: expense.isPaid,
            replacement: const Text(
              '#PENDENTE',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            child: const Text(
              '#PAGO',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desafio_web_despesas/confirm_guests/views/widgets/body_confirm_guests.dart';
import 'package:flutter/material.dart';

import '../../models/expense_model.dart';
import 'card_totals_money.dart';
import 'fields_add_expense.dart';
import 'list_tile_expense.dart';

class BodyExpense extends StatefulWidget {
  const BodyExpense({Key? key}) : super(key: key);

  @override
  State<BodyExpense> createState() => _BodyExpenseState();
}

class _BodyExpenseState extends State<BodyExpense> {
  @override
  void initState() {
    getExpense();
    super.initState();
  }

  CollectionReference expensesCollection =
      FirebaseFirestore.instance.collection('expenses');

  final titleController = TextEditingController();
  final valueController = TextEditingController();

  double totalExpense = 0;
  double totalPending = 0;
  double totalPaid = 0;

  Future<void> addExpense() async {
    if (titleController.text.isEmpty || valueController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Os campos não podem ficarem vazio')),
      );
      return;
    }
    expensesCollection
        .add(ExpenseModel(
          title: titleController.text,
          value: double.tryParse(valueController.text.replaceAll('.', '')) ?? 0,
          isPaid: false,
        ).toMap())
        .then((value) => debugPrint("Expense Added"))
        .whenComplete(
      () {
        titleController.clear();
        valueController.clear();
        getExpense();
      },
    ).catchError((error) => debugPrint("Failed to add expense: $error"));
  }

  List<ExpenseModel> expensesList = [];
  Future<void> getExpense() async {
    return FirebaseFirestore.instance
        .collection('expenses')
        .get()
        .then((QuerySnapshot querySnapshot) {
      expensesList = [];
      totalExpense = 0;
      totalPaid = 0;
      totalPending = 0;

      for (var doc in querySnapshot.docs) {
        final expense = ExpenseModel(
          id: doc.reference.id,
          title: doc['title'],
          value: double.tryParse(doc['value'].toString()) ?? 0,
          isPaid: doc['isPaid'],
        );
        if (expense.isPaid) {
          totalPaid += expense.value;
        } else {
          totalPending += expense.value;
        }
        totalExpense += expense.value;

        expensesList.add(expense);
      }
    }).whenComplete(() => setState(() {}));
  }

  Future<void> updateExpense(String id, bool isPaid) async {
    expensesCollection
        .doc(id)
        .update({'isPaid': isPaid})
        .then((value) => debugPrint("Expense Updated"))
        .whenComplete(() => getExpense())
        .catchError((error) => debugPrint("Failed to update user: $error"));
  }

  Future<void> deleteUser(String id) async {
    expensesCollection
        .doc(id)
        .delete()
        .then((value) => debugPrint("Expense Deleted"))
        .whenComplete(() => getExpense())
        .catchError(
          (error) => debugPrint("Failed to delete user: $error"),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          FieldsAddExpense(
            titleController: titleController,
            valueController: valueController,
          ),
          ElevatedButton(
            style: ButtonStyle(
              padding: MaterialStateProperty.all(const EdgeInsets.all(20)),
              backgroundColor: MaterialStateProperty.all(Colors.purple),
            ),
            onPressed: () {
              addExpense();
            },
            child: const Text(
              "Adicionar despesa",
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: expensesList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                ExpenseModel expense = expensesList[index];
                return ListTileExpense(
                  expense: expense,
                  deleteExpense: () {
                    deleteUser(expense.id!);
                    setState(() {});
                  },
                  updateExpense: () {
                    updateExpense(expense.id!, !expense.isPaid);
                    setState(() {});
                  },
                );
              },
            ),
          ),
          Wrap(
            alignment: WrapAlignment.center,
            children: [
              CardTotalsMoney(totalString: 'Total Pago: $totalPaid'),
              CardTotalsMoney(totalString: 'Total Pendente : $totalPending'),
              CardTotalsMoney(totalString: 'Total: $totalExpense'),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BodyConfirmGuests(),
                ),
              );
            },
            style: ButtonStyle(
              padding: MaterialStateProperty.all(const EdgeInsets.all(20)),
              backgroundColor: MaterialStateProperty.all(Colors.purple),
            ),
            child: const Text(
              'Convidados',
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:desafio_web_despesas/views/expense_page_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyDXJumVxYDQwchYkEtmXAXX1ZBUgT5g_wo',
      appId: '1:1005941296376:web:caf7878a165a58b29c7f0d',
      messagingSenderId: '1005941296376',
      projectId: 'desafiodespesas',
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IDespez',
      theme: ThemeData(primarySwatch: Colors.pink),
      home: const ExpensePageView(),
    );
  }
}

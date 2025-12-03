import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:idcard/ScoolId.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'School Id',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.purple)),
      home: const SchoolId(),
    );
  }
}

import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const OperationQuimera());
}

class OperationQuimera extends StatelessWidget {
  const OperationQuimera({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Operación Quimera',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.red,
        useMaterial3: true,
      ),

      home: const HomeScreen(),
    );
  }
}
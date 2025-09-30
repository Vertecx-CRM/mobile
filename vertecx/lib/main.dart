import 'package:flutter/material.dart';
import 'package:vertecx/presentation/pages/OrderServicePage.dart';

void main() {
  runApp(const VertexcApp());
}

class VertexcApp extends StatelessWidget {
  const VertexcApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vertecx',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(foregroundColor: Colors.black),
      ),
      home: const OrderServicePage(),
    );
  }
}

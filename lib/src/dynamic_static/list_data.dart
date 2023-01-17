import 'package:flutter/material.dart';

class ListDataScreen extends StatelessWidget {
  final Widget widget;
  final String title;

  const ListDataScreen({super.key, required this.widget, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: widget,
    );
  }
}
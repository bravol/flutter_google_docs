import 'package:flutter/material.dart';

class DocumentScreen extends StatefulWidget {
  const DocumentScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  final String id;

  @override
  State<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('This is document screen'),
      ),
    );
  }
}

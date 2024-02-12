import 'package:flutter/material.dart';
import 'package:flutter_google_docs/colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DocumentScreen extends ConsumerStatefulWidget {
  const DocumentScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  final String id;

  @override
  ConsumerState<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends ConsumerState<DocumentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        elevation: 0,
        actions: [
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(
              Icons.lock,
              size: 16,
            ),
            label: const Text('Share'),
          ),
        ],
      ),
      body: Center(
        child: Text(widget.id),
      ),
    );
  }
}

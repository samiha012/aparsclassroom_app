import 'package:flutter/material.dart';

class ChapterListScreen extends StatelessWidget {
  final String subjectId;
  final String subjectName;
  
  const ChapterListScreen({
    super.key,
    required this.subjectId,
    required this.subjectName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(subjectName)),
      body: const Center(child: Text('Chapter List Screen - TODO')),
    );
  }
}

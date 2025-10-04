import 'package:flutter/material.dart';

class SubjectListScreen extends StatelessWidget {
  final String courseId;
  final String courseName;
  
  const SubjectListScreen({
    super.key,
    required this.courseId,
    required this.courseName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(courseName)),
      body: const Center(child: Text('Subject List Screen - TODO')),
    );
  }
}

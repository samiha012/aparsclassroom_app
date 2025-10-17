import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../injection_container.dart';

class RedeemCourseDialog extends StatefulWidget {
  final String courseId;
  const RedeemCourseDialog({super.key, required this.courseId});

  @override
  State<RedeemCourseDialog> createState() => _RedeemCourseDialogState();
}

class _RedeemCourseDialogState extends State<RedeemCourseDialog> {
  final TextEditingController _codeController = TextEditingController();
  bool _isLoading = false;

  Future<void> _redeemCourse() async {
    final dio = sl<Dio>(); 
    setState(() => _isLoading = true);

    try {
      final storage = const FlutterSecureStorage();
      final token = await storage.read(key: 'x-access-token');
      
      final response = await dio.post(
        '${ApiConstants.baseUrl}student/course/redeem',
        data: {'accessCode': _codeController.text.trim()},
        options: Options(
          headers: {
            'x-access-token': token,
          },
        ),
      );

      final data = response.data;
      if (data['success'] == true) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('✅ ${data['message']}')),
        );
        // Refresh enrolled list here
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('⚠️ ${data['message']}')),
        );
      }
    } on DioException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ ${e.response?.data['message'] ?? e.message}')),
      );
      print(
        'Error occurred while redeeming course: ${e.response?.data ?? e.message}',
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Enter Access Code'),
      content: TextField(
        controller: _codeController,
        decoration: const InputDecoration(hintText: 'Access Code'),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _redeemCourse,
          child: _isLoading
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Redeem'),
        ),
      ],
    );
  }
}
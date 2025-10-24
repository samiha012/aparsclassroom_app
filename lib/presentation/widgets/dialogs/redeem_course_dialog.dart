import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/enrollment/enrollment_bloc.dart';
import '../../../injection_container.dart' as di;

class RedeemCourseDialog extends StatefulWidget {
  final String courseName;

  const RedeemCourseDialog({
    super.key,
    required this.courseName,
  });

  @override
  State<RedeemCourseDialog> createState() => _RedeemCourseDialogState();
}

class _RedeemCourseDialogState extends State<RedeemCourseDialog> {
  final _accessCodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _accessCodeController.dispose();
    super.dispose();
  }

  String? _validateAccessCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter access code';
    }
    if (value.length < 6) {
      return 'Access code must be at least 6 characters';
    }
    return null;
  }

  void _handleRedeem(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<EnrollmentBloc>().add(
            RedeemCourseEvent(
              accessCode: _accessCodeController.text.trim(),
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<EnrollmentBloc>(),
      child: BlocConsumer<EnrollmentBloc, EnrollmentState>(
        listener: (context, state) {
          if (state is RedeemSuccess) {
            Navigator.of(context).pop(true); // Return true on success
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Course redeemed successfully!'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is RedeemError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is RedeemingCourse;

          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Column(
              children: [
                Icon(
                  Icons.card_giftcard,
                  size: 48,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Redeem Course',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.courseName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Enter your access code to enroll in this course',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _accessCodeController,
                    enabled: !isLoading,
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: 'Access Code',
                      hintText: 'Enter access code',
                      prefixIcon: const Icon(Icons.vpn_key),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: _validateAccessCode,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _handleRedeem(context),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: isLoading
                    ? null
                    : () {
                        Navigator.of(context).pop(false);
                      },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: isLoading ? null : () => _handleRedeem(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text('Redeem'),
              ),
            ],
          );
        },
      ),
    );
  }
}

// Helper function to show the dialog
Future<bool?> showRedeemCourseDialog(
  BuildContext context,
  String courseName,
) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) => RedeemCourseDialog(courseName: courseName),
  );
}
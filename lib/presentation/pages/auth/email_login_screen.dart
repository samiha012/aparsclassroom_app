// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../blocs/auth/auth_bloc.dart';
// import '../../../core/routes/app_router.dart';

// class EmailLoginScreen extends StatefulWidget {
//   const EmailLoginScreen({super.key});

//   @override
//   State<EmailLoginScreen> createState() => _EmailLoginScreenState();
// }

// class _EmailLoginScreenState extends State<EmailLoginScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _emailOrPhoneController = TextEditingController();
//   final _passwordController = TextEditingController();

//   bool _obscurePassword = true;
//   bool _showPasswordField = false;
//   bool _isLoading = false;

//   @override
//   void dispose() {
//     _emailOrPhoneController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   void _handleCheckUser() {
//     if (_formKey.currentState!.validate()) {
//       context.read<AuthBloc>().add(
//             CheckUserExistsEvent(
//               emailOrPhone: _emailOrPhoneController.text.trim(),
//             ),
//           );
//     }
//   }

//   void _handleLogin() {
//     if (_passwordController.text.isNotEmpty) {
//       context.read<AuthBloc>().add(
//             LoginEvent(
//               emailOrPhone: _emailOrPhoneController.text.trim(),
//               password: _passwordController.text.trim(),
//             ),
//           );
//     }
//   }

//   String? _validateEmailOrPhone(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Please enter your email or phone number';
//     }
//     if (!value.contains('@') && value.length < 10) {
//       return 'Please enter a valid email or phone';
//     }
//     return null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Sign In or Sign Up'),
//         centerTitle: true,
//       ),
//       body: BlocConsumer<AuthBloc, AuthState>(
//         listener: (context, state) {
//           if (state is AuthLoading) {
//             setState(() => _isLoading = true);
//           } else {
//             setState(() => _isLoading = false);
//           }

//           if (state is UserExistsCheck) {
//             // Step 2: show password field
//             setState(() {
//               _showPasswordField = true;
//             });
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text('Please enter your password')),
//             );
//           } else if (state is UserDoesNotExist) {
//             Navigator.pushReplacementNamed(context, AppRouter.signup,
//                 arguments: _emailOrPhoneController.text.trim());
//           } else if (state is Authenticated) {
//             Navigator.pushReplacementNamed(context, AppRouter.main);
//           } else if (state is AuthError) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text(state.message), backgroundColor: Colors.red),
//             );
//           }
//         },
//         builder: (context, state) {
//           return SafeArea(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.all(24),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     const SizedBox(height: 40),
//                     const Icon(Icons.person_outline,
//                         size: 80, color: Colors.blueAccent),
//                     const SizedBox(height: 40),

//                     // Email or phone
//                     TextFormField(
//                       controller: _emailOrPhoneController,
//                       enabled: !_isLoading && !_showPasswordField,
//                       decoration: InputDecoration(
//                         labelText: 'Email or Phone',
//                         prefixIcon: const Icon(Icons.email_outlined),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       validator: _validateEmailOrPhone,
//                       textInputAction: TextInputAction.next,
//                     ),

//                     if (_showPasswordField) ...[
//                       const SizedBox(height: 20),
//                       TextFormField(
//                         controller: _passwordController,
//                         obscureText: _obscurePassword,
//                         enabled: !_isLoading,
//                         decoration: InputDecoration(
//                           labelText: 'Password',
//                           prefixIcon: const Icon(Icons.lock_outline),
//                           suffixIcon: IconButton(
//                             icon: Icon(_obscurePassword
//                                 ? Icons.visibility_outlined
//                                 : Icons.visibility_off_outlined),
//                             onPressed: () {
//                               setState(() {
//                                 _obscurePassword = !_obscurePassword;
//                               });
//                             },
//                           ),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         textInputAction: TextInputAction.done,
//                         onFieldSubmitted: (_) => _handleLogin(),
//                       ),
//                     ],

//                     const SizedBox(height: 30),

//                     ElevatedButton(
//                       onPressed: _isLoading
//                           ? null
//                           : _showPasswordField
//                               ? _handleLogin
//                               : _handleCheckUser,
//                       style: ElevatedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(vertical: 16),
//                         backgroundColor: Colors.blueAccent,
//                         foregroundColor: Colors.white,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       child: _isLoading
//                           ? const SizedBox(
//                               width: 20,
//                               height: 20,
//                               child: CircularProgressIndicator(
//                                 strokeWidth: 2,
//                                 color: Colors.white,
//                               ),
//                             )
//                           : Text(
//                               _showPasswordField ? 'Login' : 'Continue',
//                               style: const TextStyle(
//                                   fontWeight: FontWeight.w600, fontSize: 16),
//                             ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

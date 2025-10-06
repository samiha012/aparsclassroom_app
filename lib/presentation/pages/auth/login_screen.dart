import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../../core/routes/app_router.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is Authenticated) {
              // Navigate to main screen on successful login
              Navigator.of(context).pushReplacementNamed(AppRouter.main);
            } else if (state is AuthError) {
              // Show error message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 3),
                ),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is AuthLoading;

            return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.1),
                  
                  // Top image spanning 40% of screen height
                  SizedBox(
                    height: screenHeight * 0.4,
                    width: double.infinity,
                    child: Image.asset(
                      'assets/images/51d0428a2501c73bd5251fb33990fea6411bbdc5.png',
                      fit: BoxFit.contain,
                    ),
                  ),

                  const SizedBox(height: 45),

                  // Welcome text
                  const Text(
                    'Welcome to',
                    style: TextStyle(
                      fontSize: 20,
                      color: Color.fromARGB(255, 55, 54, 54),
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  // Logo
                  Transform.translate(
                    offset: const Offset(0, -60),
                    child: Image.asset(
                      'assets/images/logowname.png',
                      height: 200,
                      width: 200,
                      fit: BoxFit.contain,
                    ),
                  ),

                  // Google Sign-In button
                  Transform.translate(
                    offset: const Offset(0, -60),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const Icon(Icons.login, size: 20),
                          label: Text(
                            isLoading ? 'Signing in...' : 'Sign in with Google',
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: Colors.blueAccent,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: isLoading
                              ? null
                              : () {
                                  // Trigger Google Sign In
                                  context.read<AuthBloc>().add(
                                        SignInWithGoogleEvent(),
                                      );
                                },
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Email Sign-In button
                  Transform.translate(
                    offset: const Offset(0, -60),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: Colors.blueAccent,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: isLoading
                              ? null
                              : () {
                                  // Navigate to email login
                                  Navigator.of(context).pushNamed(
                                    '/email-login',
                                  );
                                },
                          child: const Text('Sign in with Email'),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
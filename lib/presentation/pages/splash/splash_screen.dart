// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_native_splash/flutter_native_splash.dart';
// import '../../blocs/auth/auth_bloc.dart';
// import '../../../core/routes/app_router.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     // Remove splash screen after a short delay to ensure smooth transition
//     Future.delayed(const Duration(milliseconds: 500), () {
//       FlutterNativeSplash.remove();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<AuthBloc, AuthState>(
//       listener: (context, state) {
//         if (state is Authenticated) {
//           // User is logged in, navigate to main screen
//           Navigator.of(context).pushReplacementNamed(AppRouter.main);
//         } else if (state is Unauthenticated) {
//           // User is not logged in, navigate to login screen
//           Navigator.of(context).pushReplacementNamed(AppRouter.login);
//         } else if (state is AuthError) {
//           // Handle error - show error and navigate to login
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(state.message),
//               backgroundColor: Colors.red,
//             ),
//           );
//           Navigator.of(context).pushReplacementNamed(AppRouter.login);
//         }
//       },
//       child: const Scaffold(
//         body: Center(
//           child: CircularProgressIndicator(),
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../../core/routes/app_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    // Remove native splash immediately
    FlutterNativeSplash.remove();

    // Animation controller for text fade-in
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);

    // Start the fade-in after a short delay
    Timer(const Duration(milliseconds: 500), () {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigate(AuthState state) {
    if (state is Authenticated) {
      Navigator.of(context).pushReplacementNamed(AppRouter.main);
    } else if (state is Unauthenticated) {
      Navigator.of(context).pushReplacementNamed(AppRouter.login);
    } else if (state is AuthError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: Colors.red,
        ),
      );
      Navigator.of(context).pushReplacementNamed(AppRouter.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) => _navigate(state),
      child: Scaffold(
        backgroundColor: const Color(0xff578EEB),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Image.asset(
                'assets/images/applogo.jpg', // high-res PNG
                height: screenHeight * 0.2,
                width: screenWidth * 0.4,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 30),
              // Native fade-in text
              FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: const [
                    Text(
                      'ASG',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'ASG APP',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

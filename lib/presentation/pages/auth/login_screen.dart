// import 'package:flutter/material.dart';

// class LoginScreen extends StatelessWidget {
//   const LoginScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Login Screen',
//               style: Theme.of(context).textTheme.headlineMedium,
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 // TODO: Implement Google Sign In
//               },
//               child: const Text('Sign in with Google'),
//             ),
//             const SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: () {
//                 // TODO: Navigate to email login
//               },
//               child: const Text('Sign in with Email'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Top image spanning 50% of screen height
            SizedBox(
              height: screenHeight * 0.5,
              width: double.infinity,
              child: Image.asset(
                'assets/images/51d0428a2501c73bd5251fb33990fea6411bbdc5.png',
                fit: BoxFit.contain,
              ),
            ),

            const SizedBox(height: 30),

            // Welcome text
            const Text(
              'Welcome to',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.normal,
              ),
            ),

            const SizedBox(height: 10),

            // Row of two small images
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/image copy.png',
                    height: 40,
                    width: 40,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 16),
                  Image.asset(
                    'assets/images/image.png',
                    height: 80,
                    width: 80,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Google Sign-In button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  // icon: Image.asset(
                  //   'assets/images/google_logo.png',
                  //   height: 24,
                  //   width: 24,
                  // ),
                  label: const Text('Sign in with Google'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    // TODO: Implement Google Sign In
                  },
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Email Sign-In button
            Padding(
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
                  onPressed: () {
                    // TODO: Navigate to email login
                  },
                  child: const Text('Sign in with Email'),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

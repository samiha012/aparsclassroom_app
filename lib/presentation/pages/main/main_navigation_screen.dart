import 'package:flutter/material.dart';
import '../home/home_screen.dart';
import '../enrolled/enrolled_courses_screen.dart';
import '../community/community_screen.dart';
import '../profile/profile_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const EnrolledCoursesScreen(),
    const CommunityScreen(),
    const ProfileScreen(),
  ];

  final List<String> _labels = ['Home', 'Courses', 'Community', 'Profile'];
  final List<String> _iconPaths = [
    'assets/svgs/home.svg',
    'assets/svgs/courses.svg',
    'assets/svgs/community.svg',
    'assets/svgs/profile.svg',
  ];
  final List<String> _activeIconPaths = [
    'assets/svgs/home-active.svg',
    'assets/svgs/courses-active.svg',
    'assets/svgs/community-active.svg',
    'assets/svgs/profile-active.svg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      extendBody: true,
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: BottomAppBar(
              color: Colors.blue[900],
              elevation: 8,
              child: SizedBox(
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(_labels.length, (index) {
                    final isActive = _currentIndex == index;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isActive ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              isActive
                                  ? _activeIconPaths[index]
                                  : _iconPaths[index],
                              height: 25,
                              width: 25,
                              colorFilter: ColorFilter.mode(
                                isActive ? Colors.blue[900]! : Colors.white,
                                BlendMode.srcIn,
                              ),
                            ),

                            if (isActive) ...[
                              const SizedBox(width: 4),
                              Text(
                                _labels[index],
                                style: TextStyle(
                                  color: isActive
                                      ? Colors.blue[900]
                                      : Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16, // smaller font
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

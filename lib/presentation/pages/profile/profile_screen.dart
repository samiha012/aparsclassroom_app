import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/profile/profile_bloc.dart';
import '../../../core/routes/app_router.dart';
import '../../../injection_container.dart' as di;

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;

    if (authState is! Authenticated) {
      return const Scaffold(body: Center(child: Text('Please login')));
    }

    return BlocProvider(
      create: (context) =>
          di.sl<ProfileBloc>()..add(LoadProfileEvent(uid: authState.user.uid)),
      child: ProfileScreenView(authUid: authState.user.uid),
    );
  }
}

class ProfileScreenView extends StatelessWidget {
  final String authUid;

  const ProfileScreenView({super.key, required this.authUid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Unauthenticated) {
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil(AppRouter.login, (route) => false);
          }
        },
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ProfileError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(state.message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ProfileBloc>().add(
                          LoadProfileEvent(uid: authUid),
                        );
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is ProfileLoaded) {
              final user = state.user;

              return SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),

                    Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.fromARGB(
                            255,
                            177,
                            176,
                            176,
                          ), // border color
                          width: 1, // border thickness
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Profile Image
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.grey[300],
                              backgroundImage: user.photoUrl != null
                                  ? CachedNetworkImageProvider(user.photoUrl!)
                                  : null,
                              child: user.photoUrl == null
                                  ? const Icon(Icons.person, size: 50)
                                  : null,
                            ),
                            const SizedBox(width: 16),

                            // Name + Extra Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user.displayName ?? 'User',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    user.hsc ?? 'No Batch Info',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  Text(
                                    user.institution ??
                                        'Institution Name not updated',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    //menu items section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Wrap(
                        spacing: 12, // horizontal space between items
                        runSpacing: 20, // vertical space between rows
                        children:
                            [
                                  _buildGridItem(
                                    context,
                                    icon: Icons.download_outlined,
                                    label: 'Downloads',
                                  ),
                                  _buildGridItem(
                                    context,
                                    icon: Icons.class_outlined,
                                    label: 'Classes',
                                  ),
                                  _buildGridItem(
                                    context,
                                    icon: Icons.quiz_outlined,
                                    label: 'Exams',
                                  ),
                                  _buildGridItem(
                                    context,
                                    icon: Icons.book_outlined,
                                    label: 'Enrolled Courses',
                                    value:
                                        '${user.enrolledCourses?.length ?? 0}',
                                  ),
                                  _buildGridItem(
                                    context,
                                    icon: Icons.qr_code_2_outlined,
                                    label: 'Achieve QR',
                                  ),
                                  _buildGridItem(
                                    context,
                                    icon: Icons.receipt_long_outlined,
                                    label: 'Invoices',
                                  ),
                                ]
                                .map(
                                  (child) => SizedBox(
                                    width:
                                        (MediaQuery.of(context).size.width -
                                            16 * 2 -
                                            12 * 2) /
                                        3,
                                    child: child,
                                  ),
                                )
                                .toList(),
                      ),
                    ),
                    const SizedBox(height: 30),
                    _buildMenuSection(
                      context: context,
                      title: 'Account',
                      items: [
                        _MenuItem(
                          icon: Icons.person_outline,
                          title: 'Edit Profile',
                          onTap: () {
                            Navigator.of(context).pushNamed('/edit-profile');
                          },
                        ),
                        _MenuItem(
                          icon: Icons.book_outlined,
                          title: 'My Courses',
                          subtitle:
                              '${user.enrolledCourses?.length ?? 0} courses',
                          onTap: () {},
                        ),
                      ],
                    ),

                    // 🔹 Support Section
                    _buildMenuSection(
                      context: context,
                      title: 'Support',
                      items: [
                        _MenuItem(
                          icon: Icons.help_outline,
                          title: 'Help & Support',
                          onTap: () {},
                        ),
                        _MenuItem(
                          icon: Icons.privacy_tip_outlined,
                          title: 'Privacy Policy',
                          onTap: () {},
                        ),
                        _MenuItem(
                          icon: Icons.article,
                          title: 'Terms and conditions',
                          onTap: () {},
                        ),
                        _MenuItem(
                          icon: Icons.info_outline,
                          title: 'About',
                          onTap: () {},
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => _showLogoutDialog(context),
                          icon: const Icon(Icons.logout),
                          label: const Text('Logout'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: Theme.of(context).primaryColor, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildGridItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    String? value,
  }) {
    return Container(
      // decoration: BoxDecoration(
      //   color: Colors.white,
      //   borderRadius: BorderRadius.circular(12),
      //   boxShadow: [
      //     BoxShadow(
      //       color: Colors.grey.withOpacity(0.1),
      //       blurRadius: 5,
      //       offset: const Offset(0, 2),
      //     ),
      //   ],
      // ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Theme.of(context).primaryColor, size: 30),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
          if (value != null) ...[
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMenuSection({
    required BuildContext context,
    required String title,
    required List<_MenuItem> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: items.map((item) {
              final isLast = item == items.last;
              return Column(
                children: [
                  ListTile(
                    leading: Icon(item.icon, color: Colors.grey[700]),
                    title: Text(item.title),
                    subtitle: item.subtitle != null
                        ? Text(item.subtitle!)
                        : null,
                    trailing: const Icon(Icons.chevron_right),
                    onTap: item.onTap,
                  ),
                  if (!isLast)
                    const Divider(height: 1, indent: 56, color: Colors.grey),
                ],
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<AuthBloc>().add(SignOutEvent());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  _MenuItem({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });
}

import 'package:aparsclassroom_app/presentation/widgets/course/course_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../blocs/course/course_bloc.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../../domain/entities/course.dart';
import '../../../core/constants/route_constants.dart';
import '../../../injection_container.dart' as di;
import '../../widgets/dialogs/redeem_course_dialog.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final authState = context.read<AuthBloc>().state;
        if (authState is Authenticated) {
          return di.sl<CourseBloc>()
            ..add(LoadCoursesEvent(uid: authState.user.uid));
        }
        return di.sl<CourseBloc>();
      },
      child: const HomeScreenView(),
    );
  }
}

class HomeScreenView extends StatelessWidget {
  const HomeScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Apars Classroom'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.of(context).pushNamed(RouteConstants.search);
            },
          ),
        ],
      ),
      body: BlocBuilder<CourseBloc, CourseState>(
        builder: (context, state) {
          if (state is CourseLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CourseError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      final authState = context.read<AuthBloc>().state;
                      if (authState is Authenticated) {
                        context.read<CourseBloc>().add(
                              LoadCoursesEvent(uid: authState.user.uid),
                            );
                      }
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is CourseLoaded) {
            if (state.groupedCourses.isEmpty) {
              return const Center(
                child: Text('No courses available'),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                final authState = context.read<AuthBloc>().state;
                if (authState is Authenticated) {
                  context.read<CourseBloc>().add(
                        LoadCoursesEvent(uid: authState.user.uid),
                      );
                }
              },
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 16),
                itemCount: state.groupedCourses.length,
                itemBuilder: (context, index) {
                  final category = state.groupedCourses.keys.elementAt(index);
                  final courses = state.groupedCourses[category]!;

                  return CategorySection(
                    category: category,
                    courses: courses,
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class CategorySection extends StatelessWidget {
  final String category;
  final List<Course> courses;

  const CategorySection({
    super.key,
    required this.category,
    required this.courses,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            category,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        SizedBox(
          height: 240,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: courses.length,
            itemBuilder: (context, index) {
              return CourseCard(course: courses[index]);
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class CourseCard extends StatelessWidget {
  final Course course;

  const CourseCard({super.key, required this.course});

  Future<void> _handleCourseTap(BuildContext context) async {
    // Check if course is enrolled
    if (course.isEnrolled) {
      // Navigate to course content (subjects)
      Navigator.of(context).pushNamed(
        '/subject-list',
        arguments: {
          'courseId': course.id,
          'courseName': course.productName,
        },
      );
    } else {
      // Show redeem dialog
      final redeemed = await showRedeemCourseDialog(
        context,
        course.productFullName,
      );

      if (redeemed == true) {
        // Reload courses to update enrollment status
        final authState = context.read<AuthBloc>().state;
        if (authState is Authenticated) {
          context.read<CourseBloc>().add(
                LoadCoursesEvent(uid: authState.user.uid),
              );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _handleCourseTap(context),
      child: Container(
        width: 200,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Course Image
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: course.productImage != null
                    ? CachedNetworkImage(
                        imageUrl: course.productImage!,
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[300],
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.image_not_supported),
                        ),
                      )
                    : Container(
                        height: 120,
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.school,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
              ),
              
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Course Name
                      Text(
                        course.productName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      
                      // Students Count
                      Row(
                        children: [
                          Icon(
                            Icons.people_outline,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${course.studentCount} students',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      
                      // Price
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            course.currencyAmount > 0
                                ? '৳${course.currencyAmount.toStringAsFixed(0)}'
                                : 'Free',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: course.currencyAmount > 0
                                  ? Colors.green
                                  : Colors.blue,
                            ),
                          ),
                          if (course.isEnrolled)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'Enrolled',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/course/course_bloc.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../../domain/entities/course.dart';
import '../../../core/constants/route_constants.dart';
import '../../../injection_container.dart' as di;
import '../../widgets/course/course_card.dart';

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
      appBar: AppBar(
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
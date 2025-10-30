import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../blocs/subject/subject_bloc.dart';
import '../../../domain/entities/subject.dart';
import '../../../injection_container.dart' as di;

class SubjectListScreen extends StatelessWidget {
  final String courseId;
  final String courseName;

  const SubjectListScreen({
    super.key,
    required this.courseId,
    required this.courseName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<SubjectBloc>()
        ..add(LoadSubjectsEvent(courseId: courseId)),
      child: SubjectListView(courseName: courseName, courseId: courseId),
    );
  }
}

class SubjectListView extends StatelessWidget {
  final String courseName;
  final String courseId;

  const SubjectListView({
    super.key,
    required this.courseName,
    required this.courseId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(courseName),
        centerTitle: true,
      ),
      body: BlocBuilder<SubjectBloc, SubjectState>(
        builder: (context, state) {
          if (state is SubjectLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is SubjectError) {
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
                      context.read<SubjectBloc>().add(
                            LoadSubjectsEvent(courseId: courseId),
                          );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is SubjectLoaded) {
            if (state.subjects.isEmpty && state.archievedCourses.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.folder_open,
                      size: 80,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No subjects available',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<SubjectBloc>().add(
                      LoadSubjectsEvent(courseId: courseId),
                    );
              },
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Active Subjects
                  if (state.subjects.isNotEmpty) ...[
                    const Text(
                      'Subjects',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...state.subjects.map((subject) => SubjectCard(
                          courseSubject: subject,
                          courseId: courseId,
                        )),
                  ],

                  // Archived Courses
                  if (state.archievedCourses.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    const Text(
                      'Archived Courses',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...state.archievedCourses.map((course) =>
                        ArchievedCourseCard(course: course)),
                  ],
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class SubjectCard extends StatelessWidget {
  final CourseSubject courseSubject;
  final String courseId;

  const SubjectCard({
    super.key,
    required this.courseSubject,
    required this.courseId,
  });

  @override
  Widget build(BuildContext context) {
    final subject = courseSubject.subject;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(
            '/chapter-list',
            arguments: {
              'subjectId': subject.id,
              'subjectName': subject.title,
            },
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Subject Icon/Image
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: subject.subjectImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: subject.subjectImage!,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) => const Icon(
                            Icons.book,
                            color: Colors.blue,
                            size: 30,
                          ),
                        ),
                      )
                    : const Icon(
                        Icons.book,
                        color: Colors.blue,
                        size: 30,
                      ),
              ),

              const SizedBox(width: 12),

              // Subject Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subject.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    if (courseSubject.title != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        courseSubject.title!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),

              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

class ArchievedCourseCard extends StatelessWidget {
  final ArchievedCourse course;

  const ArchievedCourseCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          // Navigate to archived course subjects
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => SubjectListScreen(
                courseId: course.courseId,
                courseName: course.productName,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Course Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: course.productImage != null
                    ? CachedNetworkImage(
                        imageUrl: course.productImage!,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => Container(
                          width: 60,
                          height: 60,
                          color: Colors.grey[300],
                          child: const Icon(Icons.archive),
                        ),
                      )
                    : Container(
                        width: 60,
                        height: 60,
                        color: Colors.grey[300],
                        child: const Icon(Icons.archive),
                      ),
              ),

              const SizedBox(width: 12),

              // Course Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.productName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'Archived',
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
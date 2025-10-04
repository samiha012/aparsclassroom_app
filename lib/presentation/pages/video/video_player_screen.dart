import 'package:flutter/material.dart';

class VideoPlayerScreen extends StatelessWidget {
  final String videoId;
  final String? videoUrl;
  final String videoTitle;
  final String chapterId;
  
  const VideoPlayerScreen({
    super.key,
    required this.videoId,
    this.videoUrl,
    required this.videoTitle,
    required this.chapterId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(videoTitle)),
      body: const Center(child: Text('Video Player Screen - TODO')),
    );
  }
}

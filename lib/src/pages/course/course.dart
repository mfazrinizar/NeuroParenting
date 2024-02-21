import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YouTube Player Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CourseListScreen(),
    );
  }
}

class CourseListScreen extends StatelessWidget {
  const CourseListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Courses'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('courses').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((doc) {
              return CourseItem(
                course: Course.fromFirestore(doc),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

class CourseItem extends StatelessWidget {
  final Course course;

  const CourseItem({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(course.name),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoListScreen(course: course),
          ),
        );
      },
    );
  }
}

class VideoListScreen extends StatelessWidget {
  final Course course;

  const VideoListScreen({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(course.name),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('courses')
            .doc(course.id)
            .collection('videos')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((doc) {
              return VideoItem(
                title: doc['title'],
                videoId: YoutubePlayer.convertUrlToId(doc['link']) ?? '',
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

class VideoItem extends StatelessWidget {
  final String title;
  final String videoId;

  const VideoItem({super.key, required this.title, required this.videoId});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => YouTubePlayerScreen(videoId: videoId),
          ),
        );
      },
    );
  }
}

class YouTubePlayerScreen extends StatelessWidget {
  final String videoId;

  const YouTubePlayerScreen({super.key, required this.videoId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('YouTube Player'),
      ),
      body: Center(
        child: YoutubePlayer(
          controller: YoutubePlayerController(
            initialVideoId: videoId,
            flags: const YoutubePlayerFlags(
              autoPlay: true,
              mute: false,
            ),
          ),
          showVideoProgressIndicator: true,
          progressIndicatorColor: Colors.blueAccent,
        ),
      ),
    );
  }
}

class Course {
  final String id;
  final String name;

  Course({required this.id, required this.name});

  factory Course.fromFirestore(DocumentSnapshot doc) {
    return Course(
      id: doc.id,
      name: doc['name'],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CourseListPage extends StatelessWidget {
  const CourseListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('courses').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('Error fetching data'),
            );
          }
          final List<CourseOverview> courseOverviews = snapshot.data!.docs
              .map((doc) => CourseOverview.fromDocument(doc))
              .toList();
          return ListView.builder(
            itemCount: courseOverviews.length,
            itemBuilder: (context, index) {
              return CourseListItem(courseOverviews[index]);
            },
          );
        },
      ),
    );
  }
}

class CourseOverview {
  final String id;
  final String name;
  final String imageURL;

  CourseOverview({
    required this.id,
    required this.name,
    required this.imageURL,
  });

  factory CourseOverview.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CourseOverview(
      id: doc.id,
      name: data['name'],
      imageURL: data['imageURL'],
    );
  }
}

class CourseListItem extends StatelessWidget {
  final CourseOverview courseOverview;

  const CourseListItem(this.courseOverview, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CourseDetailPage(courseOverview),
          ),
        );
      },
      child: ListTile(
        leading: Image.network(
          courseOverview.imageURL,
          fit: BoxFit.cover,
          height: 50,
          width: 80,
          alignment: Alignment.topCenter,
        ),
        title: Text(
          courseOverview.name,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class CourseDetailPage extends StatelessWidget {
  final CourseOverview courseOverview;

  const CourseDetailPage(this.courseOverview, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(courseOverview.name),
      ),
      body: const Center(
        child: Text('Course Detail Page'),
      ),
    );
  }
}


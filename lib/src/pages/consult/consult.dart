import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String name;
  final List<String> userTags;
  final String userType;

  User({
    required this.name,
    required this.userTags,
    required this.userType,
  });

  factory User.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return User(
      name: data['name'] ?? 'null',
      userTags: data.containsKey('userTags')
          ? List<String>.from(data['userTags'])
          : ['null'],
      userType: data['userType'] ?? 'null',
    );
  }
}

class Consultation {
  final String senderId;
  final String receiverId;
  final String message;
  final DateTime timestamp;

  Consultation({
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp,
    };
  }

  factory Consultation.fromFirestore(DocumentSnapshot doc) {
    return Consultation(
      senderId: doc['senderId'],
      receiverId: doc['receiverId'],
      message: doc['message'],
      timestamp: (doc['timestamp'] as Timestamp).toDate(),
    );
  }
}

class PsychologistListScreen extends StatelessWidget {
  const PsychologistListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Psychologists'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('userType', isEqualTo: 'Psychologist')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('Error fetching psychologists'),
            );
          }
          final List<User> psychologists = snapshot.data!.docs
              .map((doc) => User.fromFirestore(doc))
              .toList();
          return ListView.builder(
            itemCount: psychologists.length,
            itemBuilder: (context, index) {
              return PsychologistListItem(psychologists[index]);
            },
          );
        },
      ),
    );
  }
}

class PsychologistListItem extends StatelessWidget {
  final User psychologist;

  const PsychologistListItem(this.psychologist, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(psychologist.name),
      subtitle:
          Text('Neurodivergent tags: ${psychologist.userTags.join(', ')}'),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(psychologist),
          ),
        );
      },
    );
  }
}

class ChatScreen extends StatelessWidget {
  final User psychologist;

  const ChatScreen(this.psychologist, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${psychologist.name}'),
      ),
      body: const Center(
        child: Text('Chat UI goes here'),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: PsychologistListScreen(),
  ));
}

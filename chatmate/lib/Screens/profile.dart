import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Color newBlue = const Color(0xFFC1FAFF);
  Color newPurple = const Color(0xFFC6C1FF);
  Color newOrange = const Color(0xFFFFE5C1);
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: newBlue,
      appBar: AppBar(
        backgroundColor: newPurple,
        title: const Text('Profile'),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Icon(Icons.add_a_photo),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Username:- ',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
                Text(
                  'Raghav',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Phone Number:- ',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
                Text(
                  '99878380617',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Bio:- ',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
                Text(
                  'Hey there! I am using ChatMate.',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: newOrange,
                foregroundColor: Colors.black,
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                textStyle: const TextStyle(
                  fontSize: 20,
                ),
              ),
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}

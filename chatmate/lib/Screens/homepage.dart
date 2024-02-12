import 'package:chatmate/Screens/chatroom.dart';
import 'package:chatmate/Screens/login.dart';
import 'package:chatmate/Screens/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Color newBlue = const Color(0xFFC1FAFF);
  Color newPurple = const Color(0xFFC6C1FF);
  Color newOrange = const Color(0xFFFFE5C1);
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: newBlue,
      appBar: AppBar(
        backgroundColor: newPurple,
        title: const Text('ChatMate'),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_active_outlined))
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: newBlue,
              ),
              child: const Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    // backgroundImage: AssetImage('assets/images/profile.png'),
                  ),
                  Text(
                    'Username',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const Profile();
                }));
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Setting'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                _auth.signOut();
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const Login();
                }));
              },
            ),
          ],
        ),
      ),
      body: Center(
          child: StreamBuilder(
        stream: _firestore
            .collection('users')
            // .where('email', isEqualTo: _auth.currentUser!.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            var doc = snapshot.data!.docs;
            return ListView.builder(
              itemCount: doc.length,
              itemBuilder: (context, index) {
                if (doc[index]['email'] == _auth.currentUser!.email) {
                  return Container();
                }
                return GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context){
                      return ChatRoom(
                        otherUserEmail: doc[index]['email'],
                        otherName: doc[index]['name']
                      );
                    }));
                  },
                  child: ListTile(
                    leading: const CircleAvatar(
                      radius: 25,
                    ),
                    title: Text(doc[index]['name']),
                    subtitle: Text(doc[index]['email']),
                  ),
                );
              },
            );
          }
          return Container();
        },
      )),
    );
  }
}

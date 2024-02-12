// ignore_for_file: use_build_context_synchronously

import 'package:chatmate/Screens/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  Color newBlue = const Color(0xFFC1FAFF);
  Color newPurple = const Color(0xFFC6C1FF);
  Color newOrange = const Color(0xFFFFE5C1);
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneController.dispose();
  }

  void signUp() async {
    if (passwordController.text == confirmPasswordController.text) {
      try {
        await _auth.createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);
        debugPrint('User Registered ${_auth.currentUser}');
        await _firestore.collection('users').doc(_auth.currentUser!.uid).set({
          'name': nameController.text,
          'email': emailController.text,
          'phone': phoneController.text,
          'bio': '',
          'profilePic': '',
          'friends': [],
          'friendRequests': [],
        });
        _auth.currentUser!.updateDisplayName(nameController.text);
        debugPrint('User added to firestore');
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return const Login();
        }));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('The password provided is too weak')));
        } else if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('The account already exists for that email')));
        }
      } catch (e) {
        print(e);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Passwords do not match')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: newBlue,
      appBar: AppBar(
        backgroundColor: newPurple,
        title: const Text('Register',
            style: TextStyle(
              color: Colors.black,
              fontSize: 25,
            )),
        foregroundColor: Colors.black,
        centerTitle: true,
        elevation: 2,
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Welcome to ChatMate',
            style: TextStyle(
              color: Colors.black,
              fontSize: 25,
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                labelText: 'Name',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: emailController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                labelText: 'Email',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: phoneController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                labelText: 'Phone Number',
              ),
              keyboardType: TextInputType.phone,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: passwordController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                labelText: 'Password',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              obscureText: true,
              controller: confirmPasswordController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                labelText: 'Confirm Password',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                signUp();
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
              child: const Text('Register'),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Already have an account?',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  )),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const Login();
                  }));
                },
                child: const Text('Login',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 20,
                    )),
              ),
            ],
          ),
        ],
      )),
    );
  }
}

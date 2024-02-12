// ignore_for_file: use_build_context_synchronously

import 'package:chatmate/Screens/homepage.dart';
import 'package:chatmate/Screens/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Color newBlue = const Color(0xFFC1FAFF);
  Color newPurple = const Color(0xFFC6C1FF);
  Color newOrange = const Color(0xFFFFE5C1);
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const HomePage();
      }));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No user found for that email')));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Wrong password provided for that user')));
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: newBlue,
      appBar: AppBar(
        backgroundColor: newPurple,
        title: const Text('Login',
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
              controller: emailController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                labelText: 'Email',
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              obscureText: true,
              controller: passwordController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                labelText: 'Password',
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              login();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: newOrange,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              textStyle: const TextStyle(
                fontSize: 20,
              ),
            ),
            child: const Text('Login'),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Don\'t have an account?',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  )),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return const Register();
                    },
                  ));
                },
                child: const Text('Sign Up',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 20,
                    )),
              )
            ],
          )
        ],
      )),
    );
  }
}

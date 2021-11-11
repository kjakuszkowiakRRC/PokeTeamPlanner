import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:poke_team_planner/main_screens/menu.dart';
import 'package:poke_team_planner/user_screens/profile_page.dart';
import 'package:poke_team_planner/user_screens/register_page.dart';
import 'package:poke_team_planner/utils/validator.dart';

import '../utils/fire_auth.dart';
//Todo: add a message for failed sign in
//Todo: change the formatting
//Todo: add email and password as labels and not hints
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  bool _isProcessing = false;

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ProfilePage(
            user: user,
          ),
        ),
      );
    }

    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Authentication'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FutureBuilder(
                future: _initializeFirebase(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          Center(
                            child: TextFormField(
                              decoration: const InputDecoration.collapsed(
                                  hintText: 'Email',
                              border: InputBorder.none),
                              style: const TextStyle(
                                  fontSize: 25),
                              controller: _emailTextController,
                              focusNode: _focusEmail,
                              validator: (value) =>
                                  Validator.validateEmail(email: value),
                            ),
                          ),
                          SizedBox(height: 20.0),
                          TextFormField(
                            decoration: const InputDecoration.collapsed(
                                hintText: 'Password'),
                            style: const TextStyle(
                                fontSize: 25),
                            controller: _passwordTextController,
                            focusNode: _focusPassword,
                            obscureText: true,
                            validator: (value) =>
                                Validator.validatePassword(password: value),
                          ),
                        ],
                      ),
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          User? user = await FireAuth.signInUsingEmailPassword(
                            email: _emailTextController.text,
                            password: _passwordTextController.text, context: context,
                          );
                          if (user != null) {
                            Navigator.of(context)
                                .pushReplacement(
                              // MaterialPageRoute(builder: (context) => ProfilePage(user: user)), //use this when wanting to get to user profile
                              MaterialPageRoute(builder: (context) => Menu()),
                            );
                          }
                        }
                      },
                      child: Text(
                        'Sign In',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => RegisterPage()),
                        );
                      },
                      child: Text(
                        'Register',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:poke_team_planner/validator.dart';

import 'fire_auth.dart';

class LoginPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final FocusNode _focusEmail = FocusNode();
  final FocusNode _focusPassword = FocusNode();

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
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
                          // if (user != null) {
                          //   Navigator.of(context)
                          //       .pushReplacement(
                          //     MaterialPageRoute(builder: (context) => ProfilePage(user: user)),
                          //   );
                          // }
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
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(builder: (context) => RegisterPage()),
                        // );
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

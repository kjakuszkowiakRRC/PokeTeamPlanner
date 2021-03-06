import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:poke_team_planner/user_screens/profile_page.dart';

//TODO: replace icon for button with profile pic

class AccountAlert extends StatelessWidget {
  const AccountAlert({Key? key}) : super(key: key);

  // Future<FirebaseApp> _initializeFirebase() async {
  //   FirebaseApp firebaseApp = await Firebase.initializeApp();
  //
  //   User? user = FirebaseAuth.instance.currentUser;
  //
  //   if (user != null) {
  //     Navigator.of(context).pushReplacement(
  //       MaterialPageRoute(
  //         builder: (context) => ProfilePage(
  //           user: user,
  //         ),
  //       ),
  //     );
  //   }
  //
  //   return firebaseApp;
  // }
  // @override
  // Widget build(BuildContext context) {
  //   return AlertDialog(
  //       title: Text("Account Page"),
  //       content: Text("Would you like to continue to your account page? All your current progress might be lost."),
  //       actions: [
  //         FlatButton(
  //           child: Text("Cancel"),
  //           onPressed:  () {
  //             Navigator.of(context).pop();
  //           },
  //         ),
  //         FlatButton(
  //           child: Text("Continue"),
  //           onPressed:  () {},
  //         )
  //       ],
  //     );
  // }
  @override
  Widget build(BuildContext context) {
    return
      IconButton(
        icon: const Icon(Icons.account_box),
        tooltip: 'Show Snackbar',
        onPressed: () {
          showAlertDialog(context);
        },
      );
      // TextButton.icon(
      //   // icon: Image.asset('assets/images/pokeball.png'),
      //     icon: Image(
      //       image: AssetImage('assets/images/pokeball.png'),
      //       width: 30,
      //     ),
      //     onPressed: () {
      //       showAlertDialog(context);
      //     },
      //     label: const Text(
      //       'Test',
      //       style: TextStyle(
      //         color: Colors.black,
      //         // fontSize: 30,
      //       ),
      //     )
      // );
  }

  showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      title: Text("Warning - Loss of Progress"),
      content: Text("Would you like to continue to your account page? All your current progress might be lost."),
      actions: [
        FlatButton(
          child: Text("Continue"),
          onPressed:  () async {
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
          },
        ),
        FlatButton(
          child: Text("Cancel"),
          onPressed:  () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

}

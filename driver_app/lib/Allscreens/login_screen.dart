import 'package:driver_app/Allscreens/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:raised_buttons/raised_buttons.dart';

import '../main.dart';
import 'main_screen.dart';

class LoginScreen extends StatelessWidget {
  static const String idScreen = "loginScreen";
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 35.0,
                ),
                const Image(
                  image: AssetImage("images/logo.png"),
                  width: 390.0,
                  height: 250.0,
                  alignment: Alignment.center,
                ),
                const SizedBox(
                  height: 1.0,
                ),
                const Text(
                  "Login as a Rider",
                  style: TextStyle(fontSize: 24.0, fontFamily: "Brand Bold"),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 1.0,
                      ),
                      TextFormField(
                        controller: emailTextEditingController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: "Email",
                          labelStyle: TextStyle(
                            fontFamily: "Brand Bold",
                            fontSize: 14,
                          ),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10.0,
                          ),
                        ),
                        style: const TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                      const SizedBox(
                        height: 1.0,
                      ),
                      TextFormField(
                        controller: passwordTextEditingController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: "Password",
                          labelStyle:
                              TextStyle(fontSize: 14, fontFamily: "Brand Bold"),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10.0,
                          ),
                        ),
                        style: const TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                      const SizedBox(
                        height: 40.0,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (!emailTextEditingController.text.contains("@")) {
                            displayToast("Enter the Valid Email", context);
                          } else if (passwordTextEditingController.text.length <
                              8) {
                            displayToast(
                                "Password Must Contain atleast 7 Characters",
                                context);
                          } else {
                            signIn(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            fixedSize: Size(1000.0, 50.0),
                            backgroundColor: Colors.yellow,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28.0))),
                        child: const Text(
                          "Login",
                          style: TextStyle(
                              fontSize: 18.0,
                              fontFamily: "Brand Bold",
                              color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, SignupScreen.idScreen, (route) => false);
                  },
                  child: const Text(
                    "Don't have Account? Click here to Register",
                    style: TextStyle(
                        color: Colors.black26,
                        fontSize: 14.0,
                        fontFamily: "Brand Bold"),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void signIn(BuildContext context) async {
    final User? firebaseUser = (await _firebaseAuth
            .signInWithEmailAndPassword(
                email: emailTextEditingController.text,
                password: passwordTextEditingController.text)
            .catchError((msg) {
      displayToast("Error:" + msg.toString(), context);
    }))
        .user;
    if (firebaseUser != null) {
      usersRef
          .child(firebaseUser.uid)
          .once()
          .then((value) => (DataSnapshot snap) {
                if (snap.value != null) {
                  Navigator.pushNamedAndRemoveUntil(
                      context, MainScreen.idScreen, (route) => false);
                  displayToast("Congratulations, Login SuccessFully", context);
                } else {
                  _firebaseAuth.signOut();
                  displayToast(
                      "Account no Found!, Register Yourself First", context);
                }
              });
    } else {
      displayToast("Account no Found!, Register Yourself First", context);
    }
  }
}

void displayToast(String msg, BuildContext context) {
  Fluttertoast.showToast(msg: msg);
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:uploadimageapp/screens/upload_post.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  var email1;
  var password2;

  GlobalKey _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Page"),
        shadowColor: Colors.grey,
        centerTitle: true,
        elevation: 20,
        backgroundColor: Colors.orangeAccent,
      ),
      body: SafeArea(
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: MultiValidator(
                      [
                        RequiredValidator(errorText: "Required"),
                      ],
                    ),
                    controller: passwordController,
                    onChanged: (value) {
                      email1 = value;
                    },
                    decoration: InputDecoration(
                      labelText: "Email",
                      labelStyle: const TextStyle(fontSize: 20),
                      prefixIcon: const Icon(
                        Icons.email,
                        size: 30,
                      ),
                      border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: MultiValidator(
                      [
                        RequiredValidator(errorText: "Required"),
                      ],
                    ),
                    controller: emailController,
                    onChanged: (value) {
                      password2 = value;
                    },
                    decoration: InputDecoration(
                      labelText: "Password",
                      labelStyle: const TextStyle(fontSize: 20),
                      prefixIcon: const Icon(
                        Icons.lock,
                        size: 30,
                      ),
                      border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      UserCredential userCredential = await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                          email: email1, password: password2);
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> UploadImageScreen()));
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'user-not-found') {
                        const snackbar =   SnackBar(
                          content:  Text(
                            "No user found for that email",
                            style: TextStyle(color: Colors.white),
                          ),
                          elevation: 10,
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.black,
                          padding: EdgeInsets.all(20),
                          margin: EdgeInsets.all(30),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackbar);
                      } else if (e.code == 'wrong-password') {
                        print('Wrong password provided for that user.');
                      }
                    }
                  },
                  child: const Text("Login"),
                ),
              ],
            ),
          )),
    );
  }
}

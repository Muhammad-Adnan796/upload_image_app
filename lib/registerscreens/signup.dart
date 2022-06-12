import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:uploadimageapp/registerscreens/login.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  var email1;
  var password2;

  GlobalKey _formkey = GlobalKey();

  addData() {
    FirebaseFirestore firebasefirestor = FirebaseFirestore.instance;
    firebasefirestor.collection("User").add({
      "name": nameController.text,
      "email": emailController.text,
      "password": passwordController.text,
    }).catchError((e) {
      print(e.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Signup Page"),
        shadowColor: Colors.grey,
        centerTitle: true,
        elevation: 20,
        backgroundColor: Colors.orangeAccent,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [

            Form(
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
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: "Name",
                        labelStyle:const TextStyle(fontSize: 20),
                        prefixIcon: const Icon(
                          Icons.person,
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
                      controller: passwordController,
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
                            borderSide:const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {

                      addData();

                      try {
                        UserCredential userCredential = await FirebaseAuth
                            .instance
                            .createUserWithEmailAndPassword(
                            email: email1, password: password2);
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginPage()));
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          print('The password provided is too weak.');
                        } else if (e.code == 'email-already-in-use') {
                          final snackbar = SnackBar(
                            content: Text("Email already exists!",style: TextStyle(color: Colors.white),),
                            elevation: 10,
                            backgroundColor: Colors.black,
                            padding: EdgeInsets.all(20),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackbar);
                          // print(snackbar);
                        }
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: Text("Register"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
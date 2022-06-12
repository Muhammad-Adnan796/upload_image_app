import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_database/firebase_database.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  bool showSpinner = false;
  final postRef = FirebaseDatabase.instance.ref().child("Posts");
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  File? _image;
  final picker = ImagePicker();

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  final GlobalKey _formkey = GlobalKey<FormState>();

  Future getImageGallery() async {
    final pickFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickFile != null) {
        _image = File(pickFile.path);
      } else {
        print("No image selected");
      }
    });
  }

  Future getImageCamera() async {
    final pickFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickFile != null) {
        _image = File(pickFile.path);
      } else {
        print("No image selected");
      }
    });
  }

  void Dialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {
                    getImageCamera();
                    Navigator.pop(context);
                  },
                  child: const ListTile(
                    leading: Icon(Icons.camera),
                    title: Text("Camera"),
                  ),
                ),
                const SizedBox(
                  height: 3,
                ),
                InkWell(
                  onTap: () {
                    getImageGallery();
                    Navigator.pop(context);
                  },
                  child: const ListTile(
                    leading: Icon(Icons.photo_library),
                    title: Text("Gallery"),
                  ),
                )
              ],
            ),
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Upload Post"),
          shadowColor: Colors.grey,
          centerTitle: true,
          elevation: 20,
          backgroundColor: Colors.orangeAccent,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              InkWell(
                onTap: () {
                  Dialog();
                },
                child: Center(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: _image != null
                        ? ClipRect(
                      child: Image.file(_image!.absolute,
                          width: 100, height: 100, fit: BoxFit.fill),
                    )
                        : Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: 100,
                      height: 100,
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Form(
                key: _formkey,
                child: Column(
                  children: [
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: "Title",
                        hintText: "Enter Post Title",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        labelStyle: const TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.bold),
                        hintStyle: const TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      minLines: 1,
                      maxLines: 5,
                      controller: descriptionController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "Description",
                        hintText: "Enter Post Description",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        labelStyle: const TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.normal),
                        hintStyle: const TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                child: const Text("Upload"),
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  try {
                    int date = DateTime.now().microsecondsSinceEpoch;
                    firebase_storage.Reference reference = firebase_storage
                        .FirebaseStorage.instance
                        .ref("/UploadImage$date");
                    UploadTask uploadTask = reference.putFile(_image!.absolute);
                    await Future.value(uploadTask);
                    var newUrl = await reference.getDownloadURL();
                    postRef.child("Post List").child(date.toString()).set({
                      "pId": date.toString(),
                      "pImage": newUrl.toString(),
                      "pTime": date.toString(),
                      "pTitle": titleController.text.toString(),
                      "pDescription": descriptionController.text.toString(),
                    }).then((value){
                      const snackbar = SnackBar(
                        content:  Text(
                          "Post Published",
                          style: TextStyle(color: Colors.white),
                        ),
                        elevation: 10,
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.black,
                        padding: EdgeInsets.all(20),
                        margin: EdgeInsets.all(30),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackbar);

                      setState(() {
                        showSpinner = false;
                      });
                    }).onError((error, stackTrace) {
                      final snackbar =  SnackBar(
                        content:  Text(
                          error.toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                        elevation: 10,
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.all(20),
                        margin: const EdgeInsets.all(30),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackbar);
                      setState(() {
                        showSpinner = false;
                      });
                    });
                  } catch (e) {
                    setState(() {
                      showSpinner = false;
                    });
                    const snackbar =   SnackBar(
                      content: Text(
                        "Error",
                        style:TextStyle(color: Colors.white),
                      ),
                      elevation: 10,
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.black,
                      padding: EdgeInsets.all(20),
                      margin: EdgeInsets.all(30),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackbar);
                  }
                },
                style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.all(Colors.orangeAccent),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:uploadimageapp/screens/add_post.dart';

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({Key? key}) : super(key: key);

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Image Screen"),
        shadowColor: Colors.grey,
        centerTitle: true,
        elevation: 20,
        backgroundColor: Colors.orangeAccent,
        actions: [
          InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddPostScreen(),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.add),
              ))
        ],
      ),
      body: Column(
        children: [],
      ),
    );
  }
}

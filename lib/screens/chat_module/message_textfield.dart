import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class MessageTextField extends StatefulWidget {
  final String currentId;
  final String friendId;
  final bool hide;

  MessageTextField(this.currentId, this.friendId, this.hide);

  @override
  _MessageTextFieldState createState() => _MessageTextFieldState();
}

class _MessageTextFieldState extends State<MessageTextField> {
  TextEditingController _controller = TextEditingController();
  File? imageFile;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future getImage() async {
    ImagePicker _picker = ImagePicker();

    await _picker.pickImage(source: ImageSource.gallery).then((xFile) {
      if (xFile != null) {
        imageFile = File(xFile.path);
        uploadImage();
      }
    });
  }

  Future uploadImage() async {
    String fileName = Uuid().v1();
    int status = 1;
    String? mid;

    // await _firestore
    //     .collection('users')
    //     .doc(widget.currentId)
    //     .collection('messages')
    //     .doc(widget.friendId)
    //     .collection('chats')
    //     .add({
    //   "senderId": widget.currentId,
    //   "receiverId": widget.friendId,
    //   "message": "",
    //   "type": "img",
    //   "date": DateTime.now(),
    // }).then((value) {
    //   // print(value.id);
    //   mid = value.id;
    // });

    var ref =
        FirebaseStorage.instance.ref().child('images').child("$fileName.jpg");

    var uploadTask = await ref.putFile(imageFile!).catchError((error) async {
      await _firestore
          .collection('users')
          .doc(widget.currentId)
          .collection('messages')
          .doc(widget.friendId)
          .collection('chats')
          .doc(mid)
          .delete();

      status = 0;
    });

    if (status == 1) {
      String imageUrl = await uploadTask.ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.currentId)
          .collection('messages')
          .doc(widget.friendId)
          .collection('chats')
          .add({
        "senderId": widget.currentId,
        "receiverId": widget.friendId,
        "message": imageUrl,
        "type": "img",
        "date": DateTime.now(),
      });

      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.friendId)
          .collection('messages')
          .doc(widget.currentId)
          .collection("chats")
          .add({
        "senderId": widget.currentId,
        "receiverId": widget.friendId,
        "message": imageUrl,
        "type": "img",
        "date": DateTime.now(),
      });

      print(imageUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsetsDirectional.only(
        top: 8.0,
        start: 8.0,
        end: 8.0,
        bottom: 8.0,
      ),
      child: Row(
        children: [
          Expanded(
            child: Visibility(
              visible: !widget.hide,
              child: TextField(
                controller: _controller,
                readOnly: widget.hide,
                decoration: InputDecoration(
                  labelText: widget.hide == false
                      ? "Type your Message"
                      : "resolved you can not type",
                  fillColor: Colors.grey[100],
                  filled: true,
                  prefixIcon: Visibility(
                    visible: !widget.hide,
                    child: IconButton(
                        onPressed: () {
                          getImage();
                        },
                        icon: Icon(
                          Icons.attach_file,
                          size: 30,
                          color: Colors.blue,
                        )),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 0,
                    ),
                    gapPadding: 10,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          GestureDetector(
            onTap: () async {
              String message = _controller.text;
              _controller.clear();
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(widget.currentId)
                  .collection('messages')
                  .doc(widget.friendId)
                  .collection('chats')
                  .add({
                "senderId": widget.currentId,
                "receiverId": widget.friendId,
                "message": message,
                "type": "text",
                "date": DateTime.now(),
              }).then((value) {
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(widget.currentId)
                    .collection('messages')
                    .doc(widget.friendId)
                    .set({
                  'last_msg': message,
                });
              });

              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(widget.friendId)
                  .collection('messages')
                  .doc(widget.currentId)
                  .collection("chats")
                  .add({
                "senderId": widget.currentId,
                "receiverId": widget.friendId,
                "message": message,
                "type": "text",
                "date": DateTime.now(),
              }).then((value) {
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(widget.friendId)
                    .collection('messages')
                    .doc(widget.currentId)
                    .set({"last_msg": message});
              });
            },
            child: Visibility(
              visible: !widget.hide,
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.teal,
                ),
                child: Icon(
                  Icons.send,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

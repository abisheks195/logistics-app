import 'dart:io';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// ignore: must_be_immutable
class ImageUpload extends StatefulWidget {
  File image;
  String uploadedFileURL;

  ImageUpload({Key key, this.image, this.uploadedFileURL});
  @override
  _ImageUploadState createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://easygo-d2af6.appspot.com/');
  final _picker = ImagePicker();

  Future chooseFile() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      widget.image = File(pickedFile.path);
    });
  }

  Future uploadFile() async {
    StorageReference storageReference =
        _storage.ref().child('images/${DateTime.now()}.png');
    StorageUploadTask uploadTask = storageReference.putFile(widget.image);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        widget.uploadedFileURL = fileURL;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellowAccent,
      body: SafeArea(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.image == null
                  ? RaisedButton(
                      child: Text('Choose File'),
                      onPressed: chooseFile,
                      color: Colors.cyan,
                    )
                  : Container(),
              widget.image != null
                  ? RaisedButton(
                      child: Text('Upload File'),
                      onPressed: uploadFile,
                      color: Colors.cyan,
                    )
                  : Container(),
              Text('Uploaded Image'),
              widget.uploadedFileURL != null
                  ? Image.network(
                      widget.uploadedFileURL,
                      height: 150,
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}

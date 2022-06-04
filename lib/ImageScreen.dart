import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageScreen extends StatefulWidget {
  const ImageScreen({Key key}) : super(key: key);

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  File _image;
  List<String> listOfImages = [];
  String img64;
  List<Uint8List> listOfImgByte = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Convert Image to base64'),
      ),
      body: Column(
        children: [
          RaisedButton(
            child: Text('Get Image'),
            onPressed: () {
              setState(() {
                getImage();
              });
            },
          ),
          SizedBox(
            height: 10,
          ),
          RaisedButton(
            child: Text('Get Images'),
            onPressed: () {
              setState(() {
                getImages();
              });
            },
          ),
          SizedBox(
            height: 10,
          ),
          Text('Image'),
          _image == null ? Container() : Image.file(_image , height: 100 , width: 100),
          SizedBox(
            height: 10,
          ),
          Text('Images'),
          Expanded(
            child: ListView.builder(
              itemCount: listOfImgByte.length,
              itemBuilder: (_, index) {
                return Image.memory(listOfImgByte[index], height: 100 , width: 100);
              },
            ),
          ),
        ],
      ),
    );
  }

  Future getImages() async {
    ImagePicker image = await ImagePicker().pickMultiImage().then((value) {
      value.forEach((element) {
        setState(() {
          print(element.path);
          final bytes = File(element.path).readAsBytesSync();
          listOfImgByte.add(bytes);
          img64 = base64Encode(bytes);
          listOfImages.add(img64);
        });
      });
    });
    print('Images Base64 Is : ${listOfImages.length}');
  }

  Future getImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (image != null) {
        _image = File(image.path);
      }
    });
    final bytes = File(image.path).readAsBytesSync();
    String img64 = base64Encode(bytes);
    print('Image Base64 Is : ${img64.length}');
  }
}
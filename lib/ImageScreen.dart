import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageScreen extends StatefulWidget {
  const ImageScreen({Key key}) : super(key: key);

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  File _image;
  List<String> listOfImages;
  List<XFile> _images;

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
                getImages();
              })
            },
          ),
          SizedBox(
            height: 10,
          ),
          _image == null ? Container() : Image.file(_image, height: 300),
        ],
      ),
    );
  }

  Future getImages() async {
    final images = await ImagePicker().pickMultiImage();

    setState(() {
      if (images != null) {
        _images.addAll(images);
      }
      for(var i in _images) {
        final bytes = File(i.path).readAsBytesSync();
        String img64 = base64Encode(bytes);
        listOfImages.add(img64);
        print('Image Base64 Is : ${listOfImages}');
      }
    });
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
    print('Image Base64 Is : ${img64}');
  }
}

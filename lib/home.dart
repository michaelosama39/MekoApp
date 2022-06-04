import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:share_plus/share_plus.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  File _image;
  List<String> listOfImages = [];
  String img64;
  List<Uint8List> listOfImgByte = [];
  ReceivePort _receivePort = ReceivePort();
  int progress = 0;
  File downloadedPDFFile;

  @override
  void initState() {
    IsolateNameServer.registerPortWithName(
        _receivePort.sendPort, 'downloading');
    _receivePort.listen((message) {
      setState(() {
        progress = message[2];
      });
      print(progress);
    });
    FlutterDownloader.registerCallback((id, status, progress) {
      SendPort sendPort = IsolateNameServer.lookupPortByName('downloading');
      sendPort.send([id, status, progress]);
    });
    super.initState();
  }

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
          ),SizedBox(
            height: 10,
          ),
          RaisedButton(
            child: Text('Download'),
            onPressed: () {
              setState(() {
                _downloadFile(url: '' , filename: '');
              });
            },
          ),
          SizedBox(
            height: 10,
          ),
          RaisedButton(
            child: Text('Share'),
            onPressed: () {
              setState(() async{
                if (downloadedPDFFile != null) {
                  await Share.shareFiles([downloadedPDFFile.path]);
                }
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

  Future<File> _downloadFile({String url, String filename}) async {
    var httpClient = new HttpClient();
    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      final dir = await getTemporaryDirectory();
      File file = new File('${dir.path}/$filename.pdf');
      await file.writeAsBytes(bytes);
      print('downloaded file path = ${file.path}');
      downloadedPDFFile = file;
      return file;
    } catch (error) {
      print('pdf downloading error = $error');
      return File('');
    }
  }
}
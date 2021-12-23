import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  XFile _image;

  void _imgFromGallery() async {
    XFile image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    _uploadImage(XFile _imageFile) async {
      var headers = {'Authorization': 'Basic eW9nOTgyNzg6TmVwYWxAMTIz'};
      var request = http.MultipartRequest(
          'POST', Uri.parse('https://gharjhagga.com/wp-json/wp/v2/media'));
      // request.files.add(await http.MultipartFile.fromPath(
      //     'file', '/Users/kiranjoshi/Downloads/wireframe_avatar.png'));
      request.files
          .add(await http.MultipartFile.fromPath('file', _imageFile.path));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('i am from if');
        print(await response.stream.bytesToString());
      } else {
        print('i am from else');
        print(response.statusCode);
        print(response.reasonPhrase);
      }
    }

    return Scaffold(
      body: ListView(
        children: [
          Container(
            height: 52.0,
            child: ElevatedButton(
              onPressed: () {
                _imgFromGallery();
              },
              child: Text('Image from Gallery'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.grey),
              ),
            ),
          ),
          SizedBox(
            height: 16.0,
          ),
          _image != null
              ? Container(
                  height: 200.0,
                  width: 200.0,
                  child: ClipRect(
                    child: Image.file(
                      File(_image.path),
                      width: 100.0,
                      height: 100.0,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                  ),
                  width: 200.0,
                  height: 200.0,
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.grey[800],
                  ),
                ),
          Container(
            height: 52.0,
            child: ElevatedButton(
              onPressed: () {
                print('upload image');
                print(_image.path);
                _uploadImage(_image);
              },
              child: Text('Upload'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

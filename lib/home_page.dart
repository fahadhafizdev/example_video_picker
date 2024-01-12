import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vidio_upload/services/kel_service.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ImagePicker picker = ImagePicker();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () async {
                var cameraVideo = await picker.pickVideo(
                    source: ImageSource.gallery,
                    preferredCameraDevice: CameraDevice.front);

                if (cameraVideo == null) return;

                log('vidio url : ${cameraVideo}');

                late File? vidioUpload;

                vidioUpload = File(cameraVideo!.path);

                String fileName = vidioUpload.path.split('/').last;

                log('vidio url : ${vidioUpload.path}');

                setState(() {
                  isLoading = true;
                });
                var dataRes = await KelService().request(
                  title: 'Upload Vidio',
                  url: 'www.google.com',
                  method: Method.POST,
                  isMultipart: true,
                  params: {
                    'id': '651202033',
                    'name': '651202033',
                    'file': await MultipartFile.fromFile(
                      vidioUpload.path,
                      filename: fileName,
                    ),
                  },
                );
                log('dara res ${dataRes}');
                setState(() {
                  isLoading = false;
                });
              },
              icon: isLoading
                  ? SizedBox(
                      height: 50,
                      width: 50,
                      child: CircularProgressIndicator(),
                    )
                  : Icon(Icons.upload),
            )
          ],
        ),
      ),
    );
  }
}

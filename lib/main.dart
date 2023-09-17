import 'dart:ffi';
import 'dart:io';
// import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:flutter/material.dart';
// import 'package:video_editor/domain/bloc/controller.dart';
import 'package:video_editor/video_editor.dart';
// import 'package:video_editor/domain/entities/crop_style.dart';
// import 'package:video_player/video_player.dart';
// // import 'package:video_editor/video_editor.dart';

class VideoPlayerScreen extends StatefulWidget {
  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
   // VideoPlayerController? _controller;
  //
  // @override
  // void initState() {
  //   super.initState();
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player'),
        actions: [
          IconButton(
              onPressed: () async {
                // Future<void> cropVideo(String inputVideoPath, String outputVideoPath, double startX, double startY, double endX, double endY) async {
                   final editor = VideoEditorController.file(
                       File("/storage/emulated/0/Download/videos1/Flutter_demo2.mp4"),
                       maxDuration: Duration(seconds: 20),
                       minDuration: Duration(seconds: 0));
                       // cropStyle: CropGridStyle());
                   await editor.initialize(aspectRatio: 9/16);
                   // final cropAspect = editor.cropAspectRatio(0.8);
                   editor.updateCrop(Offset(0.6, 0.5),Offset(0.8, 0.8), );
                   editor.cropAspectRatio(9/16);
                   print("croping ? ${editor.isCropping}");
                   print("trimme ? ${editor.isTrimmed}");
                   print("trimming ? ${editor.isTrimming}");
                   print("duration ? ${editor.videoDuration}");
                   setState(() {

                   });
                   editor.exportVideo(
                     preset: VideoExportPreset.ultrafast,
                     outDir: "/storage/emulated/0/Download/videos1",
                     onCompleted: (file) {
                     print("file => ${file.path}");
                   },);
                // }

        }, icon: Icon(Icons.add))],
      ),
      // body: Center(
      //   child: _controller != null
      //       ? AspectRatio(
      //     aspectRatio: 9/16, // Set the desired aspect ratio (9:16)
      //     child: VideoPlayer(_controller!),
      //   )
      //       : CircularProgressIndicator(),
      // ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     setState(() {
      //       if (_controller!.value.isPlaying) {
      //         _controller!.pause();
      //       } else {
      //         _controller!.play();
      //       }
      //     });
      //   },
      //   child: Icon(
      //     _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
      //   ),
      // ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    // _controller?.dispose();
  }
}

void main() => runApp(MaterialApp(
  home: Scaffold(
    body: VideoPlayerScreen(),
  ),
));

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_editor/video_editor.dart';
import 'package:video_player/video_player.dart';
class VideoPlayerScreen extends StatefulWidget {
  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  List<Widget> widgets =[IconButton(onPressed: (){}, icon: Icon(Icons.abc_outlined))];
  VideoPlayerController videoController = VideoPlayerController.file(
      File("/storage/emulated/0/Download/videos1/Flutter_demo1.mp4"),
  );
  double aspectRtio=0.1;
  final editor = VideoEditorController.file(
      File("/storage/emulated/0/Download/videos1/YouVideo.mp4"),
      maxDuration: const Duration(seconds: 20),
      minDuration: const Duration(seconds: 0),
      cropStyle: CropGridStyle(background: Colors.black54,croppingBackground: Colors.lime.shade100)
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Player'),
        actions: [
          IconButton(
              onPressed: () async {
                   await editor.initialize(aspectRatio: 9/16);
                   editor.cropAspectRatio(9/16);
                  // editor.updateCrop(const Offset(0.7, 0.2),const Offset(0.8,0.3),);
                   // editor.cropAspectRatio(9/16);
                   print("aspect Ratio  :${editor.preferredCropAspectRatio!}");
                   // print("aspect Ratio  :${editor.preferredCropAspectRatio!}");
                   print("croping ? ${editor.isCropping}");
                   print("trimme ? ${editor.isTrimmed}");
                   print("trimming ? ${editor.isTrimming}");
                   print("duration ? ${editor.videoDuration}");
                   // editor.applyCacheCrop();
                   // aspectRtio= editor.croppedArea.aspectRatio;
                   // print("videoController : ${editor.croppedArea.aspectRatio}");
                   setState(() {});
                   editor.exportVideo(
                     // preset: VideoExportPreset.ultrafast,
                     // scale: 0.8,
                     outDir: "/storage/emulated/0/Download/videos1",
                     onCompleted: (file) async {
                       print("${file.path}");
                       videoController=VideoPlayerController.file(file);
                       await videoController.initialize();
                       await videoController.play();
                       setState(() {});
                   },);
                // }

        }, icon: const Icon(Icons.add))],
      ),
      body:SingleChildScrollView(
        child: Column(
          children: [
            Container(height: 200,color: Colors.lime,width: double.maxFinite,),
            CropGridViewer.preview(controller: editor),
          ],
        ),
      ),
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

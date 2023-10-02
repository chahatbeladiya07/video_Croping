import 'dart:io';

import 'package:external_path/external_path.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit_config.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
// import 'package:video_editor/video_editor.dart';
// import 'package:youtube_project/videoEditorController.dart';
import '';

void main(){
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: VideoToAudioConverter() ,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController youtubeLinkController=TextEditingController();
  double linearvalue=0;
  String youtubeDownloadFilePath="";
  File? file=File("/storage/emulated/0/Download/videos1/video1.mp4");
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: (){},
              icon: const Icon(Icons.access_time)),

        ],
      ),
      body: Column(children: [

        TextField(
            controller: youtubeLinkController,
        ),
        ElevatedButton(
            onPressed: () async {
              final yt = YoutubeExplode();
              final video = await yt.videos.get(youtubeLinkController.text.trim());
              // Get the video manifest.
              final manifest = await yt.videos.streamsClient.getManifest(youtubeLinkController.text.trim());
              // print("${manifest.videoOnly.elementAt(3).qualityLabel}");
              var videoDown;
              for(int i=0; i<manifest.videoOnly.length; i++){
                if(manifest.videoOnly.elementAt(i).qualityLabel.toString() == "1080p"){
                  videoDown=manifest.videoOnly.elementAt(i);
                  print("Video = ${videoDown}");
                  break;
                }
              }
              final audio=manifest.audioOnly.elementAt(1);
              print(videoDown);
              // print("Stream data Type : ${videoDown.size.totalMegaBytes}");
              final audioStream = yt.videos.streamsClient.get(videoDown);
              // await audioStream.forEach((element) {print("element ======> ${}");});
              final nowTime="${DateTime.now().day}${DateTime.now().hour}${DateTime.now().minute}${DateTime.now().second}${DateTime.now().millisecond}";
              final fileName = '$nowTime.${videoDown.container.name}'
                  .replaceAll(r'\','')
                  .replaceAll('/','')
                  .replaceAll('*','')
                  .replaceAll('?','')
                  .replaceAll('"','')
                  .replaceAll('<', '')
                  .replaceAll('>', '')
                  .replaceAll('|', '');
              final dir = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);
              final path = dir;
              final directory = Directory('$path/videos1/');
              await directory.create(recursive: true);
              final youtubefile = File('$path/videos1/${fileName}');
              final output = youtubefile.openWrite(mode: FileMode.writeOnlyAppend);
              print("outPut => ${output.encoding.name}");
              var len = videoDown.size.totalBytes;
              print("len : : ${len}");
              double count = 0;
              var msg = 'Downloading ${video.title}.${videoDown.container.name}';
              stdout.writeln(msg);
              // Fluttertoast.showToast(msg: "VideoDownloading...");
              await for (final data in audioStream){
                count += data.length;
                var progress = ((count / len)*100).ceil();
                linearvalue = progress/100;
                print("linear Value :- $linearvalue");
                output.add(data);
                setState(() {});
              }
              await output.flush();
              await output.close();
              file = youtubefile;
              youtubeDownloadFilePath=youtubefile.path;

            },
            child: const Text("next"),
        ),


      ],),
    );
  }
}

class VideoToAudioConverter extends StatefulWidget {



  @override
  _VideoToAudioConverterState createState() => _VideoToAudioConverterState();
}

class _VideoToAudioConverterState extends State<VideoToAudioConverter> {
  // VideoPlayerController _videoPlayerController;
  File? file;

  @override
  // void initState() {
  //   super.initState();
  //   _videoPlayerController = VideoPlayerController.file(File(widget.videoFilePath))
  //     ..initialize().then((_) {
  //       // Ensure the first frame is shown
  //       setState(() {});
  //     });
  // }

  @override
  void dispose() {
    // _videoPlayerController.dispose();
    super.dispose();
  }
  //
  // Future<void> _extractAudio() async {
  //   final mediaInfo = await MediaInfo.getMediaInfo(widget.videoFilePath);
  //
  //   final audioStream = mediaInfo.audioStreams?.first;
  //
  //   if (audioStream == null) {
  //     print('No audio stream found in the video.');
  //     return;
  //   }
  //
  //   final audioFilePath = 'path_to_save_extracted_audio/audio.mp3'; // Change the path as needed
  //
  //   await File(audioFilePath).writeAsBytes(audioStream.bytes);
  //
  //   print('Audio extracted and saved at: $audioFilePath');
  // }
  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video to Audio Converter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // AspectRatio(
            //   aspectRatio: _videoPlayerController.value.aspectRatio,
            //   child: VideoPlayer(_videoPlayerController),
            // ),
            ElevatedButton(
              onPressed: () async {
                print("Clicked");
                final nowTime="${DateTime.now().day}${DateTime.now().hour}${DateTime.now().minute}${DateTime.now().second}${DateTime.now().millisecond}";
                const videoPath="/storage/emulated/0/download/Youtube7.mp4";
                const audioPath="/storage/emulated/0/download/Youtube7.mp3";
                final outputFilePath="/storage/emulated/0/download/Youtube$nowTime.mp4";
                final command='-i $videoPath -i $audioPath -c:v copy -c:a aac -strict experimental $outputFilePath';
                await FFmpegKit.executeAsync(command,(session) async {
                  final state  =
                  FFmpegKitConfig.sessionStateToString(await session.getState());
                  final returnCode = await session.getReturnCode();
                  final output = await session.getAllLogsAsString();
                  debugPrint("FFmpeg process output: $output");
                  debugPrint("FFmpeg process exited with state $state and rc $returnCode");
                  if (ReturnCode.isSuccess(returnCode)) {
                    print("outPut path => ${File(outputFilePath).path}");
// file =await File(outputpath);
// print("fileOutputPath ====> ${file!.path}");
                    print("returnCode ====> ${returnCode!.isValueSuccess()}");
                    debugPrint('Video successfully saved');
// setState((){});
// print("videoLength = ${_videoPlayerController!.value.duration}");
// debugPrint("FFmpeg processing completed successfully.");

// Fluttertoast.showToast(msg: "Video ready to go ");
// setState(() {});
                  } else {
// Fluttertoast.showToast(msg: "Something Went Wrong");
// debugPrint("FFmpeg processing failed.");
                    debugPrint('Couldn\'t save the video');
                  }
                });
              },
              child: Text('Extract Audio'),
            ),
          ],
        ),
      ),
    );
  }
}



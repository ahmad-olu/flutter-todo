import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo_isar_db/audio_todo/audio_payer.dart';
import 'package:todo_isar_db/audio_todo/audio_recorder.dart';

class AudioTodoPage extends HookWidget {
  const AudioTodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    //final showPlayer = useState<bool>(false);
    final audioPath = useState<String?>(null);
    final listOfAudioPath = useState<List<String>>([]);

    useEffect(() {
      Future<void> listFilesInDirectory() async {
        try {
          final appDocumentsDirectory =
              await getApplicationDocumentsDirectory();
          final appDocumentsPath = appDocumentsDirectory.path;
          final directory = Directory(appDocumentsPath);
          //final files = appDocumentsDirectory.listSync();
          final pattern = RegExp(r'^.*\/audio_.*');

          directory.listSync().forEach((entity) {
            if (entity is File) {
              final filePath = entity.path;
              if (pattern.hasMatch(filePath)) {
                listOfAudioPath.value = [
                  ...listOfAudioPath.value,
                  filePath,
                ];
                //log('- File: $filePath');
              }
            }
          });

          // for (final file in files) {
          //   if (file is File) {
          //     if (RegExp(r'^audio_.*$').hasMatch(file.path)) {
          //       log('- File: ${file.path}');
          //     }
          //     log('File: ${file.path}');
          //   } else if (file is Directory) {
          //     log('Directory: ${file.path}');
          //   }
          // }

          // final f2 = File(
          //     '/data/user/0/com.example.todo_isar_db/app_flutter/audio_1698038928215.m4a');
          // f2.delete();
        } catch (e) {
          log('Error: $e');
        }
      }

      listFilesInDirectory();
      return null;
    }, [listOfAudioPath]);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Audio Todos',
          style: TextStyle(
            color: Color.fromARGB(255, 4, 50, 87),
          ),
          textScaleFactor: 2,
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Color.fromARGB(255, 4, 50, 87),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
          child: ListView.builder(
        itemCount: listOfAudioPath.value.length,
        itemBuilder: (context, index) {
          final audioP = listOfAudioPath.value[index];
          return AudioPlayer(
            source: audioP,
            onDelete: () {
              // showPlayer.value = false;
            },
          );
        },
      )),
      bottomSheet: SizedBox(
        height: 200,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(
                    color: Colors.black,
                    width: 3,
                  )),
              child: Recorder(
                onStop: (path) {
                  if (kDebugMode) log('Recorded file path: $path');

                  audioPath.value = path;
                  audioPath.value = null;
                  //showPlayer.value = true;
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

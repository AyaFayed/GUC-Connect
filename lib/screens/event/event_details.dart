// ignore_for_file: unused_local_variable

import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:guc_scheduling_app/theme/sizes.dart';
import 'package:path_provider/path_provider.dart';

class EventDetails extends StatefulWidget {
  final String courseName;
  final String title;
  final String subtitle;
  final String description;
  final String? file;

  const EventDetails({
    super.key,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.courseName,
    required this.file,
  });

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  TextEditingController url = TextEditingController();
  bool _progress = false;
  String downloadConfirmation = '';

  final ReceivePort _port = ReceivePort();

  @override
  void initState() {
    super.initState();

    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      setState(() {});
    });

    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  @pragma('vm:entry-point')
  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send!.send([id, status, progress]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.courseName),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
          child: Container(
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 40.0),
            Text(
              widget.title,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20.0),
            Text(
              widget.subtitle,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20.0),
            Text(
              widget.description,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20.0),
            widget.file != null
                ? _progress
                    ? const CircularProgressIndicator()
                    : TextButton(
                        onPressed: () async {
                          setState(() {
                            _progress = true;
                          });
                          var dir = await getExternalStorageDirectory();

                          await FlutterDownloader.enqueue(
                            url: widget.file!,
                            headers: {}, // optional: header send with url (auth token etc)
                            savedDir: dir!.path,
                            saveInPublicStorage: true,
                            showNotification:
                                true, // show download progress in status bar (for Android)
                            openFileFromNotification:
                                true, // click on notification to open downloaded file (for Android)
                          );

                          setState(() {
                            _progress = false;
                          });
                        },
                        child: const Text(
                          'File',
                          style: TextStyle(fontSize: 20),
                        ),
                      )
                : const SizedBox(height: 0.0),
            Text(downloadConfirmation, style: TextStyle(fontSize: Sizes.xsmall))
          ],
        ),
      )),
    );
  }
}

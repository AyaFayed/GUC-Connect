// ignore_for_file: unused_local_variable

import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:guc_scheduling_app/theme/colors.dart';
import 'package:guc_scheduling_app/theme/sizes.dart';
import 'package:path_provider/path_provider.dart';

class DownloadFile extends StatefulWidget {
  final String file;

  const DownloadFile({
    super.key,
    required this.file,
  });

  @override
  State<DownloadFile> createState() => _DownloadFileState();
}

class _DownloadFileState extends State<DownloadFile> {
  bool _progress = false;
  String? downloadConfirmation;

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
    return Row(
      children: <Widget>[
        _progress
            ? const CircularProgressIndicator()
            : TextButton.icon(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  alignment: Alignment.centerLeft,
                ),
                onPressed: () async {
                  setState(() {
                    _progress = true;
                  });
                  var dir = await getExternalStorageDirectory();

                  await FlutterDownloader.enqueue(
                    url: widget.file,
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
                    downloadConfirmation = 'File downloaded';
                  });
                },
                icon: const Icon(Icons.attach_file),
                label: Text(
                  'Attachment',
                  style: TextStyle(fontSize: Sizes.xsmall),
                ),
              ),
        const Spacer(),
        if (downloadConfirmation != null)
          Text(downloadConfirmation!,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.unselected,
              ))
      ],
    );
  }
}

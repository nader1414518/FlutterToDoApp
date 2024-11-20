import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart';

class ItemMediaScreen extends StatefulWidget {
  final int id;

  const ItemMediaScreen({
    super.key,
    required this.id,
  });

  @override
  ItemMediaScreenState createState() => ItemMediaScreenState();
}

class ItemMediaScreenState extends State<ItemMediaScreen> {
  bool isLoading = false;

  Future<void> getData() async {
    setState(() {
      isLoading = true;
    });

    try {} catch (e) {
      print(e.toString());
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          "Media",
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 20,
              ),
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              children: [],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          setState(() {
            isLoading = true;
          });

          try {
            FilePickerResult? result = await FilePicker.platform.pickFiles(
              allowMultiple: false,
              type: FileType.custom,
              allowedExtensions: [
                'jpg',
                'pdf',
                'doc',
                'jpeg',
                'mp4',
                'avi',
                '3gp',
                'mkv',
              ],
            );

            if (result!.files.isEmpty) {
              return;
            }

            var file = result.files.first;

            // Upload file to supabase
            final Uint8List mediaFile = File(file.path!).readAsBytesSync();
            final String fullPath = await Supabase.instance.client.storage
                .from('ItemsMedia')
                .uploadBinary(
                  "${DateTime.now().toIso8601String().replaceAll(".", "").replaceAll(":", "").replaceAll(" ", "")}_${basename(file.path!).replaceAll(' ', '')}",
                  mediaFile,
                );

            print(fullPath);
          } catch (e) {
            print(e.toString());
          }

          setState(() {
            isLoading = false;
          });
        },
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}

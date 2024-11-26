import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:to_do_app/controllers/items_media_controller.dart';
import 'package:to_do_app/screens/pdf_viewer_screen.dart';
import 'package:to_do_app/screens/photo_viewer_screen.dart';
import 'package:to_do_app/screens/video_player_screen.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';

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

  List<Map<String, dynamic>> media = [];

  Future<void> getData() async {
    setState(() {
      isLoading = true;
    });

    try {
      var res = await ItemsMediaController.getItemMedia(
        widget.id,
      );

      setState(() {
        media = res;
      });
    } catch (e) {
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
              children: [
                ...media.map((e) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                    ),
                    child: InkWell(
                      onTap: () async {
                        print(e);

                        var itemUrl = await Supabase.instance.client.storage
                            .from("ItemsMedia")
                            .getPublicUrl(
                              e["filename"].toString(),
                            );

                        if ([".jpeg", ".jpg", ".png"]
                            .contains(e["extension"])) {
                          // Go to photo view
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return PhotoViewerScreen(
                                  url: itemUrl,
                                );
                              },
                            ),
                          );
                        } else if ([".mp4", ".mkv", ".avi"]
                            .contains(e["extension"])) {
                          // Go to video view
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return VideoPlayerScreen(
                                  url: itemUrl,
                                );
                              },
                            ),
                          );
                        } else if ([".pdf"].contains(e["extension"])) {
                          // Go to video view
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return PDFViewerScreen(
                                  url: itemUrl,
                                );
                              },
                            ),
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          borderRadius: BorderRadius.circular(
                            15,
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width:
                                      (MediaQuery.sizeOf(context).width - 60) *
                                          0.6,
                                  child: Text(
                                    e["filename"].toString().split("_")[1],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      (MediaQuery.sizeOf(context).width - 60) *
                                          0.3,
                                  child: Text(
                                    e["extension"]
                                        .toString()
                                        .replaceAll(".", "")
                                        .toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ],
                            ),
                            // const Divider(),
                            const SizedBox(
                              height: 10,
                            ),
                            [".mp4", ".mkv", ".avi"].contains(e["extension"])
                                ? Container(
                                    height: 100,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          e["snapshot_url"],
                                        ),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  )
                                : [".jpeg", ".jpg", ".png"]
                                        .contains(e["extension"])
                                    ? Container(
                                        height: 100,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(
                                              e["url"],
                                            ),
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      )
                                    : Container(),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                  onPressed: () async {
                                    setState(() {
                                      isLoading = true;
                                    });

                                    try {
                                      var res = await ItemsMediaController
                                          .removeMedia(
                                        e["id"],
                                      );

                                      if (res["result"] == true) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              res["message"],
                                            ),
                                          ),
                                        );

                                        setState(() {
                                          media = media
                                              .where((element) =>
                                                  element["id"] != e["id"])
                                              .toList();
                                        });
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              res["message"],
                                            ),
                                          ),
                                        );
                                      }
                                    } catch (e) {
                                      print(e.toString());
                                    }

                                    setState(() {
                                      isLoading = false;
                                    });
                                  },
                                  child: const Text(
                                    "Remove",
                                    style: TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
                const SizedBox(
                  height: 180,
                ),
              ],
            ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(
          bottom: kBottomNavigationBarHeight * 1.25,
        ),
        child: FloatingActionButton(
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
              String extension = p.extension(file.path!);
              String original_filename = p
                  .basename(file.path!)
                  .replaceAll(' ', '')
                  .replaceAll("_", "");
              String filename =
                  "${DateTime.now().toIso8601String().replaceAll(".", "").replaceAll(":", "").replaceAll(" ", "")}_$original_filename";
              final Uint8List mediaFile = File(file.path!).readAsBytesSync();
              final String fullPath = await Supabase.instance.client.storage
                  .from('ItemsMedia')
                  .uploadBinary(
                    filename,
                    mediaFile,
                  );

              var itemUrl = await Supabase.instance.client.storage
                  .from("ItemsMedia")
                  .getPublicUrl(
                    filename,
                  );

              String snapshotUrl = "";

              if ([".mp4", ".mkv", ".avi"].contains(extension)) {
                final uint8list = await VideoThumbnail.thumbnailData(
                  video: itemUrl,
                  imageFormat: ImageFormat.JPEG,
                  maxWidth:
                      128, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
                  quality: 25,
                );

                final String snapshotPath = await Supabase
                    .instance.client.storage
                    .from('ItemsMedia')
                    .uploadBinary(
                      "snapshot_$filename",
                      uint8list,
                    );

                snapshotUrl = await Supabase.instance.client.storage
                    .from("ItemsMedia")
                    .getPublicUrl(
                      "snapshot_$filename",
                    );
              }

              // Store file in supbase database
              var storeRes = await ItemsMediaController.storeMediaToItem({
                "filename": filename,
                "item_id": widget.id,
                "extension": extension,
                "path": fullPath,
                "url": itemUrl,
                "snapshot_url": snapshotUrl,
              });

              // Refresh screen to get new media
              if (storeRes["result"] == true) {
                getData();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      storeRes["message"],
                    ),
                  ),
                );
              }
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
      ),
    );
  }
}

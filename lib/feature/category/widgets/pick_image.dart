import 'dart:io';

import 'package:drawing_app/feature/drawing_canvas/ui/drawing_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

final ImagePicker _picker = ImagePicker();

Future<void> pickImage(BuildContext context) async {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (sheetContext) {
      return SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.photo),
              title: Text("Gallery"),
              onTap: () async {
                Navigator.pop(sheetContext);
                try {
                  final XFile? file = await _picker.pickImage(
                    source: ImageSource.gallery,
                  );

                  if (!context.mounted) return;

                  if (file != null) {
                    _openEditor(context, File(file.path));
                  }
                } catch (e) {
                  debugPrint("Image pick error: $e");
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text("Camera"),
              onTap: () async {
                Navigator.pop(sheetContext);
                try {
                  final XFile? file = await _picker.pickImage(
                    source: ImageSource.camera,
                  );

                  if (!context.mounted) return;

                  if (file == null) {
                    debugPrint("User cancelled or permission denied");
                    return;
                  }

                  _openEditor(context, File(file.path));
                } catch (e) {
                  debugPrint("Image pick error: $e");
                  if (!context.mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Permission denied or camera unavailable"),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      );
    },
  );
}

void _openEditor(BuildContext context, File file) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => DrawingPage(backgroundImage: FileImage(file)),
    ),
  );
}

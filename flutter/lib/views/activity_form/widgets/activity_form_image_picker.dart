import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_chapitre13/providers/city_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ActivityFormImagePicker extends StatefulWidget {
  final Function updateUrl;
  const ActivityFormImagePicker({Key? key, required this.updateUrl})
      : super(key: key);

  @override
  State<ActivityFormImagePicker> createState() =>
      _ActivityFormImagePickerState();
}

class _ActivityFormImagePickerState extends State<ActivityFormImagePicker> {
  File? _deviceImage;

  Future<void> _pickImage(ImageSource source) async {
    try {
      XFile? pickedFile = await ImagePicker().pickImage(source: source);

      if (pickedFile != null) {
        final url = await Provider.of<CityProvider>(context, listen: false)
            .uploadImage(_deviceImage!);
        _deviceImage = File(pickedFile.path);
        widget.updateUrl(url);
        setState(() {});
        print('image ok');
      } else {
        print('pas d\'image');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton.icon(
                icon: Icon(Icons.photo),
                label: Text('Galerie'),
                onPressed: () => _pickImage(ImageSource.gallery),
              ),
              TextButton.icon(
                icon: Icon(Icons.photo_camera),
                label: Text('camera'),
                onPressed: () => _pickImage(ImageSource.camera),
              ),
            ],
          ),
          Container(
            width: double.infinity,
            child: _deviceImage != null
                ? Image.file(_deviceImage as File)
                : Text('aucune image'),
          ),
        ],
      ),
    );
  }
}

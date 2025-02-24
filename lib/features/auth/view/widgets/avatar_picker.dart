import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AvatarPicker extends StatefulWidget {
  final Function(Uint8List?) onImageSelected;

  const AvatarPicker({super.key, required this.onImageSelected});

  @override
  AvatarPickerState createState() => AvatarPickerState();
}

class AvatarPickerState extends State<AvatarPicker> {
  Uint8List? _imageBytes;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final Uint8List imageBytes = await image.readAsBytes();
      setState(() {
        _imageBytes = imageBytes;
      });
      widget.onImageSelected(imageBytes);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.black.withOpacity(0.1),
          backgroundImage:
              _imageBytes != null ? MemoryImage(_imageBytes!) : null,
        ),
        Positioned(
          child: IconButton(
            icon: Icon(
              Icons.add,
              size: 30,
              color: Colors.white,
            ),
            onPressed: _pickImage,
          ),
        ),
      ],
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {

  //construct
  const UserImagePicker({
    super.key,
    required this.onPickImage,
  });

  //Therefore, to communicate from that widget to the parent widget that contains this widget
  //which will be a function. A function that returns nothing,
  // but it actually should take one input value, one parameter,
  final void Function(File pickedImage) onPickImage;

  @override
  State<UserImagePicker> createState() {
    return _UserImagePickerState();
  }
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImageFile;

  void _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.camera,//Of course, you could also use the gallery, but here I'll use the camera.
      imageQuality: 50,
      maxWidth: 150,
    );

    //pickedImage may be Null if we closed the camera without picking one.
    if (pickedImage == null) {
      return;
    }

    //We'll only continue with this step here if pickedImage is not equal to Null.
    setState(() {
      _pickedImageFile = File(pickedImage.path);
    });

    //So to make sure that the picked image is not just shown as a preview here,
    // but instead also uploaded when we submit this form, so once we click sign up here.
    // We first of all have to make sure that this picked image, which we got through the image picker package,
    // is communicated to this form

    //we can reach out to the connected widget through that special widget property,
    // and then there call on pick image to execute that function
    widget.onPickImage(_pickedImageFile!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          foregroundImage:
              _pickedImageFile != null ? FileImage(_pickedImageFile!) : null,
        ),
        TextButton.icon(
          onPressed: _pickImage,
          icon: const Icon(Icons.image),
          label: Text('Add Image',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        )
      ],
    );
  }
}

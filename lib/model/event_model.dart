import 'package:scoped_model/scoped_model.dart';
import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class EventModel extends Model {
  File _image;

  File get image => _image;
  Future getImage() async {
    _image = await ImagePicker.pickImage(source: ImageSource.gallery);

    notifyListeners();
  }
}

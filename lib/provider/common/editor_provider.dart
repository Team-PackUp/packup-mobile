import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';

enum EditorType { view, write }

class EditorProvider extends ChangeNotifier {
  late QuillController _quillController;
  QuillController get quillController => _quillController;

  EditorType _editMode = EditorType.view;
  EditorType get editMode => _editMode;

  String _content = '';
  String get content => _content;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  EditorProvider(String data, EditorType type) {
    _isLoading = true;
    _content = data;

    if (_content.trim().isNotEmpty) {
      setQuillDelta(_content);
    } else {
      empty();
    }

    _editMode = type;

    type == EditorType.view ?
    _quillController.readOnly = true :
    _quillController.readOnly = false;

    _isLoading = false;
    notifyListeners();
  }

  void empty() {
    _quillController = QuillController(
      document: Document(),
      selection: const TextSelection.collapsed(offset: 0),
    );
  }

  void setQuillDelta(String jsonContent) {
    final contentJson = jsonDecode(jsonContent);
    final delta = Delta.fromJson(contentJson['ops']);

    _quillController = QuillController(
      document: Document.fromDelta(delta),
      selection: const TextSelection.collapsed(offset: 0),
    );
  }
}

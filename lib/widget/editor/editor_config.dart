
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';

import '../../Const/color.dart';

class EditorConfig {

  static final EditorConfig _instance = EditorConfig._internal();

  // 객체 생성 방지
  EditorConfig._internal();

  // 싱글톤 보장용 > 팩토리 생성자 > 실제로 객체 생성 없이 상황에 맞는 객체 반환
  factory EditorConfig() {
    return _instance;
  }

  QuillEditorConfig editorConfig() {
    return QuillEditorConfig(
      showCursor: false,
      placeholder: 'Start writing your notes...',
      padding: const EdgeInsets.all(16),
      embedBuilders: [
        ...FlutterQuillEmbeds.editorBuilders(
          imageEmbedConfig: QuillEditorImageEmbedConfig(
            imageProviderBuilder: (context, imageUrl) {
              if (imageUrl.startsWith('assets/')) {
                return AssetImage(imageUrl);
              }
              return null;
            },
          ),
          videoEmbedConfig: QuillEditorVideoEmbedConfig(
            customVideoBuilder: (videoUrl, readOnly) {
              return null;
            },
          ),
        ),
        // TimeStampEmbedBuilder(),
      ],
    );
  }

}
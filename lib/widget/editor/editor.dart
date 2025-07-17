import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:packup/provider/common/editor_provider.dart';
import 'package:provider/provider.dart';

import 'editor_config.dart';
import 'editor_toolbar.dart';

class Editor extends StatelessWidget {
  final String content;
  final EditorType type;

  const Editor({
    super.key,
    required this.content,
    required this.type
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EditorProvider(content, type),
      child: EditorContent(),
    );
  }
}

class EditorContent extends StatefulWidget {

  const EditorContent({
    super.key,
  });

  @override
  EditorContentState createState() => EditorContentState();
}

class EditorContentState extends State<EditorContent> {
  final FocusNode _editorFocusNode = FocusNode();
  final ScrollController _editorScrollController = ScrollController();

  late EditorProvider _editorProvider;

  @override
  void initState() {
    super.initState();
    _editorProvider = context.read<EditorProvider>();
  }

  @override
  Widget build(BuildContext context) {
    _editorProvider = context.watch<EditorProvider>();

    return Column(
          children: [
            EditorToolbar().editorToolBar(
                _editorProvider.quillController,
                _editorProvider.editMode
            ),
            Expanded(
              child: QuillEditor.basic(
                controller: _editorProvider.quillController,
                focusNode: _editorFocusNode,
                scrollController: _editorScrollController,
                config: EditorConfig().editorConfig(),
              ),
            ),
          ],
    );
  }

  @override
  void dispose() {
    super.dispose();

    _editorScrollController.dispose();
    _editorFocusNode.dispose();
  }
}

// // 커스텀 임베드 클래스
// class TimeStampEmbed extends Embeddable {
//   const TimeStampEmbed(String value) : super(timeStampType, value);
//
//   static const String timeStampType = 'timeStamp';
//
//   static TimeStampEmbed fromDocument(Document document) =>
//       TimeStampEmbed(jsonEncode(document.toDelta().toJson()));
//
//   Document get document => Document.fromJson(jsonDecode(data));
// }
//
// // 커스텀 임베드 빌더
// class TimeStampEmbedBuilder extends EmbedBuilder {
//   @override
//   String get key => 'timeStamp';
//
//   @override
//   String toPlainText(Embed node) {
//     return node.value.data;
//   }
//
//   @override
//   Widget build(BuildContext context, EmbedContext embedContext) {
//     return Row(
//       children: [
//         const Icon(Icons.access_time_rounded),
//         Text(embedContext.node.value.data as String),
//       ],
//     );
//   }
// }

import 'dart:convert';
import 'dart:io' as io show Directory, File;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:packup/provider/common/editor_provider.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';

import '../../Const/color.dart';

/**
 * 상태: readOnly
 * 복사 및 드래그는 됨: 드래그 하이라이트 표시는 안됨
 * 포커스 false
 */
class Editor extends StatelessWidget {
  final String content;

  const Editor({
    super.key,
    required this.content
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => EditorProvider(content)),
      ],
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

  late EditorProvider editorProvider;

  @override
  void initState() {
    super.initState();
    editorProvider = context.read<EditorProvider>();
  }

  @override
  Widget build(BuildContext context) {
    editorProvider = context.watch<EditorProvider>();
    // _editorFocusNode.unfocus();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // QuillSimpleToolbar(
            //   controller: editorProvider.quillController,
            //   config: QuillSimpleToolbarConfig(
            //     showFontFamily: false,
            //     showFontSize: false,
            //     showItalicButton: false,
            //     showSmallButton: false,
            //     showStrikeThrough: false,
            //     showInlineCode: false,
            //     showBackgroundColorButton: false,
            //     showClearFormat: false,
            //     showAlignmentButtons: false,
            //     showLeftAlignment: false,
            //     showCenterAlignment: false,
            //     showRightAlignment: false,
            //     showJustifyAlignment: false,
            //     showHeaderStyle: false,
            //     showListNumbers: false,
            //     showListBullets: false,
            //     showListCheck: false,
            //     showCodeBlock: false,
            //     showQuote: false,
            //     showIndent: false,
            //     showLink: false,
            //     showUndo: false,
            //     showRedo: false,
            //     showDirection: false,
            //     showSearchButton: false,
            //     showSubscript: false,
            //     showSuperscript: false,
            //     showClipboardCut: false,
            //     showClipboardCopy: false,
            //     showClipboardPaste: false,
            //     embedButtons: FlutterQuillEmbeds.toolbarButtons(),
            //     customButtons: [
            //       QuillToolbarCustomButtonOptions(
            //         icon: const Icon(Icons.add_alarm_rounded),
            //         onPressed: () {
            //           editorProvider.quillController!.document.insert(
            //             editorProvider.quillController!.selection.extentOffset,
            //               editorProvider.quillController!.document.changes
            //             // TimeStampEmbed(DateTime.now().toString()),
            //           );
            //           editorProvider.quillController!.updateSelection(
            //             TextSelection.collapsed(
            //               offset: editorProvider.quillController!.selection.extentOffset + 1,
            //             ),
            //             ChangeSource.local,
            //           );
            //         },
            //       ),
            //     ],
            //     buttonOptions: QuillSimpleToolbarButtonOptions(
            //       bold: QuillToolbarToggleStyleButtonOptions(
            //         iconTheme: QuillIconTheme(
            //           iconButtonSelectedData: IconButtonData(
            //             color: PRIMARY_COLOR,
            //             hoverColor: TEXT_COLOR_B,
            //             style: ButtonStyle(
            //               backgroundColor: WidgetStateProperty.all(TEXT_COLOR_B),
            //             ),
            //           ),
            //         ),
            //       ),
            //       underLine: QuillToolbarToggleStyleButtonOptions(
            //         iconTheme: QuillIconTheme(
            //           iconButtonSelectedData: IconButtonData(
            //             color: PRIMARY_COLOR,
            //             hoverColor: TEXT_COLOR_B,
            //             style: ButtonStyle(
            //               backgroundColor: WidgetStateProperty.all(TEXT_COLOR_B),
            //             ),
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            Expanded(
              // child: QuillRawEditor(
              //   controller: editorProvider.quillController,
              //   config: QuillRawEditorConfig(
              //     readOnly: true,
              //     padding: EdgeInsets.all(8),
              //     scrollable: true,
              //     focusNode: FocusNode(),
              //     scrollController: ScrollController(),
              //   ),
              // )
              child: QuillEditor(
                controller: editorProvider.quillController,
                focusNode: _editorFocusNode,
                scrollController: _editorScrollController,
                config: QuillEditorConfig(
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
                ),
              ),
            ),
          ],
        ),
      ),
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

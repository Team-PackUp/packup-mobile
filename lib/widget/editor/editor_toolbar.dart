
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:packup/provider/common/editor_provider.dart';

import '../../Const/color.dart';

class EditorToolbar {

  static final EditorToolbar _instance = EditorToolbar._internal();

  // 객체 생성 방지
  EditorToolbar._internal();

  // 싱글톤 보장용 > 팩토리 생성자 > 실제로 객체 생성 없이 상황에 맞는 객체 반환
  factory EditorToolbar() {
    return _instance;
  }

  Widget editorToolBar(QuillController controller, EditorType type) {
    switch(type) {
      case EditorType.view:
        return SizedBox.shrink();
      case EditorType.write:
        return QuillSimpleToolbar(
          controller: controller,
          config: QuillSimpleToolbarConfig(
            showFontFamily: false,
            showFontSize: false,
            showItalicButton: false,
            showSmallButton: false,
            showStrikeThrough: false,
            showInlineCode: false,
            showBackgroundColorButton: false,
            showClearFormat: false,
            showAlignmentButtons: false,
            showLeftAlignment: false,
            showCenterAlignment: false,
            showRightAlignment: false,
            showJustifyAlignment: false,
            showHeaderStyle: false,
            showListNumbers: false,
            showListBullets: false,
            showListCheck: false,
            showCodeBlock: false,
            showQuote: false,
            showIndent: false,
            showLink: false,
            showUndo: false,
            showRedo: false,
            showDirection: false,
            showSearchButton: false,
            showSubscript: false,
            showSuperscript: false,
            showClipboardCut: false,
            showClipboardCopy: false,
            showClipboardPaste: false,
            embedButtons: FlutterQuillEmbeds.toolbarButtons(),
            customButtons: [
              QuillToolbarCustomButtonOptions(
                icon: const Icon(Icons.add_alarm_rounded),
                onPressed: () {
                  controller.document.insert(
                      controller.selection.extentOffset,
                      controller.document.changes
                    // TimeStampEmbed(DateTime.now().toString()),
                  );
                  controller.updateSelection(
                    TextSelection.collapsed(
                      offset: controller.selection.extentOffset + 1,
                    ),
                    ChangeSource.local,
                  );
                },
              ),
            ],
            buttonOptions: QuillSimpleToolbarButtonOptions(
              bold: QuillToolbarToggleStyleButtonOptions(
                iconTheme: QuillIconTheme(
                  iconButtonSelectedData: IconButtonData(
                    color: PRIMARY_COLOR,
                    hoverColor: TEXT_COLOR_B,
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(TEXT_COLOR_B),
                    ),
                  ),
                ),
              ),
              underLine: QuillToolbarToggleStyleButtonOptions(
                iconTheme: QuillIconTheme(
                  iconButtonSelectedData: IconButtonData(
                    color: PRIMARY_COLOR,
                    hoverColor: TEXT_COLOR_B,
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(TEXT_COLOR_B),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );

    }
  }

}
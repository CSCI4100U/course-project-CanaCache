import "package:canacache/common/utils/mvc.dart";
import "package:canacache/features/firestore/controller/text_field_dialog_controller.dart";
import "package:canacache/features/settings/model/settings_provider.dart";
import "package:flutter/material.dart";
import "package:flutter_translate/flutter_translate.dart";
import "package:provider/provider.dart";

class TextFieldDialog extends StatefulWidget {
  final String title;
  final String? text;
  final Future<void> Function(String? text) onSave;
  final bool multiline;
  final int maxLength;
  final String? Function(String? value)? validator;

  const TextFieldDialog({
    super.key,
    required this.title,
    required this.text,
    required this.onSave,
    required this.multiline,
    required this.maxLength,
    this.validator,
  });

  @override
  State<TextFieldDialog> createState() => TextFieldDialogState();
}

class TextFieldDialogState
    extends ViewState<TextFieldDialog, TextFieldDialogController> {
  TextFieldDialogState() : super(TextFieldDialogController());

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<SettingsProvider>(context).theme;

    return AlertDialog(
      backgroundColor: theme.primaryBgColor,
      title: Text(
        widget.title,
        style: TextStyle(color: theme.primaryTextColor),
      ),

      // input field
      content: Form(
        key: con.formKey,
        child: TextFormField(
          controller: con.textEditingController,
          style: TextStyle(color: theme.primaryTextColor),
          decoration: InputDecoration(
            helperStyle: TextStyle(color: theme.primaryTextColor),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: theme.primaryIconColor),
            ),
          ),
          keyboardType: widget.multiline ? TextInputType.multiline : null,
          maxLines: widget.multiline ? null : 1,
          maxLength: widget.maxLength,
          validator: widget.validator,
          autofocus: true,
        ),
      ),

      // buttons
      actions: con.isSaving
          ? [const LinearProgressIndicator()]
          : [
              // cancel
              TextButton(
                onPressed: con.onCancel,
                child: Text(
                  translate("edit_dialog.cancel"),
                  textAlign: TextAlign.end, // recommended by AlertDialog docs
                  style: TextStyle(color: theme.primaryTextColor),
                ),
              ),

              // save
              TextButton(
                onPressed: con.onSave,
                child: Text(
                  translate("edit_dialog.save"),
                  textAlign: TextAlign.end,
                  style: TextStyle(color: theme.primaryTextColor),
                ),
              ),
            ],
    );
  }
}

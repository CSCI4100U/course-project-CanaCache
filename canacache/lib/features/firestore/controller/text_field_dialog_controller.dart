import "package:canacache/common/utils/mvc.dart";
import "package:canacache/features/firestore/view/user_profile/text_field_dialog.dart";
import "package:flutter/material.dart";

class TextFieldDialogController
    extends Controller<TextFieldDialog, TextFieldDialogState> {
  late final TextEditingController textEditingController;
  final formKey = GlobalKey<FormState>();
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController(text: state.widget.text);
  }

  void onSave() async {
    if (formKey.currentState!.validate()) {
      setState(() => isSaving = true);

      final text = textEditingController.text.trim();
      await state.widget.onSave(text.isNotEmpty ? text : null);

      if (state.mounted) Navigator.of(state.context).pop();
    }
  }

  void onCancel() {
    Navigator.of(state.context).pop();
  }
}

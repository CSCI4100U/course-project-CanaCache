import "package:canacache/features/firestore/view/user_profile/arrow_button.dart";
import "package:canacache/features/settings/model/settings_provider.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

class EditableArrowButton extends StatelessWidget {
  final String titleExisting;
  final String titleNew;
  final String? text;
  final VoidCallback onPressed;

  const EditableArrowButton({
    super.key,
    required this.titleExisting,
    required this.titleNew,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<SettingsProvider>(context).theme;

    return ArrowButton(
      onPressed: onPressed,
      child: Expanded(
        child: text == null
            ? Text(
                titleNew,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: theme.primaryTextColor,
                  fontWeight: FontWeight.bold,
                ),
              )
            : Column(
                children: [
                  // title
                  Container(
                    // because the default underline looks dumb
                    // and flutter has NO BUILT IN WAY to change underline spacing
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: theme.primaryTextColor,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Text(
                      titleExisting,
                      style: TextStyle(
                        color: theme.primaryTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // text
                  Container(
                    padding: const EdgeInsets.only(top: 3, left: 2, right: 2),
                    child: Text(
                      text!,
                      textAlign: TextAlign.justify, // justify looks prettier
                      style: TextStyle(
                        color: theme.primaryTextColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

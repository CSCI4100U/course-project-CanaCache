import "package:canacache/features/firestore/model/storage.dart";
import "package:canacache/features/settings/model/settings_provider.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

class EditableAvatar extends StatelessWidget {
  final UserAvatar avatar;
  final bool isUploadingAvatar;
  final VoidCallback onTap;

  const EditableAvatar({
    super.key,
    required this.isUploadingAvatar,
    required this.avatar,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<SettingsProvider>(context).theme;
    return Container(
      height: 128,
      width: 128,
      decoration: BoxDecoration(
        border: Border.all(color: theme.primaryIconColor, width: 3),
      ),
      child: isUploadingAvatar
          ? Container(
              padding: const EdgeInsets.all(12),
              child: const CircularProgressIndicator(),
            )
          : GestureDetector(
              onTap: onTap,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.memory(avatar.data),
                  Align(
                    alignment: Alignment.topRight,
                    child: Icon(
                      avatar.isDefault ? Icons.add_photo_alternate : Icons.edit,
                      color: theme.primaryIconColor,
                    ),
                  )
                ],
              ),
            ),
    );
  }
}

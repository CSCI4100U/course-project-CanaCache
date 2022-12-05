import "package:canacache/common/utils/mvc.dart";
import "package:canacache/common/utils/routes.dart";
import "package:canacache/common/utils/snackbars.dart";
import "package:canacache/features/auth/model/auth.dart" as auth;
import "package:canacache/features/firestore/model/collections/users.dart";
import "package:canacache/features/firestore/model/documents/user.dart";
import "package:canacache/features/firestore/model/storage.dart";
import "package:canacache/features/firestore/view/user_profile/user_profile_page.dart";
import "package:file_picker/file_picker.dart";
import "package:flutter/material.dart";

class UserProfileFutureData {
  final UserAvatar avatar;
  final CanaUser user;

  const UserProfileFutureData({required this.avatar, required this.user});
}

class UserProfilePageController
    extends Controller<UserProfilePage, UserProfilePageState> {
  Future<UserProfileFutureData>? future;
  bool isUploadingAvatar = false;

  @override
  void initState() {
    super.initState();
    future = fetchData();
  }

  Future<UserProfileFutureData> fetchData() async {
    return UserProfileFutureData(
      avatar: await downloadCurrentUserAvatar(),
      user: await Users().getCurrentUser(),
    );
  }

  // select and upload a new avatar image
  void onTapAvatar() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      allowCompression: true,
      type: FileType.image,
      withData: true,
    );
    if (result == null || !state.mounted) return;

    final platformFile = result.files.first;

    if (platformFile.size > maxAvatarSize) {
      ScaffoldMessenger.of(state.context).showSnackBar(
        errorCanaSnackBar(
          state.context,
          "Selected file is too large (max size: ${maxAvatarSize / (1024 * 1024)}",
        ),
      );
      return;
    }

    setState(() => isUploadingAvatar = true);

    try {
      await challengeSnackBarAsync(
        state.context,
        () => setCurrentUserAvatar(platformFile.bytes!),
      );
    } catch (e) {
      setState(() => isUploadingAvatar = false);
      rethrow;
    }

    future = fetchData();
    await future;

    setState(() {
      isUploadingAvatar = false;
    });
  }

  void onPressedLogout() {
    auth.signOut();
    Navigator.pushNamedAndRemoveUntil(
      state.context,
      CanaRoute.signIn.name,
      (_) => false,
    );
  }
}

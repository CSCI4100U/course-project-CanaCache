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
import "package:flutter_translate/flutter_translate.dart";
import "package:image_cropper/image_cropper.dart";

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

  Future<void> refresh() async {
    future = fetchData();
    await future;
    if (state.mounted) setState(() {});
  }

  Future<void> saveUserAndRefresh(CanaUser user) async {
    await user.update();
    await refresh();
  }

  // select and upload a new avatar image
  Future<void> onTapAvatar() async {
    // pick file
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      allowCompression: true,
      type: FileType.image,
      withData: true,
    );
    if (result == null) return;

    // crop image
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: result.files.first.path!,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      cropStyle: CropStyle.rectangle,
      compressFormat: ImageCompressFormat.png,
    );
    final data = await croppedFile?.readAsBytes();
    if (data == null || !state.mounted) return;

    // check file size
    if (data.lengthInBytes > maxAvatarSizeBytes) {
      ScaffoldMessenger.of(state.context).showSnackBar(
        errorCanaSnackBar(
          state.context,
          translate(
            "profile.error.file_size",
            args: {"sizeMB": maxAvatarSizeMB},
          ),
        ),
      );
      return;
    }

    // upload avatar
    setState(() => isUploadingAvatar = true);

    try {
      await challengeSnackBarAsync(
        state.context,
        () => setCurrentUserAvatar(data),
      );
    } catch (e) {
      setState(() => isUploadingAvatar = false);
      rethrow;
    }

    // refresh profile data
    await refresh();

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

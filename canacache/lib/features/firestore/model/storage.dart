import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_storage/firebase_storage.dart";
import "package:flutter/services.dart";

/// The maximum permissible avatar file size in bytes.
const maxAvatarSize = 8 * 1024 * 1024;

// all images

Reference getImages() => FirebaseStorage.instance.ref("images");

// public images

Reference getPublicImages() => getImages().child("public");

Future<Uint8List> downloadDefaultAvatar() async {
  final data = await getPublicImages()
      .child("default_avatar.png")
      .getData(maxAvatarSize);
  return data!;
}

// user images

class UserAvatar {
  final Uint8List data;
  final bool isDefault;

  const UserAvatar({required this.data, required this.isDefault});
}

Reference getUserImages(String id) => getImages().child("users/$id");

Reference getUserAvatar(String id) => getUserImages(id).child("avatar.png");

Future<UserAvatar> downloadUserAvatar(String id) async {
  try {
    final data = await getUserAvatar(id).getData(maxAvatarSize);
    return UserAvatar(data: data!, isDefault: false);
  } on PlatformException catch (e) {
    if (e.code == "firebase_storage" &&
        e.details["code"] == "object-not-found") {
      return UserAvatar(data: await downloadDefaultAvatar(), isDefault: true);
    }

    rethrow;
  }
}

Future<UserAvatar> downloadCurrentUserAvatar() {
  return downloadUserAvatar(FirebaseAuth.instance.currentUser!.uid);
}

Future<void> setCurrentUserAvatar(Uint8List data) async {
  await getUserAvatar(FirebaseAuth.instance.currentUser!.uid).putData(data);
}

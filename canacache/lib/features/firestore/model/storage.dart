import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_storage/firebase_storage.dart";
import "package:flutter/services.dart";

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

Reference getUserImages(String id) => getImages().child("users/$id");

Reference getUserAvatar(String id) => getUserImages(id).child("avatar.png");

Future<Uint8List> downloadUserAvatar(String id) async {
  try {
    final data = await getUserAvatar(id).getData(maxAvatarSize);
    return data!;
  } on PlatformException catch (e) {
    if (e.code == "firebase_storage" &&
        e.details["code"] == "object-not-found") {
      return downloadDefaultAvatar();
    }

    rethrow;
  }
}

Future<Uint8List> downloadCurrentUserAvatar() {
  return downloadUserAvatar(FirebaseAuth.instance.currentUser!.uid);
}

Future<void> setCurrentUserAvatar(String path) async {}

import "package:canacache/common/utils/mvc.dart";
import "package:canacache/features/firestore/model/collections/users.dart";
import "package:canacache/features/firestore/model/documents/user.dart";
import "package:canacache/features/firestore/model/storage.dart";
import "package:canacache/features/firestore/view/user_profile_page.dart";
import "package:flutter/foundation.dart";

class UserProfileFutureData {
  final Uint8List avatar;
  final CanaUser user;

  const UserProfileFutureData({required this.avatar, required this.user});
}

class UserProfilePageController
    extends Controller<UserProfilePage, UserProfilePageState> {
  late final Future<UserProfileFutureData> future;

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
}

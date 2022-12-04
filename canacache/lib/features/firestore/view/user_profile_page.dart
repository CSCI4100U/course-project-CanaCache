import "package:canacache/common/utils/async_builders.dart";
import "package:canacache/common/utils/mvc.dart";
import "package:canacache/features/firestore/controller/user_profile_page_controller.dart";
import "package:flutter/material.dart";

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => UserProfilePageState();
}

class UserProfilePageState
    extends ViewState<UserProfilePage, UserProfilePageController> {
  UserProfilePageState() : super(UserProfilePageController());

  @override
  Widget build(BuildContext context) {
    return CanaFutureBuilder(
      future: con.future,
      builder: (context, data) => Center(child: Image.memory(data.avatar)),
    );
  }
}

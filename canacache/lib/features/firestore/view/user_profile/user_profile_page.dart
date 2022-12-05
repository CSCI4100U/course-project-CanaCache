import "package:canacache/common/utils/async_builders.dart";
import "package:canacache/common/utils/mvc.dart";
import "package:canacache/features/firestore/controller/user_profile_page_controller.dart";
import "package:canacache/features/firestore/view/user_profile/editable_avatar.dart";
import "package:canacache/features/settings/model/settings_provider.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => UserProfilePageState();
}

class UserProfilePageState
    extends ViewState<UserProfilePage, UserProfilePageController>
    with AutomaticKeepAliveClientMixin<UserProfilePage> {
  UserProfilePageState() : super(UserProfilePageController());

  // stop the page from reloading every time we move to a different tab
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final theme = Provider.of<SettingsProvider>(context).theme;
    return CanaFutureBuilder(
      future: con.future,
      builder: (context, data) => SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // avatar
            EditableAvatar(
              isUploadingAvatar: con.isUploadingAvatar,
              avatar: data.avatar,
              onTap: con.onTapAvatar,
            ),
            // log out button
            OutlinedButton.icon(
              icon: Icon(Icons.logout, color: theme.primaryIconColor),
              label: Text(
                "Logout",
                style: TextStyle(color: theme.primaryTextColor),
              ),
              onPressed: con.onPressedLogout,
            )
          ],
        ),
      ),
    );
  }
}

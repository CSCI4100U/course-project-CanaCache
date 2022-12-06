import "package:canacache/common/utils/async_builders.dart";
import "package:canacache/common/utils/mvc.dart";
import "package:canacache/common/utils/routes.dart";
import "package:canacache/features/firestore/controller/user_profile_page_controller.dart";
import "package:canacache/features/firestore/model/documents/user.dart";
import "package:canacache/features/firestore/view/user_profile/editable_arrow_button.dart";
import "package:canacache/features/firestore/view/user_profile/editable_avatar.dart";
import "package:canacache/features/firestore/view/user_profile/text_arrow_button.dart";
import "package:canacache/features/firestore/view/user_profile/text_field_dialog.dart";
import "package:canacache/features/settings/model/settings_provider.dart";
import "package:flutter/material.dart";
import "package:flutter_translate/flutter_translate.dart";
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

  void showDisplayNameDialog(CanaUser user) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => TextFieldDialog(
        title: translate("profile.display_name.editing"),
        text: user.displayName,
        onSave: (text) => con.setDisplayName(user, text),
        multiline: false,
        maxLength: 20, // works well with the size of the creepy hello message
      ),
    );
  }

  void showBioDialog(CanaUser user) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => TextFieldDialog(
        title: translate("profile.bio.editing"),
        text: user.bio,
        onSave: (text) => con.setBio(user, text),
        multiline: true,
        maxLength: 256, // chosen completely arbitrarily
      ),
    );
  }

  void showItemsPage() {
    Navigator.of(context).pushNamed(CanaRoute.profileItems.name);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final theme = Provider.of<SettingsProvider>(context).theme;

    return CanaFutureBuilder(
      future: con.future,
      builder: (context, data) => SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // creepy hello message
            Container(
              padding: const EdgeInsets.only(top: 10, bottom: 22),
              child: Text(
                translate(
                  "profile.hello",
                  args: {"name": data.user.fallbackDisplayName},
                ),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: theme.primaryTextColor,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // avatar
            EditableAvatar(
              isUploadingAvatar: con.isUploadingAvatar,
              avatar: data.avatar,
              onTap: con.onTapAvatar,
            ),
            const SizedBox(height: 32),

            // profile buttons
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // display name
                  EditableArrowButton(
                    titleExisting: translate("profile.display_name.title"),
                    titleNew: translate("profile.display_name.new"),
                    text: data.user.displayName,
                    onPressed: () => showDisplayNameDialog(data.user),
                  ),
                  const SizedBox(height: 10),

                  // bio
                  EditableArrowButton(
                    titleExisting: translate("profile.bio.title"),
                    titleNew: translate("profile.bio.new"),
                    text: data.user.bio,
                    onPressed: () => showBioDialog(data.user),
                  ),
                  const SizedBox(height: 32),

                  // items
                  TextArrowButton(
                    label: translate("profile.items_button"),
                    onPressed: showItemsPage,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // logout button
            OutlinedButton.icon(
              style: const ButtonStyle(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              icon: Icon(Icons.logout, color: theme.primaryIconColor),
              label: Text(
                translate("settings.logout"),
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

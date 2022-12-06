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
import "package:form_validator/form_validator.dart";
import "package:provider/provider.dart";

const sectionSpacing = SizedBox(height: 30);
const adjacentButtonSpacing = SizedBox(height: 10);

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
        onSave: (displayName) {
          user.displayName = displayName;
          return con.saveUserAndRefresh(user);
        },
        multiline: false,
        maxLength: 20, // works well with the size of the creepy hello message
      ),
    );
  }

  void showPronounsDialog(CanaUser user) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => TextFieldDialog(
        title: translate("profile.pronouns.editing"),
        text: user.pronouns,
        onSave: (pronouns) {
          user.pronouns = pronouns;
          return con.saveUserAndRefresh(user);
        },
        multiline: false,
        maxLength: 20, // idk
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
        onSave: (bio) {
          user.bio = bio;
          return con.saveUserAndRefresh(user);
        },
        multiline: true,
        maxLength: 256, // chosen completely arbitrarily
      ),
    );
  }

  void showWebsiteDialog(CanaUser user) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final localeName = Provider.of<SettingsProvider>(context)
            .language
            .formValidatorLocaleName;
        return TextFieldDialog(
          title: translate("profile.website.editing"),
          text: user.website,
          onSave: (website) {
            user.website = website;
            return con.saveUserAndRefresh(user);
          },
          multiline: false,
          maxLength: 256, // this basically what github uses
          validator: ValidationBuilder(
            localeName: localeName,
            optional: true,
          ).url().build(),
        );
      },
    );
  }

  void showItemsPage() {
    Navigator.of(context).pushNamed(CanaRoute.profileItems.name);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return CanaFutureBuilder(
      future: con.future,
      builder: (context, data) {
        final theme = Provider.of<SettingsProvider>(context).theme;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // creepy hello message
              const SizedBox(height: 10),
              Text(
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
              const SizedBox(height: 22),

              // avatar
              EditableAvatar(
                isUploadingAvatar: con.isUploadingAvatar,
                avatar: data.avatar,
                onTap: con.onTapAvatar,
              ),
              sectionSpacing,

              // profile buttons
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // items
                    TextArrowButton(
                      label: translate("profile.items_button"),
                      onPressed: showItemsPage,
                    ),
                    sectionSpacing,

                    // display name
                    EditableArrowButton(
                      titleExisting: translate("profile.display_name.title"),
                      titleNew: translate("profile.display_name.new"),
                      text: data.user.displayName,
                      onPressed: () => showDisplayNameDialog(data.user),
                    ),
                    adjacentButtonSpacing,

                    // pronouns
                    EditableArrowButton(
                      titleExisting: translate("profile.pronouns.title"),
                      titleNew: translate("profile.pronouns.new"),
                      text: data.user.pronouns,
                      onPressed: () => showPronounsDialog(data.user),
                    ),
                    adjacentButtonSpacing,

                    // bio
                    EditableArrowButton(
                      titleExisting: translate("profile.bio.title"),
                      titleNew: translate("profile.bio.new"),
                      text: data.user.bio,
                      onPressed: () => showBioDialog(data.user),
                    ),
                    adjacentButtonSpacing,

                    // website
                    EditableArrowButton(
                      titleExisting: translate("profile.website.title"),
                      titleNew: translate("profile.website.new"),
                      text: data.user.website,
                      onPressed: () => showWebsiteDialog(data.user),
                    ),
                    sectionSpacing,
                  ],
                ),
              ),

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
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}

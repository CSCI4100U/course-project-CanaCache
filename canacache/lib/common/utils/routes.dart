import "package:canacache/features/auth/view/sign_in.dart";
import "package:canacache/features/firestore/view/modify_cache/modify_cache_page.dart";
import "package:canacache/features/firestore/view/user_profile/user_items_list_page.dart";
import "package:canacache/features/navigation/view/navigation.dart";
import "package:canacache/features/settings/view/settings_view.dart";
import "package:canacache/features/stats/view/stat_distance_view.dart";
import "package:canacache/features/stats/view/stat_time_view.dart";
import "package:canacache/features/stats/view/stats_steps_view.dart";
import "package:flutter/material.dart";

class NoArgumentsError extends Error {}

/// Main named routes for the app.
///
/// Usage: `Navigator.pushNamed(context, CanaRoute.home.name);`
enum CanaRoute {
  home,
  modifyCache,
  profileItems,
  statsSteps,
  statsTime,
  statsDistance,
  settings,
  signIn;

  // needed because enhanced enum values need to be const, ie. not functions
  // still gives type safety - if we forget a route here, it'll give an error
  Widget Function(BuildContext context) get builder {
    switch (this) {
      case home:
        return (context) => NavigationPage();
      case modifyCache:
        return (context) {
          try {
            return ModifyCache(
              args: ModalRoute.of(context)?.settings.arguments
                  as ModifyCacheArguments,
            );
          } catch (e) {
            throw NoArgumentsError();
          }
        };
      case profileItems:
        return (context) => const UserItemsListPage();
      case settings:
        return (context) => const SettingsPageView();
      case signIn:
        return (context) => const SignInForm();
      case statsSteps:
        return (context) => const StepStatView();
      case statsTime:
        return (context) => const TimeStatView();
      case statsDistance:
        return (context) => const DistanceStatView();
    }
  }

  static final Map<String, Widget Function(BuildContext context)> routes = {
    for (var r in CanaRoute.values) r.name: r.builder
  };
}

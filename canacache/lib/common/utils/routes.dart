import "package:canacache/features/auth/view/sign_in.dart";
import "package:canacache/features/favourites/view/favourites_view.dart";
import "package:canacache/features/firestore/view/cache_list_page.dart";
import "package:canacache/features/homepage/view/homepage.dart";
import "package:canacache/features/settings/view/settings_view.dart";
import "package:canacache/features/stats/view/stats_nav_view.dart";
import "package:canacache/features/stats/view/stats_steps_view.dart";
import "package:flutter/material.dart";

/// Main named routes for the app.
///
/// Usage: `Navigator.pushNamed(context, CanaRoute.home.name);`
enum CanaRoute {
  home,
  caches,
  stats,
  statsSteps,
  settings,
  signIn,
  favourites,
  logout;

  // needed because enhanced enum values need to be const, ie. not functions
  // still gives type safety - if we forget a route here, it'll give an error
  Widget Function(BuildContext context) get builder {
    switch (this) {
      case home:
        return (context) => const HomePage();
      case caches:
        return (context) => const CacheListPage();
      case stats:
        return (context) => const StatHomeView();
      case statsSteps:
        return (context) => const StepStatView();
      case settings:
        return (context) => const SettingsPageView();
      case signIn:
        return (context) => const SignInForm();
      case logout:
        return (context) => const SignInForm();
      case favourites:
        return (context) => const FavouritesView();
    }
  }

  static final Map<String, Widget Function(BuildContext context)> routes = {
    for (var r in CanaRoute.values) r.name: r.builder
  };
}

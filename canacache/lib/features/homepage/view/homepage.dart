import "dart:math";

import "package:canacache/common/utils/cana_palette_model.dart";
import "package:canacache/common/utils/extensions.dart";
import "package:canacache/common/utils/mvc.dart";
import "package:canacache/common/utils/routes.dart";
import "package:canacache/common/widgets/picker.dart";
import "package:canacache/features/firestore/model/collections/users.dart";
import "package:canacache/features/firestore/model/documents/cache.dart";
import "package:canacache/features/firestore/view/modify_cache/modify_cache_page.dart";
import "package:canacache/features/homepage/controller/homepage_controller.dart";
import "package:canacache/features/settings/model/i18n.dart";
import "package:canacache/features/settings/model/settings_provider.dart";
import "package:flutter/material.dart";
import "package:flutter_map/flutter_map.dart";
import "package:flutter_translate/flutter_translate.dart";
import "package:geocoding/geocoding.dart";
import "package:intl/intl.dart";
import "package:latlong2/latlong.dart";
import "package:provider/provider.dart";

class HomePage extends StatefulWidget {
  final String? title;

  const HomePage({Key? key, this.title}) : super(key: key);

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends ViewState<HomePage, HomePageController> {
  HomePageState() : super(HomePageController());

  Future<void> showCache(BuildContext context, Cache cache) async {
    final AppLocale locale =
        Provider.of<SettingsProvider>(context, listen: false).language;

    CanaTheme selectedTheme =
        Provider.of<SettingsProvider>(context, listen: false).theme;
    TextStyle style =
        TextStyle(color: selectedTheme.primaryTextColor, fontSize: 14);

    DateTime dateObj =
        DateTime.fromMillisecondsSinceEpoch(1000 * cache.createdAt.seconds);
    String createDate = DateFormat.yMMMEd(locale.languageCode).format(dateObj);

    dateObj =
        DateTime.fromMillisecondsSinceEpoch(1000 * cache.updatedAt.seconds);
    String modDate = DateFormat.yMMMEd(locale.languageCode).format(dateObj);

    double distance = const Distance().as(
      LengthUnit.Kilometer,
      con.currentPos,
      LatLng(cache.position.latitude, cache.position.longitude),
    );

    String translatedName =
        translate("cache.info.name", args: {"cache_name": cache.name});

    List<Widget> cacheInfo = [
      Text(
        translatedName,
        style: style,
      ),
      Text(
        "${translate("cache.info.created")}: $createDate ",
        style: style,
      ),
      Text("${translate("cache.info.modified")}: $modDate", style: style),
      Text(
        "${translate("cache.info.latlng")}: ${cache.position.toLatLng()}",
        style: style,
      ),
      Text(
        "${translate("cache.info.distance")}: $distance",
        style: style,
      ),
    ];

    final List<Placemark> placeMarks = await placemarkFromCoordinates(
      cache.position.latitude,
      cache.position.longitude,
    );
    if (placeMarks.isNotEmpty) {
      Placemark place = placeMarks[0];
      String address = translate("cache.info.address");
      cacheInfo.add(
        Text(
          "$address: ${place.subThoroughfare} ${place.thoroughfare}",
          style: style,
        ),
      );
    }

    List<Widget> actions = [
      // TextButton(
      //   onPressed: () {},
      //   child: Text(
      //     translate("cache.info.show_items_button").toUpperCase(),
      //     style: TextStyle(
      //       color: selectedTheme.primaryTextColor,
      //     ),
      //   ),
      // )
    ];

    await Users().getCurrentUser().then((user) {
      if (con.isCacheCreator(cache, user)) {
        actions.addAll([
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed(
                CanaRoute.modifyCache.name,
                arguments: ModifyCacheArguments(cache: cache),
              );
            },
            child: Text(
              translate("cache.info.edit_button").toUpperCase(),
              style: TextStyle(
                color: selectedTheme.primaryTextColor,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                con.caches.remove(cache);
                cache.delete();
              });
              Navigator.pop(context);
            },
            child: Text(
              translate("cache.info.delete_button").toUpperCase(),
              style: TextStyle(
                color: selectedTheme.primaryTextColor,
              ),
            ),
          ),
        ]);
      }
    });

    if (!mounted) {
      return;
    }

    canaShowDialog(
      context,
      Padding(
        padding: const EdgeInsets.only(bottom: 30, top: 30),
        child: Column(
          children: cacheInfo,
        ),
      ),
      translate("cache.info.title"),
      actions: actions,
    );
  }

  List<Marker> generateMarkers(BuildContext context) {
    CanaTheme selectedTheme = Provider.of<SettingsProvider>(context).theme;
    List<Marker> markers = [];
    for (Cache cache in con.caches) {
      markers.add(
        Marker(
          height: 100,
          width: 100,
          point: LatLng(cache.position.latitude, cache.position.longitude),
          builder: (context) => IconButton(
            icon: Icon(
              size: 20 * (log(con.mapOptions.maxZoom! - con.currentZoomLevel)),
              Icons.location_pin,
              color: selectedTheme.secIconColor,
            ),
            onPressed: () => showCache(context, cache),
          ),
        ),
      );
    }
    return markers;
  }

  void displayCreateCacheDialog(
    String address,
    LatLng coordinates,
  ) {
    CanaTheme selectedTheme =
        Provider.of<SettingsProvider>(context, listen: false).theme;

    return canaShowDialog(
      context,
      Text(
        translate(
          "cache.edit.alert.content",
          args: {
            "location": "${coordinates.latitude}, ${coordinates.longitude}",
          },
        ),
        style: TextStyle(
          color: selectedTheme.primaryTextColor,
        ),
      ),
      translate("cache.edit.alert.title"),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pushNamed(
            CanaRoute.modifyCache.name,
            arguments: ModifyCacheArguments(coordinates: coordinates),
          ),
          child: Text(
            translate("yes").toUpperCase(),
            style: TextStyle(
              color: selectedTheme.primaryTextColor,
            ),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            translate("no").toUpperCase(),
            style: TextStyle(
              color: selectedTheme.primaryTextColor,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: con.mapOptions,
      mapController: con.mapController,
      layers: [
        con.mapAuth,
        MarkerLayerOptions(
          markers: generateMarkers(context),
        ),
      ],
    );
  }
}

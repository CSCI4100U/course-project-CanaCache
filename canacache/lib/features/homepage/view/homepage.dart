import "dart:math";
import "package:canacache/common/utils/cana_palette_model.dart";
import "package:canacache/common/utils/mvc.dart";
import "package:canacache/common/utils/formatting_extensions.dart";
import "package:canacache/common/widgets/picker.dart";
import "package:canacache/features/firestore/model/documents/cache.dart";
import "package:canacache/features/homepage/controller/homepage_controller.dart";
import "package:canacache/features/settings/model/settings_provider.dart";
import "package:flutter/material.dart";
import "package:flutter_map/flutter_map.dart";
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

  void showCache(BuildContext context, Cache cache) {
    CanaTheme selectedTheme =
        Provider.of<SettingsProvider>(context, listen: false).theme;
    TextStyle style = TextStyle(color: selectedTheme.primaryTextColor);

    DateTime dateObj =
        DateTime.fromMillisecondsSinceEpoch(1000 * cache.createdAt.seconds);
    String createDate = DateFormat("yyyy-MM-dd").format(dateObj);

    dateObj =
        DateTime.fromMillisecondsSinceEpoch(1000 * cache.updatedAt.seconds);
    String modDate = DateFormat("yyyy-MM-dd").format(dateObj);

    double distance = const Distance().as(
      LengthUnit.Kilometer,
      con.currentPos,
      LatLng(cache.position.latitude, cache.position.longitude),
    );

    canaShowDialog(
      context,
      Padding(
        padding: const EdgeInsets.only(bottom: 30, top: 30),
        child: Column(
          children: [
            Text("Cache Name: ${cache.name}", style: style),
            Text("Created Date: $createDate ", style: style),
            Text("Last Modified: $modDate", style: style),
            Text("Coordinates: ${cache.position.toLatLng()}", style: style),
            Text("Distance : $distance", style: style),
          ],
        ),
      ),
      "Cache Info",
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
              Icons.all_inbox,
              color: selectedTheme.secIconColor,
            ),
            onPressed: () => showCache(context, cache),
          ),
        ),
      );
    }
    return markers;
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

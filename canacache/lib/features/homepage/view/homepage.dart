import "package:canacache/common/utils/cana_palette_model.dart";
import "package:canacache/common/utils/mvc.dart";
import "package:canacache/features/firestore/model/documents/cache.dart";
import "package:canacache/features/homepage/controller/homepage_controller.dart";
import "package:canacache/features/settings/model/settings_provider.dart";
import "package:flutter/material.dart";
import "package:flutter_map/flutter_map.dart";
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

  List<Marker> generateMarkers(BuildContext context) {
    CanaTheme selectedTheme = Provider.of<SettingsProvider>(context).theme;
    List<Marker> markers = [];

    for (Cache cache in con.caches) {
      markers.add(
        Marker(
          height: 150,
          width: 150,
          point: LatLng(cache.position.latitude, cache.position.longitude),
          builder: (context) => Icon(
            Icons.all_inbox,
            color: selectedTheme.secIconColor,
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

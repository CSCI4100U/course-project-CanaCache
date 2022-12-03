library map;

import 'package:flutter_map/flutter_map.dart';
import "package:latlong2/latlong.dart";

// Do not touch these
const String _token = "pk.eyJ1IjoibWFwNzMzMSIsImEiOiJjbGFnNmNkYWQxYXlhM29xeXJpY2I0dzVvIn0.YchBb4ONJyhaPMzXanClEQ";
const String _mapID = "https://api.mapbox.com/styles/v1/map7331/clag6jg8a000215rvo3v6xq14/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoibWFwNzMzMSIsImEiOiJjbGFnNmNkYWQxYXlhM29xeXJpY2I0dzVvIn0.YchBb4ONJyhaPMzXanClEQ";

// This is the schools location 43.9458513468863, -78.89679733079522
final _startLocal = LatLng(43.9458513468863, -78.89679733079522);

const double _minZoom = 5;
const double _maxZoom = 18;
const double _zoom = 13;

final MapController _mapController = MapController();
List<Marker> _markers = [];

MapOptions options = MapOptions(
  minZoom:  _minZoom,
  maxZoom: _maxZoom,
  zoom: _zoom,
  center: _startLocal,
  controller: _mapController,
);

TileLayerOptions auth = TileLayerOptions(
  urlTemplate: _mapID,
  additionalOptions: {
    "accessToken": _token,
  },
);

MarkerLayerOptions caches = MarkerLayerOptions(
  markers: _markers,
);

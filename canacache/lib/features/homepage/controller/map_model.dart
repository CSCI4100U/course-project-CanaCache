import "package:latlong2/latlong.dart";

class MapModel {
  static const String token = "pk.eyJ1IjoibWFwNzMzMSIsImEiOiJjbGFnNmNkYWQxYXlhM29xeXJpY2I0dzVvIn0.YchBb4ONJyhaPMzXanClEQ";
  static const String mapID = "https://api.mapbox.com/styles/v1/map7331/clag6jg8a000215rvo3v6xq14/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoibWFwNzMzMSIsImEiOiJjbGFnNmNkYWQxYXlhM29xeXJpY2I0dzVvIn0.YchBb4ONJyhaPMzXanClEQ";

  // This is the schools location 43.9458513468863, -78.89679733079522
  static final startLocal = LatLng(43.9458513468863, -78.89679733079522);

  static const double minZoom = 5;
  static const double maxZoom = 18;
  static const double zoom = 13 ;
}
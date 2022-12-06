import "dart:async";
import "package:canacache/common/utils/mvc.dart";
import "package:canacache/features/firestore/model/documents/cache.dart";
import "package:canacache/features/homepage/model/map_model.dart";
import "package:canacache/features/homepage/view/homepage.dart";
import "package:flutter_map/flutter_map.dart";
import "package:geolocator/geolocator.dart";
import "package:latlong2/latlong.dart";

class HomePageController extends Controller<HomePage, HomePageState> {
  final HomePageMapModel _mapModel = HomePageMapModel();
  // part of location code uses https://pub.dev/packages/geolocator
  // as starting point
  StreamSubscription<Position>? positionStream;

  void onPositionUpdate(Position? position) {
    if (position == null) {
      return;
    }
    _mapModel.currentPos = LatLng(position.latitude, position.longitude);

    if (_mapModel.firstLocation) {
      _mapModel.mapController.move(_mapModel.currentPos!, 10);
      _mapModel.firstLocation = false;
    }

    _mapModel.getNearbyCaches().then(
      ((List<Cache> caches) {
        setState(() {
          _mapModel.caches = caches;
        });
      }),
    );
  }

  @override
  void initState() {
    super.initState();

    positionStream = Geolocator.getPositionStream(
      locationSettings: _mapModel.locationSettings,
    ).listen(onPositionUpdate);
  }

  @override
  void dispose() {
    if (positionStream != null) {
      positionStream!.cancel();
    }

    super.dispose();
  }

  MapOptions get mapOptions => _mapModel.options!;
  TileLayerOptions get mapAuth => _mapModel.auth!;
  MapController get mapController => _mapModel.mapController!;
  List<Cache> get caches => _mapModel.caches!;
}

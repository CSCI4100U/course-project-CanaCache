import "dart:async";
import "package:canacache/common/utils/mvc.dart";
import "package:canacache/features/firestore/model/documents/cache.dart";
import "package:canacache/features/homepage/model/map_model.dart";
import "package:canacache/features/homepage/view/homepage.dart";
import "package:canacache/features/stats_recording/distance_recorder.dart";
import "package:flutter_map/flutter_map.dart";
import "package:geolocator/geolocator.dart";
import "package:latlong2/latlong.dart";

class HomePageController extends Controller<HomePage, HomePageState> {
  final HomePageMapModel _mapModel = HomePageMapModel();
  // part of location code uses https://pub.dev/packages/geolocator
  // as starting point
  StreamSubscription<Position>? positionStream;
  StreamSubscription<MapEvent>? mapEventStream;

  HomePageController() {
    try {
      DistanceRecorder().determinePosition().then((Position pos) {
        onPositionUpdate(pos);
      });
    } on LocationPermException catch (_) {
      return;
    }
  }

  void mapEventListener(MapEvent event) {
    if (event.zoom != _mapModel.currentZoomLevel && state.mounted) {
      setState(
        () {
          _mapModel.currentZoomLevel = event.zoom;
        },
      );
    }

    if (event.source == MapEventSource.longPress) {
      // put popup or redirect to new page to add a cache
    }
  }

  void onPositionUpdate(Position? position) {
    if (position == null) {
      return;
    }
    _mapModel.currentPos = LatLng(position.latitude, position.longitude);

    if (_mapModel.firstLocation) {
      _mapModel.mapController.move(_mapModel.currentPos, 12);
      _mapModel.firstLocation = false;
    }

    _mapModel.getNearbyCaches().then(
      ((List<Cache> caches) {
        if (positionStream != null &&
            !positionStream!.isPaused &&
            state.mounted) {
          setState(() {
            _mapModel.caches = caches;
          });
        }
      }),
    );
  }

  @override
  void initState() {
    super.initState();

    positionStream = Geolocator.getPositionStream(
      locationSettings: _mapModel.locationSettings,
    ).listen(onPositionUpdate);
    mapEventStream = mapController.mapEventStream.listen(mapEventListener);
  }

  @override
  void dispose() {
    if (positionStream != null) {
      positionStream!.cancel();
    }

    if (mapEventStream != null) {
      mapEventStream!.cancel();
    }

    super.dispose();
  }

  MapOptions get mapOptions => _mapModel.options;
  TileLayerOptions get mapAuth => _mapModel.auth!;
  MapController get mapController => _mapModel.mapController;
  List<Cache> get caches => _mapModel.caches;
  double get currentZoomLevel => _mapModel.currentZoomLevel;
  LatLng get currentPos => _mapModel.currentPos;
}

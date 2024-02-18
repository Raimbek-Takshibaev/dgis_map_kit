import 'dart:async';

import 'package:dgis_map_platform_interface/dgis_map_platform_interface.dart';
import 'package:dgis_map_platform_interface/src/models/polyline.dart';
import 'package:flutter/material.dart';

typedef OnMapViewCreated = void Function();
typedef MapEventCallback<T extends MapEvent> = void Function(T event);

/// Platform-specific interface
abstract class DGisMapPlatform {
  /// Base map configuration
  final MapConfig mapConfig;

  /// Map widget creation options.
  final MapWidgetOptions widgetOptions;

  /// Map existing layers getter.
  List<MapLayer> get layers;

  /// Map [CameraPosition] stream getter.
  Stream<CameraPosition> get cameraPositionStream;

  DGisMapPlatform({
    required this.mapConfig,
    required this.widgetOptions,
  });

  /// Basic [MapEvent] bus
  StreamSubscription<T> on<T extends MapEvent>(MapEventCallback<T> callback);

  /// Create instance of [DGisMapPlatform]
  static DGisMapPlatform createInstance({
    required MapConfig mapConfig,
    required MapWidgetOptions widgetOptions,
  }) {
    return DGisMapMethodChannel(
      mapConfig: mapConfig,
      widgetOptions: widgetOptions,
    );
  }

  /// Add [MapLayer] o map.
  /// [MapLayer] layerId must be unique.
  /// A [MapLayer] with a null [MapLayer.layerId]
  /// will be considered the default.
  /// You cannot create a [MapLayer] with a null
  /// [MapLayer.layerId] if one already exists.
  Future<void> addLayer(MapLayer layer);

  /// Remove [MapLayer] with given [layerId].
  /// An error will occur if the layer with
  /// the specified layerId does not exist.
  /// This command will delete all objects on this [MapLayer].
  Future<void> removeLayerById(String? layerId);

  /// Add list of markers to the map
  /// [Marker] id should be unique or null.
  /// If marker with given id already exists, it will be overwritten.
  Future<void> addMarkers(List<Marker> markers, [String? layerId]);

  /// Add [Marker] to the map
  /// [Marker] id should be unique or null.
  /// If [Marker] with given id already exists,
  /// it will be overwritten.
  Future<void> addMarker(Marker marker, [String? layerId]);

  /// Get all markers.
  Future<List<Marker>> getAllMarkers([String? layerId]);

  /// Get [Marker] by given [markerId].
  /// It will return null if a [Marker] with
  /// the specified ID does not exist.
  Future<Marker?> getMarkerById(String markerId, [String? layerId]);

  /// Remove [Marker] by given [markerId].
  Future<void> removeMarkerById(String markerId, [String? layerId]);

  /// Remove all markers on layer.
  Future<void> removeAllMarkers([String? layerId]);

  /// It will overwrite the [Marker]
  /// with the specified [markerId] with a new one.
  Future<void> updateMarker(String markerId, Marker newMarker, [String? layerId]);

  /// Add list of polylines to the map
  /// [Polyline] id should be unique or null.
  /// If polyline with given id already exists, it will be overwritten.
  Future<void> addPolylines(List<Polyline> polylines, [String? layerId]);

  /// Add [Polyline] to the map
  /// [Polyline] id should be unique or null.
  /// If [Polyline] with given id already exists,
  /// it will be overwritten.
  Future<void> addPolyline(Polyline polyline, [String? layerId]);

  /// Get all polylines.
  Future<List<Polyline>> getAllPolylines([String? layerId]);

  /// Get [Polyline] by given [polylineId].
  /// It will return null if a [Polyline] with
  /// the specified ID does not exist.
  Future<Polyline?> getPolylineById(String polylineId, [String? layerId]);

  /// Remove [Polyline] by given [polylineId].
  Future<void> removePolylineById(String polylineId, [String? layerId]);

  /// Remove all polylines on layer.
  Future<void> removeAllPolylines([String? layerId]);

  /// It will overwrite the [Polyline]
  /// with the specified [polylineId] with a new one.
  Future<void> updatePolyline(String polylineId, Polyline newPolyline, [String? layerId]);

  /// Set [MapTheme] to the map
  Future<void> setTheme(MapTheme theme);

  /// Closes connection with map
  Future<void> close();

  /// Moves the map camera to the specified
  /// [CameraPosition] with a defined [duration] and [animationType].
  Future<void> moveCamera(
    CameraPosition cameraPosition, {
    Duration duration = Duration.zero,
    CameraAnimationType animationType = CameraAnimationType.defaultAnimation,
  });

  /// Build 2Gis Map view
  Widget buildView({OnMapViewCreated? onCreated});
}

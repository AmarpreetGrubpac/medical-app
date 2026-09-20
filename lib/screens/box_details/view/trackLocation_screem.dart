import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:grubpac_driver/core/utils/app_images.dart';
import 'package:grubpac_driver/core/utils/app_string.dart';
import 'package:grubpac_driver/screens/box_details/controller/box_details_controller.dart';

import '../../../common_components/app_text.dart';
import '../../../common_components/sos_button.dart';

class TracklocationScreeen extends StatefulWidget {
  final String? boxId;

  const TracklocationScreeen({super.key, this.boxId});

  @override
  State<TracklocationScreeen> createState() => _TracklocationScreeenState();
}

class _TracklocationScreeenState extends State<TracklocationScreeen> {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  bool _isLoadingLocation = true;
  String? _locationError;
  BitmapDescriptor? _customRadarMarkerIcon;

  // Default initial coordinates (Fallback location)
  static const LatLng _defaultLocation = LatLng(37.7749, -122.4194);

  @override
  void initState() {
    super.initState();
    _loadCustomRadarMarkerIcon();
    _fetchDeviceLocation();
  }

  Future<void> _loadCustomRadarMarkerIcon() async {
    try {
      final icon = await _createCustomRadarMarkerBitmap("LOWERVAILSBURG");
      if (mounted) {
        setState(() {
          _customRadarMarkerIcon = icon;
        });
      }
    } catch (_) {
      // Fallback to default azure marker if bitmap generation fails
    }
  }

  Future<void> _fetchDeviceLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _locationError = "Location services disabled";
          _isLoadingLocation = false;
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _locationError = "Location permission denied";
            _isLoadingLocation = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _locationError = "Location permissions permanently denied";
          _isLoadingLocation = false;
        });
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      setState(() {
        _currentPosition = position;
        _isLoadingLocation = false;
      });

      if (_mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(
            LatLng(position.latitude, position.longitude),
            16.0,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _locationError = e.toString();
        _isLoadingLocation = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BoxDetailsController>(
      init: Get.isRegistered<BoxDetailsController>()
          ? null
          : BoxDetailsController(),
      builder: (controller) {
        final displayName = (controller.boxInfo?.name.isNotEmpty == true
            ? controller.boxInfo!.name
            : (controller.boxInfo?.boxDisplayId.isNotEmpty == true
                ? controller.boxInfo!.boxDisplayId
                : (widget.boxId ??
                    (controller.boxId.isNotEmpty
                        ? controller.boxId
                        : "BOX-1245"))));
        final targetLatLng = _currentPosition != null
            ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
            : _defaultLocation;

        return Scaffold(
          backgroundColor: const Color(0xFF060E0A),
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                // Top Header Bar
                _TrackLocationHeader(title: displayName),

                // Main Content Area (Google Map + Overlay Bottom Panel)
                Expanded(
                  child: Stack(
                    children: [
                      // Google Maps View Layer
                      GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: targetLatLng,
                          zoom: 15.0,
                        ),
                        myLocationEnabled: true,
                        myLocationButtonEnabled: false,
                        zoomControlsEnabled: false,
                        compassEnabled: false,
                        style: _darkMapStyle,
                        onMapCreated: (controller) {
                          _mapController = controller;
                          if (_currentPosition != null) {
                            _mapController!.animateCamera(
                              CameraUpdate.newLatLngZoom(
                                LatLng(
                                  _currentPosition!.latitude,
                                  _currentPosition!.longitude,
                                ),
                                16.0,
                              ),
                            );
                          }
                        },
                        markers: {
                          Marker(
                            markerId: const MarkerId('current_device_marker'),
                            position: targetLatLng,
                            anchor: const Offset(0.5, 0.4),
                            infoWindow: InfoWindow(
                              title: displayName,
                              snippet: _currentPosition != null
                                  ? "Current Device Location"
                                  : "Default Location",
                            ),
                            icon: _customRadarMarkerIcon ??
                                BitmapDescriptor.defaultMarkerWithHue(
                                  BitmapDescriptor.hueAzure,
                                ),
                          ),
                        },
                      ),

                      // Location Loading / Error Indicator Banner
                      if (_isLoadingLocation || _locationError != null)
                        Positioned(
                          top: 16.h,
                          left: 16.w,
                          right: 16.w,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 10.h,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xDD0A140F),
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: const Color(0xFF3B54FF),
                              ),
                            ),
                            child: Row(
                              children: [
                                if (_isLoadingLocation) ...[
                                  SizedBox(
                                    width: 16.w,
                                    height: 16.h,
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Color(0xFF3B54FF),
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  const Expanded(
                                    child: Text(
                                      "Fetching current device location...",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ] else if (_locationError != null) ...[
                                  const Icon(
                                    Icons.warning_amber_rounded,
                                    color: Colors.amber,
                                    size: 20,
                                  ),
                                  SizedBox(width: 10.w),
                                  Expanded(
                                    child: Text(
                                      _locationError!,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),

                      // Bottom Tracking Control Panel
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: _TrackingBottomPanel(
                          onRecenterLocation: () {
                            if (_currentPosition != null &&
                                _mapController != null) {
                              _mapController!.animateCamera(
                                CameraUpdate.newLatLngZoom(
                                  LatLng(
                                    _currentPosition!.latitude,
                                    _currentPosition!.longitude,
                                  ),
                                  16.0,
                                ),
                              );
                            } else {
                              _fetchDeviceLocation();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Helper function to dynamically generate a custom radar pulse marker BitmapDescriptor
Future<BitmapDescriptor> _createCustomRadarMarkerBitmap(String locality) async {
  final pictureRecorder = ui.PictureRecorder();
  final canvas = Canvas(pictureRecorder);

  const double width = 160.0;
  const double height = 180.0;
  const center = Offset(width / 2, width / 2 - 10);

  // Outer Ripple 1
  final paint1 = Paint()
    ..color = const Color(0xFF3B54FF).withValues(alpha: 0.15)
    ..style = PaintingStyle.fill;
  canvas.drawCircle(center, 70.0, paint1);

  // Middle Ripple 2
  final paint2 = Paint()
    ..color = const Color(0xFF3B54FF).withValues(alpha: 0.35)
    ..style = PaintingStyle.fill;
  canvas.drawCircle(center, 48.0, paint2);

  // Inner Solid Circle
  final paint3 = Paint()
    ..color = const Color(0xFF3B54FF)
    ..style = PaintingStyle.fill;
  canvas.drawCircle(center, 26.0, paint3);

  // Glow Shadow Circle
  final paintGlow = Paint()
    ..color = const Color(0x993B54FF)
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
  canvas.drawCircle(center, 26.0, paintGlow);

  // Locality Text Label under radar
  final textPainter = TextPainter(
    text: TextSpan(
      text: locality,
      style: const TextStyle(
        color: Colors.white70,
        fontSize: 14,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.1,
      ),
    ),
    textDirection: TextDirection.ltr,
  );
  textPainter.layout();
  textPainter.paint(
    canvas,
    Offset(width / 2 - textPainter.width / 2, height - 25),
  );

  final picture = pictureRecorder.endRecording();
  final img = await picture.toImage(width.toInt(), height.toInt());
  final ByteData? byteData = await img.toByteData(
    format: ui.ImageByteFormat.png,
  );
  final Uint8List uint8List = byteData!.buffer.asUint8List();

  return BitmapDescriptor.bytes(uint8List);
}

/// Header Bar with Back Button and Box ID Title
class _TrackLocationHeader extends StatelessWidget {
  final String title;

  const _TrackLocationHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      color: const Color(0xFF060E0A),
      child: Row(
        children: [
          InkWell(
            onTap: () => Get.back(),
            borderRadius: BorderRadius.circular(24.r),
            child: Padding(
              padding: EdgeInsets.all(8.r),
              child: SvgPicture.asset(
                IconAsset.backArrow,
                height: 20.h,
                width: 20.w,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          AppText(
            text: title,
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}

/// Bottom Panel displaying Live Tracking status, SOS Floating Button, and Action Buttons
class _TrackingBottomPanel extends StatelessWidget {
  final VoidCallback onRecenterLocation;

  const _TrackingBottomPanel({required this.onRecenterLocation});

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Main Card Container
        Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(
            20.w,
            24.h,
            20.w,
            20.h + (bottomPadding > 0 ? bottomPadding : 12.h),
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF040A07),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Live Tracking Status Text
              AppText(
                text: AppString.youAreTrackingLive,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              SizedBox(height: 6.h),
              AppText(
                text: AppString.lastUpdatedText,
                fontSize: 14.sp,
                color: Colors.white54,
              ),
              SizedBox(height: 24.h),

              // Action Buttons Row (SHARE & MAPS)
              Row(
                children: [
                  Expanded(
                    child: _ActionButton(
                      title: AppString.shareBtn,
                      iconpath: IconAsset.arrowsRightLeft,
                      onTap: () {
                        // Action for sharing location
                      },
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: _ActionButton(
                      title: AppString.mapsBtn,
                      iconpath: IconAsset.arrowUpRight,
                      onTap: onRecenterLocation,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Floating SOS Button positioned top-right
        Positioned(right: 20.w, top: -24.h, child: const SosButton()),
      ],
    );
  }
}

/// Action Button with Blue background and right-aligned SVG Icon
class _ActionButton extends StatelessWidget {
  final String title;
  final String iconpath;
  final VoidCallback onTap;

  const _ActionButton({
    required this.title,
    required this.iconpath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Ink(
          height: 52.h,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: const Color(0xFF3B54FF),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppText(
                text: title,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              SizedBox(width: 8.w),
              SvgPicture.asset(
                iconpath,
                height: 18.h,
                width: 18.w,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Dark Map Style JSON string
const String _darkMapStyle = '''
[
  {
    "elementType": "geometry",
    "stylers": [
      { "color": "#0f231a" }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      { "color": "#746855" }
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      { "color": "#060e0a" }
    ]
  },
  {
    "featureType": "administrative.locality",
    "elementType": "labels.text.fill",
    "stylers": [
      { "color": "#8f9e97" }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
      { "color": "#4e6057" }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry",
    "stylers": [
      { "color": "#060e0a" }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry.stroke",
    "stylers": [
      { "color": "#1b2d22" }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      { "color": "#122a1f" }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [
      { "color": "#071710" }
    ]
  }
]
''';

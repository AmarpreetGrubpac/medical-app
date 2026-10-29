import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_theme.dart';
import '../../../common_components/sos_button.dart';
import '../../settings_section/box_management/controller/box_repo.dart';
import '../../settings_section/box_management/model/box_info.dart';
import '../controller/box_details_controller.dart';

class TracklocationScreeen extends StatefulWidget {
  final String? boxId;
  const TracklocationScreeen({super.key, this.boxId});
  @override
  State<TracklocationScreeen> createState() => _TracklocationScreeenState();
}

class _TracklocationScreeenState extends State<TracklocationScreeen>
    with WidgetsBindingObserver {
  GoogleMapController? _map;
  Timer? _poll;
  BoxInfo? _box;
  bool _loading = true;
  bool _fetching = false;
  bool _active = true;
  String? _error;
  DateTime? _receivedAt;
  late final String _boxId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    final details = Get.isRegistered<BoxDetailsController>()
        ? Get.find<BoxDetailsController>()
        : null;
    _boxId = widget.boxId ?? details?.boxId ?? '';
    _box = details?.boxInfo?.id == _boxId ? details?.boxInfo : null;
    _refresh();
    _poll = Timer.periodic(const Duration(seconds: 20), (_) => _refresh());
  }

  Future<void> _refresh() async {
    if (_fetching || !_active) return;
    _fetching = true;
    try {
      if (_boxId.isEmpty) throw StateError('No box selected');
      final response = await Get.find<BoxManagementRepo>().getBoxDetail(_boxId);
      if (response.statusCode != 200 ||
          response.body is! Map ||
          response.body['data'] is! Map) {
        throw StateError('Box location could not be refreshed');
      }
      final box = BoxInfo.fromJson(
        Map<String, dynamic>.from(response.body['data']),
      );
      if (!mounted) return;
      setState(() {
        _box = box;
        _receivedAt = DateTime.now();
        _error = null;
      });
      if (box.hasValidLocation) {
        _map?.animateCamera(
          CameraUpdate.newLatLng(LatLng(box.latitude!, box.longitude!)),
        );
      }
    } catch (_) {
      if (mounted) {
        setState(
          () => _error = 'Unable to refresh box location. Previously received data may be stale.',
        );
      }
    } finally {
      _fetching = false;
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _openLocation({required bool share}) async {
    if (_box?.hasValidLocation != true) return;
    final coordinates = '${_box!.latitude},${_box!.longitude}';
    final maps = 'https://www.google.com/maps/search/?api=1&query=$coordinates';
    final title = _box!.name.isNotEmpty ? _box!.name : _box!.boxDisplayId;
    final uri = share
        ? Uri(
            scheme: 'mailto',
            query:
                'subject=${Uri.encodeComponent('Box location: $title')}&body=${Uri.encodeComponent('$title\n$maps\nLast received location; sensor timestamp unavailable.')}',
          )
        : Uri.parse(maps);
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw StateError('No application');
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              share
                  ? 'No email application available to share this location.'
                  : 'Unable to open Maps.',
            ),
          ),
        );
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _active = state == AppLifecycleState.resumed;
    if (_active) _refresh();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _poll?.cancel();
    _map?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final box = _box;
    final valid = box?.hasValidLocation == true;
    final location = valid ? LatLng(box!.latitude!, box.longitude!) : null;
    final title = box?.boxDisplayId.isNotEmpty == true
        ? box!.boxDisplayId
        : _boxId;
    const locationColor = Color(0xFF4B43FF);
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        foregroundColor: AppTheme.contentNeutralPrimary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          tooltip: 'Back',
          onPressed: () => Navigator.of(context).maybePop(),
          icon: Icon(Icons.chevron_left, color: AppTheme.contentNeutralLight),
        ),
        title: Text(
          title,
          maxLines: 1,
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _loading && box == null
                ? const Center(child: CircularProgressIndicator())
                : location == null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        'Box location unavailable. No valid GPS coordinates have been received.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppTheme.contentNeutralPrimary),
                      ),
                    ),
                  )
                : GoogleMap(
                    key: ValueKey(_boxId),
                    initialCameraPosition: CameraPosition(
                      target: location,
                      zoom: 16,
                    ),
                    myLocationEnabled: false,
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: false,
                    mapToolbarEnabled: false,
                    onMapCreated: (map) => _map = map,
                    circles: {
                      Circle(
                        circleId: const CircleId('location-halo'),
                        center: location,
                        radius: 35,
                        fillColor: locationColor.withValues(alpha: .18),
                        strokeColor: locationColor.withValues(alpha: .28),
                        strokeWidth: 1,
                        zIndex: 1,
                      ),
                      Circle(
                        circleId: const CircleId('location-ring'),
                        center: location,
                        radius: 23,
                        fillColor: locationColor.withValues(alpha: .32),
                        strokeWidth: 0,
                        zIndex: 2,
                      ),
                      Circle(
                        circleId: const CircleId('location-dot'),
                        center: location,
                        radius: 12,
                        fillColor: locationColor,
                        strokeWidth: 0,
                        zIndex: 3,
                      ),
                    },
                  ),
          ),
          ColoredBox(
            color: AppTheme.background,
            child: SafeArea(
              top: false,
              minimum: EdgeInsets.only(bottom: 20.h),
              child: Padding(
                padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 16.h),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 60.w),
                          child: Text(
                            valid
                                ? 'You are tracking live'
                                : 'Box location unavailable',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.contentNeutralPrimary,
                            ),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Padding(
                          padding: EdgeInsets.only(right: 60.w),
                          child: Text(
                            _error ??
                                (_receivedAt == null
                                    ? 'Waiting for box data'
                                    : '(Last received: ${TimeOfDay.fromDateTime(_receivedAt!).format(context)})'),
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppTheme.contentNeutralSecondary,
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Row(
                          children: [
                            Expanded(
                              child: _locationButton(
                                label: 'SHARE',
                                icon: Icons.share_outlined,
                                onPressed: valid
                                    ? () => _openLocation(share: true)
                                    : null,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: _locationButton(
                                label: 'MAPS',
                                icon: Icons.north_east,
                                onPressed: valid
                                    ? () => _openLocation(share: false)
                                    : null,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Positioned(right: 0, top: 12.h, child: const SosButton()),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _locationButton({
    required String label,
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: const Color(0xFF4B43FF),
        foregroundColor: Colors.white,
        minimumSize: Size(0, 46.h),
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.r)),
        textStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label),
          SizedBox(width: 8.w),
          Icon(icon, size: 18.sp),
        ],
      ),
    );
  }
}

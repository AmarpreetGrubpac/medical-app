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
      final box =
          BoxInfo.fromJson(Map<String, dynamic>.from(response.body['data']));
      if (!mounted) return;
      setState(() {
        _box = box;
        _receivedAt = DateTime.now();
        _error = null;
      });
      if (box.hasValidLocation) {
        _map?.animateCamera(
            CameraUpdate.newLatLng(LatLng(box.latitude!, box.longitude!)));
      }
    } catch (_) {
      if (mounted) {
        setState(() => _error =
            'Unable to refresh box location. Previously received data may be stale.');
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
                'subject=${Uri.encodeComponent('Box location: $title')}&body=${Uri.encodeComponent('$title\n$maps\nLast received location; sensor timestamp unavailable.')}')
        : Uri.parse(maps);
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw StateError('No application');
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(share
                ? 'No email application available to share this location.'
                : 'Unable to open Maps.')));
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
    final title =
        box?.name.isNotEmpty == true ? box!.name : box?.boxDisplayId ?? _boxId;
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
          backgroundColor: AppTheme.background,
          foregroundColor: AppTheme.contentNeutralPrimary,
          title:
              Text(title, maxLines: 2, style: const TextStyle(fontSize: 20))),
      body: Column(children: [
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
                                style: TextStyle(
                                    color: AppTheme.contentNeutralPrimary))))
                    : GoogleMap(
                        key: ValueKey(_boxId),
                        initialCameraPosition:
                            CameraPosition(target: location, zoom: 15),
                        myLocationEnabled: false,
                        myLocationButtonEnabled: false,
                        zoomControlsEnabled: false,
                        onMapCreated: (map) => _map = map,
                        markers: {
                            Marker(
                                markerId: MarkerId(_boxId),
                                position: location,
                                infoWindow: InfoWindow(
                                    title: title,
                                    snippet: 'Last received box location'))
                          })),
        Container(
          decoration: BoxDecoration(
              color: AppTheme.background,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withValues(alpha: .08), blurRadius: 12)
              ]),
          padding: EdgeInsets.all(24.w),
          child: SafeArea(
              top: false,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(children: [
                      Expanded(
                          child: Text(
                              valid
                                  ? 'Last received box location'
                                  : 'Box location unavailable',
                              style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.contentNeutralPrimary))),
                      const SosButton()
                    ]),
                    const SizedBox(height: 8),
                    Text(
                        _error ??
                            (_receivedAt == null
                                ? 'Waiting for box data'
                                : 'Received at ${TimeOfDay.fromDateTime(_receivedAt!).format(context)}. Sensor timestamp unavailable.'),
                        style:
                            TextStyle(color: AppTheme.contentNeutralSecondary)),
                    const SizedBox(height: 16),
                    Row(children: [
                      Expanded(
                          child: FilledButton(
                              onPressed: valid
                                  ? () => _openLocation(share: true)
                                  : null,
                              child: const Text('SHARE'))),
                      const SizedBox(width: 16),
                      Expanded(
                          child: FilledButton(
                              onPressed: valid
                                  ? () => _openLocation(share: false)
                                  : null,
                              child: const Text('MAPS'))),
                      IconButton(
                          tooltip: 'Refresh box location',
                          onPressed: _fetching ? null : _refresh,
                          icon: const Icon(Icons.refresh)),
                    ]),
                  ])),
        ),
      ]),
    );
  }
}

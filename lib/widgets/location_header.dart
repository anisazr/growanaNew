// lib/widgets/location_header.dart
import 'package:flutter/material.dart';
import '../services/location_service.dart';

class LocationHeader extends StatefulWidget {
  final bool showIcon;
  final TextStyle? textStyle;

  const LocationHeader({
    super.key,
    this.showIcon = true,
    this.textStyle,
  });

  @override
  State<LocationHeader> createState() => _LocationHeaderState();
}

class _LocationHeaderState extends State<LocationHeader> {
  String _locationText = 'Mendapatkan lokasi...';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      final position = await LocationService.getCurrentLocation();
      final address = await LocationService.getAddressFromCoordinates(
        position.latitude,
        position.longitude,
      );
      
      setState(() {
        _locationText = address;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _locationText = 'Lokasi tidak tersedia';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _getCurrentLocation,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.showIcon)
            Icon(
              Icons.location_on,
              size: 16,
              color: Theme.of(context).primaryColor,
            ),
          const SizedBox(width: 4),
          _isLoading
              ? SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Theme.of(context).primaryColor,
                  ),
                )
              : Flexible(
                  child: Text(
                    _locationText,
                    style: widget.textStyle ??
                        TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).primaryColor,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
        ],
      ),
    );
  }
}
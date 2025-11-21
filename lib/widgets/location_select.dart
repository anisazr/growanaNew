import 'package:flutter/material.dart';

class LocationSelect extends StatefulWidget {
  final List<String> locations;
  final String? initialLocation;
  final ValueChanged<String>? onChanged;

  const LocationSelect({
    Key? key,
    required this.locations,
    this.initialLocation,
    this.onChanged,
  }) : super(key: key);

  @override
  _LocationSelectState createState() => _LocationSelectState();
}

class _LocationSelectState extends State<LocationSelect> {
  late String selectedLocation;

  @override
  void initState() {
    super.initState();
    selectedLocation = widget.initialLocation ?? widget.locations.first;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedLocation,
      dropdownColor: Colors.green[700],
      underline: const SizedBox(),
      iconEnabledColor: Colors.white,
      style: const TextStyle(color: Colors.white),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            selectedLocation = value;
          });
          widget.onChanged?.call(value);
        }
      },
      items:
          widget.locations
              .map(
                (location) => DropdownMenuItem<String>(
                  value: location,
                  child: Text(location),
                ),
              )
              .toList(),
    );
  }
}

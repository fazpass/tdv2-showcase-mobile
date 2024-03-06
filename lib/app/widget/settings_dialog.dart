
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_trusted_device_v2/flutter_trusted_device_v2.dart';

class SettingsDialog extends StatefulWidget {
  final FazpassSettingsBuilder builder;

  const SettingsDialog({super.key, required this.builder});

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {

  late bool locationEnabled;
  late bool simInformationEnabled;
  late bool vpnEnabled;
  late bool highLevelBiometricEnabled;

  @override
  void initState() {
    super.initState();
    locationEnabled = widget.builder.sensitiveData.contains(SensitiveData.location);
    simInformationEnabled = widget.builder.sensitiveData.contains(SensitiveData.simNumbersAndOperators);
    vpnEnabled = widget.builder.sensitiveData.contains(SensitiveData.vpn);
    highLevelBiometricEnabled = widget.builder.isBiometricLevelHigh;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Settings'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text('Data Collection', style: Theme.of(context).textTheme.titleMedium),
          ),
          CheckboxListTile(
            dense: true,
            title: const Text('Location'),
            value: locationEnabled,
            onChanged: (val) {
              if (val!) {
                widget.builder.enableSelectedSensitiveData([SensitiveData.location]);
              } else {
                widget.builder.disableSelectedSensitiveData([SensitiveData.location]);
              }

              setState(() {
                locationEnabled = val;
              });
            },
          ),
          if (Platform.isAndroid) CheckboxListTile(
            dense: true,
            title: const Text('Sim Information'),
            value: simInformationEnabled,
            onChanged: (val) {
              if (val!) {
                widget.builder.enableSelectedSensitiveData([SensitiveData.simNumbersAndOperators]);
              } else {
                widget.builder.disableSelectedSensitiveData([SensitiveData.simNumbersAndOperators]);
              }

              setState(() {
                simInformationEnabled = val;
              });
            },
          ),
          if (Platform.isIOS) CheckboxListTile(
            dense: true,
            title: const Text('VPN'),
            value: vpnEnabled,
            onChanged: (val) {
              if (val!) {
                widget.builder.enableSelectedSensitiveData([SensitiveData.vpn]);
              } else {
                widget.builder.disableSelectedSensitiveData([SensitiveData.vpn]);
              }

              setState(() {
                vpnEnabled = val;
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text('Other', style: Theme.of(context).textTheme.titleMedium),
          ),
          CheckboxListTile(
            dense: true,
            title: const Text('High Level Biometric'),
            value: highLevelBiometricEnabled,
            onChanged: (val) {
              if (val!) {
                widget.builder.setBiometricLevelToHigh();
              } else {
                widget.builder.setBiometricLevelToLow();
              }

              setState(() {
                highLevelBiometricEnabled = val;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('DISCARD'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, widget.builder.build()),
          child: const Text('SAVE'),
        ),
      ],
    );
  }
}

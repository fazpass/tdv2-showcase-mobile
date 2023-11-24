
import 'package:flutter/material.dart';
import 'package:tdv2_showcase_mobile/app/util/constants.dart';

class LogsDialog extends StatelessWidget {
  const LogsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: const Text('Http Request Logs'),
      content: Column(
        children: [
          for (final item in Constants.logs) ListTile(
            title: Text(item.name),
            subtitle: Text('${(item.status ?? false) ? 'Success' : 'Failed'} in ${item.readableDuration}'),
          ),
        ],
      ),
    );
  }
}
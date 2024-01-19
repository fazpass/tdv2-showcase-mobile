
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
            subtitle: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('${(item.status) ? 'Success' : 'Failed'} in ${item.readableDuration}'),
                const SizedBox(height: 5),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shape: const MaterialStatePropertyAll(RoundedRectangleBorder()),
                          padding: const MaterialStatePropertyAll(EdgeInsets.zero),
                          backgroundColor: MaterialStatePropertyAll(Colors.blue[700]),
                          foregroundColor: const MaterialStatePropertyAll(Colors.white),
                        ),
                        onPressed: () => showDialog(
                          context: context,
                          builder: (c) => AlertDialog(
                            title: const Text('Parameters'),
                            content: Text(item.parameters),
                            scrollable: true,
                          ),
                        ),
                        child: const Text('Parameters'),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shape: const MaterialStatePropertyAll(RoundedRectangleBorder()),
                          padding: const MaterialStatePropertyAll(EdgeInsets.zero),
                          backgroundColor: MaterialStatePropertyAll(Colors.blue[700]),
                          foregroundColor: const MaterialStatePropertyAll(Colors.white),
                        ),
                        onPressed: () => showDialog(
                          context: context,
                          builder: (c) => AlertDialog(
                            title: const Text('Response'),
                            content: Text(item.response),
                            scrollable: true,
                          ),
                        ),
                        child: const Text('Response'),
                      ),
                    ),
                  ],
                ),
                const Divider(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class PrimaryElevatedButton extends StatefulWidget {
  const PrimaryElevatedButton({super.key, required this.onClick, required this.label});

  final String label;
  final Function()? onClick;

  @override
  State<StatefulWidget> createState() => _PrimaryElevatedButtonState();
}

class _PrimaryElevatedButtonState extends State<PrimaryElevatedButton> {

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onClick,
      child: Text(widget.label),
    );
  }
}
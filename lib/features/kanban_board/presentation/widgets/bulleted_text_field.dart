import 'package:flutter/material.dart';

class BulletTextField extends StatefulWidget {
  final void Function(List<String>) onChanged;
  final List<String> initialComments;

  const BulletTextField({
    Key? key,
    required this.onChanged,
    this.initialComments = const [],
  }) : super(key: key);

  @override
  _BulletTextFieldState createState() => _BulletTextFieldState();
}

class _BulletTextFieldState extends State<BulletTextField> {
  late TextEditingController _controller;
  late List<String> _comments;

  @override
  void initState() {
    super.initState();
    _comments = List.from(widget.initialComments);
    _controller = TextEditingController(
      text: _comments.isNotEmpty
          ? _comments.map((comment) => comment).join('\n')
          : '• ',
    );
    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: _controller.text.length),
    );
    _controller.addListener(_updateComments);
  }

  void _updateComments() {
    setState(() {
      _comments = _controller.text
          .split('\n')
          .where((line) => line.trim().isNotEmpty)
          .map((line) => line.trimLeft().startsWith('•')
              ? line.substring(1).trim()
              : line.trim())
          .toList();
      widget.onChanged(_comments);
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        hintText: 'Enter comments',
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2.0,
          ),
        ),
      ),
      maxLines: null,
      onChanged: (value) {
        final cursorPosition = _controller.selection.base.offset;
        final lines = value.split('\n');
        final newLines = <String>[];
        var cursorOffset = 1;

        for (int i = 0; i < lines.length; i++) {
          final line = lines[i].trimLeft();
          if (line.isEmpty && i < lines.length - 1) {
            newLines.add('• ');
            if (cursorPosition > newLines.join('\n').length) {
              cursorOffset += 2;
            }
          } else if (line.startsWith('•')) {
            newLines.add(lines[i]);
          } else if (line.isNotEmpty) {
            newLines.add('• $line');
            if (cursorPosition > newLines.join('\n').length) {
              cursorOffset += 2;
            }
          } else {
            newLines.add(lines[i]);
          }
        }

        final newValue = newLines.join('\n');
        final newCursorPosition = cursorPosition + cursorOffset + 1;

        _controller.value = TextEditingValue(
          text: newValue,
          selection: TextSelection.collapsed(offset: newCursorPosition),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.removeListener(_updateComments);
    _controller.dispose();
    super.dispose();
  }
}

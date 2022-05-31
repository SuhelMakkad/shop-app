import 'package:flutter/material.dart';

class InputWithLabel extends StatefulWidget {
  const InputWithLabel({
    required this.label,
    this.textInputAction = TextInputAction.done,
    this.allowObscureToggle = false,
    this.obscureText = false,
    Key? key,
  }) : super(key: key);

  final String label;
  final TextInputAction textInputAction;
  final bool allowObscureToggle;
  final bool obscureText;

  @override
  State<InputWithLabel> createState() => _InputWithLabelState();
}

class _InputWithLabelState extends State<InputWithLabel> {
  var _obscureText = false;

  @override
  void initState() {
    _obscureText = widget.obscureText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final textTheme = themeData.textTheme;
    final titleMedium = textTheme.titleMedium;

    return SingleChildScrollView(
      child: Container(
        height: 36,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.08),
          borderRadius: BorderRadius.circular(4),
        ),
        padding: widget.allowObscureToggle
            ? const EdgeInsets.only(left: 16)
            : const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 75,
              child: Text(
                widget.label,
                style: titleMedium?.copyWith(
                  color: Colors.black54,
                ),
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Flexible(
              child: TextField(
                obscureText: _obscureText,
                decoration: null,
                textInputAction: widget.textInputAction,
              ),
            ),
            if (widget.allowObscureToggle)
              IconButton(
                splashRadius: 0.01,
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                icon: _obscureText
                    ? const Icon(Icons.visibility)
                    : const Icon(Icons.visibility_off),
              ),
          ],
        ),
      ),
    );
  }
}

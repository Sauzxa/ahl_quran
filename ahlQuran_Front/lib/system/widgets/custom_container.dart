import 'package:flutter/material.dart';

class CustomContainer extends StatefulWidget {
  final String headerText;
  final IconData headerIcon;
  final Widget child;
  final List<Widget>? headreActions;

  const CustomContainer({
    super.key,
    required this.headerText,
    required this.child,
    required this.headerIcon,
    this.headreActions,
  });

  @override
  State<CustomContainer> createState() => _CustomContainerState();
}

class _CustomContainerState extends State<CustomContainer> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: theme.primaryColor, width: 0.5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: theme.primaryColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5),
                topRight: Radius.circular(5),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    widget.headerIcon,
                    color: theme.colorScheme.onPrimary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.headerText,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  if (widget.headreActions != null) ...widget.headreActions!,
                ],
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: widget.child,
          )
        ],
      ),
    );
  }
}

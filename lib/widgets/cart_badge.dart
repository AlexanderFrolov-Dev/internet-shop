import 'package:flutter/material.dart';

class CartBadge extends StatelessWidget {
  final Widget child;
  final String value;

  const CartBadge({super.key,
    required this.child,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        Positioned(
          top: 8,
          right: 8,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(10),
            ),
            constraints: const BoxConstraints(
              minWidth: 16,
              minHeight: 16,
            ),
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.white,
              ),
            ),
          ),
        )
      ],
    );
  }
}
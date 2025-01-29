import 'package:flutter/material.dart';


class CommonHeading extends StatelessWidget {
  final String title;

  const CommonHeading({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.w500),
          children: <TextSpan>[
            TextSpan(text: title),

          ],
        ),
      ),
    );
  }
}

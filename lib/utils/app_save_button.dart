
import 'package:flutter/material.dart';
import 'package:task_management_app/utils/extensions.dart';


class AppSaveButton extends StatelessWidget {
  final Function onTap;
  final String name;
  final GlobalKey<FormState> formKey;

  const AppSaveButton({
    super.key,
    required this.formKey,
    required this.onTap,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        height: context.height(context) * 0.07,
        width:  double.infinity,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            name,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white,fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}


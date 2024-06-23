import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:task_flow/core/extensions/text_style_extensions.dart';
import 'package:task_flow/core/l10n/localization_constants.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            LocalizationConstants.taskFlow,
            style: context.headlineLarge,
          ).tr(),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Welcome to the Home Page',
                style: context.bodyLarge,
              ),
            ],
          ),
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:task_flow/core/constants/app_spacing.dart';
import 'package:task_flow/core/extensions/color_scheme_extension.dart';
import 'package:task_flow/core/extensions/text_style_extensions.dart';
import 'package:task_flow/core/l10n/localization_constants.dart';

class ErrorShowingWidget extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const ErrorShowingWidget({
    super.key,
    required this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error,
            size: AppSpacing.iconMediumSizeR,
            color: context.colorScheme.error,
          ),
          SizedBox(height: AppSpacing.sizedBoxMediumH),
          Text(
            errorMessage,
            style: context.titleMedium,
            textAlign: TextAlign.center,
          ).tr(),
          SizedBox(height: AppSpacing.sizedBoxSmallH),
          Text(
            LocalizationConstants.tryAgainLater,
            style: context.bodyMedium?.copyWith(
              color: context.colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ).tr(),
          SizedBox(height: AppSpacing.sizedBoxLargeH),
          ElevatedButton(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.paddingMediumW,
                vertical: AppSpacing.paddingSmallH,
              ),
            ),
            child: const Text(LocalizationConstants.tryAgain).tr(),
          ),
        ],
      ),
    );
  }
}

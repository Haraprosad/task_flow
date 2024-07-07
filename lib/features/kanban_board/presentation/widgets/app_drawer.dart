import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_flow/core/constants/asset_constants.dart';
import 'package:task_flow/core/constants/string_constants.dart';
import 'package:task_flow/core/l10n/app_localizations.dart';
import 'package:task_flow/core/l10n/localization_constants.dart';
import 'package:task_flow/core/theme/app_theme.dart';
import 'package:task_flow/core/theme/theme_cubit.dart';


class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Column(
              children: [
                Image.asset(AssetConstants.logo, height: 100),
              ],
            ),
          ),
          ListTile(
            title: Text(LocalizationConstants.home).tr(),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ExpansionTile(
            title: Text(LocalizationConstants.theme).tr(),
            children: _buildThemeListTiles(context),
          ),
          ExpansionTile(
            title: Text(LocalizationConstants.language).tr(),
            children: _buildLanguageListTiles(context),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildThemeListTiles(BuildContext context) {
    return [
      _buildThemeTile(context, LocalizationConstants.lightBlue, Colors.lightBlue, AppTheme.lightBlue),
      _buildThemeTile(context, LocalizationConstants.darkBlue, Colors.blue, AppTheme.darkBlue),
      _buildThemeTile(context, LocalizationConstants.lightGreen, Colors.lightGreen, AppTheme.lightGreen),
      _buildThemeTile(context, LocalizationConstants.darkGreen, Colors.green, AppTheme.darkGreen),
      _buildThemeTile(context, LocalizationConstants.purple, Colors.purple, AppTheme.purple),
    ];
  }

  ListTile _buildThemeTile(BuildContext context, String title, Color color, AppTheme theme) {
    return ListTile(
      title: Row(
        children: [
          CircleAvatar(backgroundColor: color, radius: 8),
          SizedBox(width: 8),
          Text(title).tr(),
        ],
      ),
      onTap: () {
        context.read<ThemeCubit>().setTheme(theme);
      },
    );
  }

  List<Widget> _buildLanguageListTiles(BuildContext context) {
    return [
      _buildLanguageTile(context, StringConstants.english, AppLocalizations.englishLocale),
      _buildLanguageTile(context, StringConstants.german, AppLocalizations.germanLocale),
      _buildLanguageTile(context, StringConstants.bengali, AppLocalizations.bengaliLocale),
    ];
  }

  ListTile _buildLanguageTile(BuildContext context, String title, Locale locale) {
    return ListTile(
      title: Text(title),
      onTap: () {
        AppLocalizations.changeLocale(context, locale);
      },
    );
  }
}

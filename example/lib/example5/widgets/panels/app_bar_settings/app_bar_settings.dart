import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

import '../../../../shared/const/app_color.dart';
import '../../../../shared/controllers/theme_controller.dart';
import '../../../../shared/widgets/universal/header_card.dart';
import '../../../../shared/widgets/universal/switch_list_tile_adaptive.dart';
import '../../shared/color_scheme_popup_menu.dart';
import 'app_bar_style_buttons.dart';

class AppBarSettings extends StatelessWidget {
  const AppBarSettings(
      {Key? key,
      required this.controller,
      required this.isOpen,
      required this.onTap})
      : super(key: key);
  final ThemeController controller;
  final bool isOpen;
  final VoidCallback onTap;

  String explainAppBarStyle(final FlexAppBarStyle style, final bool isLight) {
    switch (style) {
      case FlexAppBarStyle.primary:
        return isLight ? 'Primary color - M2 default' : 'Primary color';
      case FlexAppBarStyle.material:
        return isLight
            ? 'White background'
            : 'Dark background (#121212) - M2 default';
      case FlexAppBarStyle.surface:
        return 'Surface, with primary color blend';
      case FlexAppBarStyle.background:
        return 'Background, with primary color blend';
      case FlexAppBarStyle.custom:
        return 'Custom, built-in schemes use tertiary color, '
            'but you can use any color';
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isLight = theme.brightness == Brightness.light;

    return HeaderCard(
      isOpen: isOpen,
      onTap: onTap,
      title: const Text('AppBar Settings'),
      child: Column(
        children: <Widget>[
          const SizedBox(height: 8),
          const ListTile(
            subtitle: Text(
              'Material 2 themes favor primary colored AppBar in light '
              'mode, and almost black in dark mode. Here you can select '
              'Primary, Material background or background and surface color, '
              'with their primary blends or even a custom color',
            ),
          ),
          if (isLight) ...<Widget>[
            ListTile(
              title: const Text('Light mode AppBarStyle'),
              subtitle: Text(
                explainAppBarStyle(controller.lightAppBarStyle, isLight),
              ),
            ),
            ListTile(
              trailing: AppBarStyleButtons(
                  style: controller.useFlexColorScheme
                      ? controller.lightAppBarStyle
                      : FlexAppBarStyle.primary,
                  onChanged: controller.useFlexColorScheme
                      ? controller.setLightAppBarStyle
                      : null,
                  // To access the custom color we defined for app bar, in this
                  // toggle buttons widget, we have to pass along, or the
                  // entire controller. Chose the color in this case. It is not
                  // carried with the theme, so we cannot get it from there in
                  // the widget. FlexColorScheme knows the color when
                  // you make a theme with it. This color is used to show the
                  // correct color on the toggle button option for custom color.
                  // In our examples we only actually have a custom app bar
                  // color in the first custom color example, and we want to
                  // show this color as well on the toggle button.
                  customAppBarColor:
                      AppColor.scheme(controller).light.appBarColor),
            ),
          ] else ...<Widget>[
            ListTile(
              title: const Text('Dark mode AppBarStyle'),
              subtitle: Text(
                explainAppBarStyle(controller.darkAppBarStyle, isLight),
              ),
            ),
            ListTile(
              trailing: AppBarStyleButtons(
                  style: controller.useFlexColorScheme
                      ? controller.darkAppBarStyle
                      : FlexAppBarStyle.material,
                  onChanged: controller.useFlexColorScheme
                      ? controller.setDarkAppBarStyle
                      : null,
                  customAppBarColor:
                      AppColor.scheme(controller).dark.appBarColor),
            ),
          ],
          SwitchListTileAdaptive(
            title: const Text('One colored AppBar on Android'),
            subtitle: const Text(
              'ON  No scrim on the top status bar\n'
              'OFF Default two toned status bar',
            ),
            value: controller.transparentStatusBar &&
                controller.useFlexColorScheme,
            onChanged: controller.useFlexColorScheme
                ? controller.setTransparentStatusBar
                : null,
          ),
          ListTile(
            title: const Text('Elevation'),
            subtitle: Slider.adaptive(
              max: 24,
              divisions: 48,
              label: controller.appBarElevation.toStringAsFixed(1),
              value: controller.appBarElevation,
              onChanged: controller.useFlexColorScheme
                  ? controller.setAppBarElevation
                  : null,
            ),
            trailing: Padding(
              padding: const EdgeInsetsDirectional.only(end: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'ELEV',
                    style: Theme.of(context).textTheme.caption,
                  ),
                  Text(
                    controller.appBarElevation.toStringAsFixed(1),
                    style: Theme.of(context)
                        .textTheme
                        .caption!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          const ListTile(
            title: Text('Opacity'),
            subtitle: Text('Themed opacity, try 85% to 98%'),
          ),
          ListTile(
            title: Slider.adaptive(
              max: 100,
              divisions: 100,
              label: (controller.appBarOpacity * 100).toStringAsFixed(0),
              value: controller.appBarOpacity * 100,
              onChanged: controller.useFlexColorScheme
                  ? (double value) {
                      controller.setAppBarOpacity(value / 100);
                    }
                  : null,
            ),
            trailing: Padding(
              padding: const EdgeInsetsDirectional.only(end: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    'OPACITY',
                    style: Theme.of(context).textTheme.caption,
                  ),
                  Text(
                    '${(controller.appBarOpacity * 100).toStringAsFixed(0)}'
                    ' %',
                    style: Theme.of(context)
                        .textTheme
                        .caption!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          const Divider(),
          const ListTile(
            title: Text('Custom color'),
            subtitle: Text('With sub-themes you can set scheme color for the '
                'AppBar background color. '
                'Using AppBarStyle is easier, but this offers more colors. '
                'This overrides used AppBarStyle and passed in color, set it '
                'back to default (null) to use AppBarStyle again. '
                'With API you can set different color in light and dark '
                'mode. This app shares same input for both modes, but you '
                'can easily modify the generated setup code.'),
          ),
          ColorSchemePopupMenu(
            title: const Text('AppBar background color'),
            labelForDefault: 'null (AppBarStyle)',
            index: controller.appBarBackgroundSchemeColor?.index ?? -1,
            onChanged: controller.useSubThemes && controller.useFlexColorScheme
                ? (int index) {
                    if (index < 0 || index >= SchemeColor.values.length) {
                      controller.setAppBarBackgroundSchemeColor(null);
                    } else {
                      controller.setAppBarBackgroundSchemeColor(
                          SchemeColor.values[index]);
                    }
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
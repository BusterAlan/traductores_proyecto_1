// Created with https://material-foundation.github.io/material-theme-builder/

// ignore_for_file: public_member_api_docs, deprecated_member_use

import "package:flutter/material.dart";

class MaterialTheme {
  const MaterialTheme(this.textTheme);
  final TextTheme textTheme;

  static MaterialScheme lightScheme() => const MaterialScheme(
        brightness: Brightness.light,
        primary: Color(0xff3188B5),
        surfaceTint: Color(0xff00658d),
        onPrimary: Color(0xffffffff),
        primaryContainer: Color(0xff1f7ca9),
        onPrimaryContainer: Color(0xffffffff),
        secondary: Color(0xff004f6f),
        onSecondary: Color(0xffffffff),
        secondaryContainer: Color(0xff347497),
        onSecondaryContainer: Color(0xffffffff),
        tertiary: Color(0xff00687b),
        onTertiary: Color(0xffffffff),
        tertiaryContainer: Color(0xff59deff),
        onTertiaryContainer: Color(0xff00424f),
        error: Color(0xffba1a1a),
        onError: Color(0xffffffff),
        errorContainer: Color(0xffffdad6),
        onErrorContainer: Color(0xff410002),
        background: Color(0xfff7f9fd),
        onBackground: Color(0xff181c1f),
        surface: Color(0xfff7f9fd),
        onSurface: Color(0xff181c1f),
        surfaceVariant: Color(0xffdbe3eb),
        onSurfaceVariant: Color(0xff3f484e),
        outline: Color(0xff70787f),
        outlineVariant: Color(0xffbfc8cf),
        shadow: Color(0xff000000),
        scrim: Color(0xff000000),
        inverseSurface: Color(0xff2d3134),
        inverseOnSurface: Color(0xffeef1f5),
        inversePrimary: Color(0xff82cfff),
        primaryFixed: Color(0xffc6e7ff),
        onPrimaryFixed: Color(0xff001e2d),
        primaryFixedDim: Color(0xff82cfff),
        onPrimaryFixedVariant: Color(0xff004c6b),
        secondaryFixed: Color(0xffc6e7ff),
        onSecondaryFixed: Color(0xff001e2d),
        secondaryFixedDim: Color(0xff92cef5),
        onSecondaryFixedVariant: Color(0xff004c6b),
        tertiaryFixed: Color(0xffaeecff),
        onTertiaryFixed: Color(0xff001f26),
        tertiaryFixedDim: Color(0xff45d7f9),
        onTertiaryFixedVariant: Color(0xff004e5d),
        surfaceDim: Color(0xffd7dade),
        surfaceBright: Color(0xfff7f9fd),
        surfaceContainerLowest: Color(0xffffffff),
        surfaceContainerLow: Color(0xfff1f4f8),
        surfaceContainer: Color(0xffebeef2),
        surfaceContainerHigh: Color(0xffe6e8ec),
        surfaceContainerHighest: Color(0xffe0e3e7),
      );

  ThemeData light() => theme(lightScheme().toColorScheme());

  static MaterialScheme lightMediumContrastScheme() => const MaterialScheme(
        brightness: Brightness.light,
        primary: Color(0xff004866),
        surfaceTint: Color(0xff00658d),
        onPrimary: Color(0xffffffff),
        primaryContainer: Color(0xff1f7ca9),
        onPrimaryContainer: Color(0xffffffff),
        secondary: Color(0xff004866),
        onSecondary: Color(0xffffffff),
        secondaryContainer: Color(0xff347497),
        onSecondaryContainer: Color(0xffffffff),
        tertiary: Color(0xff004a58),
        onTertiary: Color(0xffffffff),
        tertiaryContainer: Color(0xff008097),
        onTertiaryContainer: Color(0xffffffff),
        error: Color(0xff8c0009),
        onError: Color(0xffffffff),
        errorContainer: Color(0xffda342e),
        onErrorContainer: Color(0xffffffff),
        background: Color(0xfff7f9fd),
        onBackground: Color(0xff181c1f),
        surface: Color(0xfff7f9fd),
        onSurface: Color(0xff181c1f),
        surfaceVariant: Color(0xffdbe3eb),
        onSurfaceVariant: Color(0xff3c444a),
        outline: Color(0xff586067),
        outlineVariant: Color(0xff737c83),
        shadow: Color(0xff000000),
        scrim: Color(0xff000000),
        inverseSurface: Color(0xff2d3134),
        inverseOnSurface: Color(0xffeef1f5),
        inversePrimary: Color(0xff82cfff),
        primaryFixed: Color(0xff1f7ca9),
        onPrimaryFixed: Color(0xffffffff),
        primaryFixedDim: Color(0xff00638a),
        onPrimaryFixedVariant: Color(0xffffffff),
        secondaryFixed: Color(0xff3c7b9f),
        onSecondaryFixed: Color(0xffffffff),
        secondaryFixedDim: Color(0xff1d6285),
        onSecondaryFixedVariant: Color(0xffffffff),
        tertiaryFixed: Color(0xff008097),
        onTertiaryFixed: Color(0xffffffff),
        tertiaryFixedDim: Color(0xff006578),
        onTertiaryFixedVariant: Color(0xffffffff),
        surfaceDim: Color(0xffd7dade),
        surfaceBright: Color(0xfff7f9fd),
        surfaceContainerLowest: Color(0xffffffff),
        surfaceContainerLow: Color(0xfff1f4f8),
        surfaceContainer: Color(0xffebeef2),
        surfaceContainerHigh: Color(0xffe6e8ec),
        surfaceContainerHighest: Color(0xffe0e3e7),
      );

  ThemeData lightMediumContrast() =>
      theme(lightMediumContrastScheme().toColorScheme());

  static MaterialScheme lightHighContrastScheme() => const MaterialScheme(
        brightness: Brightness.light,
        primary: Color(0xff002537),
        surfaceTint: Color(0xff00658d),
        onPrimary: Color(0xffffffff),
        primaryContainer: Color(0xff004866),
        onPrimaryContainer: Color(0xffffffff),
        secondary: Color(0xff002537),
        onSecondary: Color(0xffffffff),
        secondaryContainer: Color(0xff004866),
        onSecondaryContainer: Color(0xffffffff),
        tertiary: Color(0xff00262f),
        onTertiary: Color(0xffffffff),
        tertiaryContainer: Color(0xff004a58),
        onTertiaryContainer: Color(0xffffffff),
        error: Color(0xff4e0002),
        onError: Color(0xffffffff),
        errorContainer: Color(0xff8c0009),
        onErrorContainer: Color(0xffffffff),
        background: Color(0xfff7f9fd),
        onBackground: Color(0xff181c1f),
        surface: Color(0xfff7f9fd),
        onSurface: Color(0xff000000),
        surfaceVariant: Color(0xffdbe3eb),
        onSurfaceVariant: Color(0xff1d252b),
        outline: Color(0xff3c444a),
        outlineVariant: Color(0xff3c444a),
        shadow: Color(0xff000000),
        scrim: Color(0xff000000),
        inverseSurface: Color(0xff2d3134),
        inverseOnSurface: Color(0xffffffff),
        inversePrimary: Color(0xffdaefff),
        primaryFixed: Color(0xff004866),
        onPrimaryFixed: Color(0xffffffff),
        primaryFixedDim: Color(0xff003046),
        onPrimaryFixedVariant: Color(0xffffffff),
        secondaryFixed: Color(0xff004866),
        onSecondaryFixed: Color(0xffffffff),
        secondaryFixedDim: Color(0xff003046),
        onSecondaryFixedVariant: Color(0xffffffff),
        tertiaryFixed: Color(0xff004a58),
        onTertiaryFixed: Color(0xffffffff),
        tertiaryFixedDim: Color(0xff00323c),
        onTertiaryFixedVariant: Color(0xffffffff),
        surfaceDim: Color(0xffd7dade),
        surfaceBright: Color(0xfff7f9fd),
        surfaceContainerLowest: Color(0xffffffff),
        surfaceContainerLow: Color(0xfff1f4f8),
        surfaceContainer: Color(0xffebeef2),
        surfaceContainerHigh: Color(0xffe6e8ec),
        surfaceContainerHighest: Color(0xffe0e3e7),
      );

  ThemeData lightHighContrast() =>
      theme(lightHighContrastScheme().toColorScheme());

  static MaterialScheme darkScheme() => const MaterialScheme(
        brightness: Brightness.dark,
        primary: Color(0xff82cfff),
        surfaceTint: Color(0xff82cfff),
        onPrimary: Color(0xff00344b),
        primaryContainer: Color(0xff1f7ca9),
        onPrimaryContainer: Color(0xffffffff),
        secondary: Color(0xff92cef5),
        onSecondary: Color(0xff00344b),
        secondaryContainer: Color(0xff0f5a7c),
        onSecondaryContainer: Color(0xfff1f8ff),
        tertiary: Color(0xffc7f1ff),
        onTertiary: Color(0xff003641),
        tertiaryContainer: Color(0xff3bd1f2),
        onTertiaryContainer: Color(0xff003743),
        error: Color(0xffffb4ab),
        onError: Color(0xff690005),
        errorContainer: Color(0xff93000a),
        onErrorContainer: Color(0xffffdad6),
        background: Color(0xff101417),
        onBackground: Color(0xffe0e3e7),
        surface: Color(0xff101417),
        onSurface: Color(0xffe0e3e7),
        surfaceVariant: Color(0xff3f484e),
        onSurfaceVariant: Color(0xffbfc8cf),
        outline: Color(0xff899299),
        outlineVariant: Color(0xff3f484e),
        shadow: Color(0xff000000),
        scrim: Color(0xff000000),
        inverseSurface: Color(0xffe0e3e7),
        inverseOnSurface: Color(0xff2d3134),
        inversePrimary: Color(0xff00658d),
        primaryFixed: Color(0xffc6e7ff),
        onPrimaryFixed: Color(0xff001e2d),
        primaryFixedDim: Color(0xff82cfff),
        onPrimaryFixedVariant: Color(0xff004c6b),
        secondaryFixed: Color(0xffc6e7ff),
        onSecondaryFixed: Color(0xff001e2d),
        secondaryFixedDim: Color(0xff92cef5),
        onSecondaryFixedVariant: Color(0xff004c6b),
        tertiaryFixed: Color(0xffaeecff),
        onTertiaryFixed: Color(0xff001f26),
        tertiaryFixedDim: Color(0xff45d7f9),
        onTertiaryFixedVariant: Color(0xff004e5d),
        surfaceDim: Color(0xff101417),
        surfaceBright: Color(0xff363a3d),
        surfaceContainerLowest: Color(0xff0b0f11),
        surfaceContainerLow: Color(0xff181c1f),
        surfaceContainer: Color(0xff1c2023),
        surfaceContainerHigh: Color(0xff272a2d),
        surfaceContainerHighest: Color(0xff313538),
      );

  ThemeData dark() => theme(darkScheme().toColorScheme());

  static MaterialScheme darkMediumContrastScheme() => const MaterialScheme(
        brightness: Brightness.dark,
        primary: Color(0xff8ed3ff),
        surfaceTint: Color(0xff82cfff),
        onPrimary: Color(0xff001926),
        primaryContainer: Color(0xff4699c7),
        onPrimaryContainer: Color(0xff000000),
        secondary: Color(0xff96d2fa),
        onSecondary: Color(0xff001826),
        secondaryContainer: Color(0xff5b97bd),
        onSecondaryContainer: Color(0xff000000),
        tertiary: Color(0xffc7f1ff),
        onTertiary: Color(0xff00343f),
        tertiaryContainer: Color(0xff3bd1f2),
        onTertiaryContainer: Color(0xff00090c),
        error: Color(0xffffbab1),
        onError: Color(0xff370001),
        errorContainer: Color(0xffff5449),
        onErrorContainer: Color(0xff000000),
        background: Color(0xff101417),
        onBackground: Color(0xffe0e3e7),
        surface: Color(0xff101417),
        onSurface: Color(0xfff8fbff),
        surfaceVariant: Color(0xff3f484e),
        onSurfaceVariant: Color(0xffc3ccd4),
        outline: Color(0xff9ba4ab),
        outlineVariant: Color(0xff7c848b),
        shadow: Color(0xff000000),
        scrim: Color(0xff000000),
        inverseSurface: Color(0xffe0e3e7),
        inverseOnSurface: Color(0xff272a2e),
        inversePrimary: Color(0xff004d6d),
        primaryFixed: Color(0xffc6e7ff),
        onPrimaryFixed: Color(0xff00131e),
        primaryFixedDim: Color(0xff82cfff),
        onPrimaryFixedVariant: Color(0xff003a53),
        secondaryFixed: Color(0xffc6e7ff),
        onSecondaryFixed: Color(0xff00131f),
        secondaryFixedDim: Color(0xff92cef5),
        onSecondaryFixedVariant: Color(0xff003a54),
        tertiaryFixed: Color(0xffaeecff),
        onTertiaryFixed: Color(0xff001419),
        tertiaryFixedDim: Color(0xff45d7f9),
        onTertiaryFixedVariant: Color(0xff003c48),
        surfaceDim: Color(0xff101417),
        surfaceBright: Color(0xff363a3d),
        surfaceContainerLowest: Color(0xff0b0f11),
        surfaceContainerLow: Color(0xff181c1f),
        surfaceContainer: Color(0xff1c2023),
        surfaceContainerHigh: Color(0xff272a2d),
        surfaceContainerHighest: Color(0xff313538),
      );

  ThemeData darkMediumContrast() =>
      theme(darkMediumContrastScheme().toColorScheme());

  static MaterialScheme darkHighContrastScheme() => const MaterialScheme(
        brightness: Brightness.dark,
        primary: Color(0xfff8fbff),
        surfaceTint: Color(0xff82cfff),
        onPrimary: Color(0xff000000),
        primaryContainer: Color(0xff8ed3ff),
        onPrimaryContainer: Color(0xff000000),
        secondary: Color(0xfff8fbff),
        onSecondary: Color(0xff000000),
        secondaryContainer: Color(0xff96d2fa),
        onSecondaryContainer: Color(0xff000000),
        tertiary: Color(0xfff4fcff),
        onTertiary: Color(0xff000000),
        tertiaryContainer: Color(0xff4bdbfd),
        onTertiaryContainer: Color(0xff000000),
        error: Color(0xfffff9f9),
        onError: Color(0xff000000),
        errorContainer: Color(0xffffbab1),
        onErrorContainer: Color(0xff000000),
        background: Color(0xff101417),
        onBackground: Color(0xffe0e3e7),
        surface: Color(0xff101417),
        onSurface: Color(0xffffffff),
        surfaceVariant: Color(0xff3f484e),
        onSurfaceVariant: Color(0xfff8fbff),
        outline: Color(0xffc3ccd4),
        outlineVariant: Color(0xffc3ccd4),
        shadow: Color(0xff000000),
        scrim: Color(0xff000000),
        inverseSurface: Color(0xffe0e3e7),
        inverseOnSurface: Color(0xff000000),
        inversePrimary: Color(0xff002d42),
        primaryFixed: Color(0xffcfeaff),
        onPrimaryFixed: Color(0xff000000),
        primaryFixedDim: Color(0xff8ed3ff),
        onPrimaryFixedVariant: Color(0xff001926),
        secondaryFixed: Color(0xffd0eaff),
        onSecondaryFixed: Color(0xff000000),
        secondaryFixedDim: Color(0xff96d2fa),
        onSecondaryFixedVariant: Color(0xff001826),
        tertiaryFixed: Color(0xffbcefff),
        onTertiaryFixed: Color(0xff000000),
        tertiaryFixedDim: Color(0xff4bdbfd),
        onTertiaryFixedVariant: Color(0xff001920),
        surfaceDim: Color(0xff101417),
        surfaceBright: Color(0xff363a3d),
        surfaceContainerLowest: Color(0xff0b0f11),
        surfaceContainerLow: Color(0xff181c1f),
        surfaceContainer: Color(0xff1c2023),
        surfaceContainerHigh: Color(0xff272a2d),
        surfaceContainerHighest: Color(0xff313538),
      );

  ThemeData darkHighContrast() =>
      theme(darkHighContrastScheme().toColorScheme());

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        textTheme: textTheme.apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
        scaffoldBackgroundColor: colorScheme.background,
        canvasColor: colorScheme.surface,
      );

  /// Baby Blue
  static const babyBlue = ExtendedColor(
    seed: Color(0xffbbdcff),
    value: Color(0xffbbdcff),
    light: ColorFamily(
      color: Color(0xff41617f),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffc5e1ff),
      onColorContainer: Color(0xff274865),
    ),
    lightMediumContrast: ColorFamily(
      color: Color(0xff41617f),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffc5e1ff),
      onColorContainer: Color(0xff274865),
    ),
    lightHighContrast: ColorFamily(
      color: Color(0xff41617f),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffc5e1ff),
      onColorContainer: Color(0xff274865),
    ),
    dark: ColorFamily(
      color: Color(0xffffffff),
      onColor: Color(0xff0d334e),
      colorContainer: Color(0xffb7d8fb),
      onColorContainer: Color(0xff20425e),
    ),
    darkMediumContrast: ColorFamily(
      color: Color(0xffffffff),
      onColor: Color(0xff0d334e),
      colorContainer: Color(0xffb7d8fb),
      onColorContainer: Color(0xff20425e),
    ),
    darkHighContrast: ColorFamily(
      color: Color(0xffffffff),
      onColor: Color(0xff0d334e),
      colorContainer: Color(0xffb7d8fb),
      onColorContainer: Color(0xff20425e),
    ),
  );

  /// Yellow
  static const yellow = ExtendedColor(
    seed: Color(0xffe3c117),
    value: Color(0xffe3c117),
    light: ColorFamily(
      color: Color(0xff6f5d00),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffecc923),
      onColorContainer: Color(0xff443900),
    ),
    lightMediumContrast: ColorFamily(
      color: Color(0xff6f5d00),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffecc923),
      onColorContainer: Color(0xff443900),
    ),
    lightHighContrast: ColorFamily(
      color: Color(0xff6f5d00),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffecc923),
      onColorContainer: Color(0xff443900),
    ),
    dark: ColorFamily(
      color: Color(0xffffe78c),
      onColor: Color(0xff3a3000),
      colorContainer: Color(0xffddbc0c),
      onColorContainer: Color(0xff392f00),
    ),
    darkMediumContrast: ColorFamily(
      color: Color(0xffffe78c),
      onColor: Color(0xff3a3000),
      colorContainer: Color(0xffddbc0c),
      onColorContainer: Color(0xff392f00),
    ),
    darkHighContrast: ColorFamily(
      color: Color(0xffffe78c),
      onColor: Color(0xff3a3000),
      colorContainer: Color(0xffddbc0c),
      onColorContainer: Color(0xff392f00),
    ),
  );

  /// Brown
  static const brown = ExtendedColor(
    seed: Color(0xff965f00),
    value: Color(0xff965f00),
    light: ColorFamily(
      color: Color(0xff653f00),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xff965f00),
      onColorContainer: Color(0xffffffff),
    ),
    lightMediumContrast: ColorFamily(
      color: Color(0xff653f00),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xff965f00),
      onColorContainer: Color(0xffffffff),
    ),
    lightHighContrast: ColorFamily(
      color: Color(0xff653f00),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xff965f00),
      onColorContainer: Color(0xffffffff),
    ),
    dark: ColorFamily(
      color: Color(0xffffb95d),
      onColor: Color(0xff462a00),
      colorContainer: Color(0xff895600),
      onColorContainer: Color(0xffffffff),
    ),
    darkMediumContrast: ColorFamily(
      color: Color(0xffffb95d),
      onColor: Color(0xff462a00),
      colorContainer: Color(0xff895600),
      onColorContainer: Color(0xffffffff),
    ),
    darkHighContrast: ColorFamily(
      color: Color(0xffffb95d),
      onColor: Color(0xff462a00),
      colorContainer: Color(0xff895600),
      onColorContainer: Color(0xffffffff),
    ),
  );

  /// Green
  static const green = ExtendedColor(
    seed: Color(0xff00d008),
    value: Color(0xff00d008),
    light: ColorFamily(
      color: Color(0xff006e01),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xff23dc1d),
      onColorContainer: Color(0xff003900),
    ),
    lightMediumContrast: ColorFamily(
      color: Color(0xff006e01),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xff23dc1d),
      onColorContainer: Color(0xff003900),
    ),
    lightHighContrast: ColorFamily(
      color: Color(0xff006e01),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xff23dc1d),
      onColorContainer: Color(0xff003900),
    ),
    dark: ColorFamily(
      color: Color(0xff47f439),
      onColor: Color(0xff003a00),
      colorContainer: Color(0xff00c807),
      onColorContainer: Color(0xff002800),
    ),
    darkMediumContrast: ColorFamily(
      color: Color(0xff47f439),
      onColor: Color(0xff003a00),
      colorContainer: Color(0xff00c807),
      onColorContainer: Color(0xff002800),
    ),
    darkHighContrast: ColorFamily(
      color: Color(0xff47f439),
      onColor: Color(0xff003a00),
      colorContainer: Color(0xff00c807),
      onColorContainer: Color(0xff002800),
    ),
  );

  /// Orange
  static const orange = ExtendedColor(
    seed: Color(0xffe65f3a),
    value: Color(0xffe65f3a),
    light: ColorFamily(
      color: Color(0xff972704),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffc94b27),
      onColorContainer: Color(0xffffffff),
    ),
    lightMediumContrast: ColorFamily(
      color: Color(0xff972704),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffc94b27),
      onColorContainer: Color(0xffffffff),
    ),
    lightHighContrast: ColorFamily(
      color: Color(0xff972704),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffc94b27),
      onColorContainer: Color(0xffffffff),
    ),
    dark: ColorFamily(
      color: Color(0xffffb5a1),
      onColor: Color(0xff601400),
      colorContainer: Color(0xffc94b27),
      onColorContainer: Color(0xffffffff),
    ),
    darkMediumContrast: ColorFamily(
      color: Color(0xffffb5a1),
      onColor: Color(0xff601400),
      colorContainer: Color(0xffc94b27),
      onColorContainer: Color(0xffffffff),
    ),
    darkHighContrast: ColorFamily(
      color: Color(0xffffb5a1),
      onColor: Color(0xff601400),
      colorContainer: Color(0xffc94b27),
      onColorContainer: Color(0xffffffff),
    ),
  );

  /// Red
  static const red = ExtendedColor(
    seed: Color(0xffe32517),
    value: Color(0xffe32517),
    light: ColorFamily(
      color: Color(0xffa60100),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffe32517),
      onColorContainer: Color(0xffffffff),
    ),
    lightMediumContrast: ColorFamily(
      color: Color(0xffa60100),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffe32517),
      onColorContainer: Color(0xffffffff),
    ),
    lightHighContrast: ColorFamily(
      color: Color(0xffa60100),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffe32517),
      onColorContainer: Color(0xffffffff),
    ),
    dark: ColorFamily(
      color: Color(0xffffb4a8),
      onColor: Color(0xff690000),
      colorContainer: Color(0xffd71a0e),
      onColorContainer: Color(0xffffffff),
    ),
    darkMediumContrast: ColorFamily(
      color: Color(0xffffb4a8),
      onColor: Color(0xff690000),
      colorContainer: Color(0xffd71a0e),
      onColorContainer: Color(0xffffffff),
    ),
    darkHighContrast: ColorFamily(
      color: Color(0xffffb4a8),
      onColor: Color(0xff690000),
      colorContainer: Color(0xffd71a0e),
      onColorContainer: Color(0xffffffff),
    ),
  );

  List<ExtendedColor> get extendedColors => [
        babyBlue,
        yellow,
        brown,
        green,
        orange,
        red,
      ];
}

class MaterialScheme {
  const MaterialScheme({
    required this.brightness,
    required this.primary,
    required this.surfaceTint,
    required this.onPrimary,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.secondary,
    required this.onSecondary,
    required this.secondaryContainer,
    required this.onSecondaryContainer,
    required this.tertiary,
    required this.onTertiary,
    required this.tertiaryContainer,
    required this.onTertiaryContainer,
    required this.error,
    required this.onError,
    required this.errorContainer,
    required this.onErrorContainer,
    required this.background,
    required this.onBackground,
    required this.surface,
    required this.onSurface,
    required this.surfaceVariant,
    required this.onSurfaceVariant,
    required this.outline,
    required this.outlineVariant,
    required this.shadow,
    required this.scrim,
    required this.inverseSurface,
    required this.inverseOnSurface,
    required this.inversePrimary,
    required this.primaryFixed,
    required this.onPrimaryFixed,
    required this.primaryFixedDim,
    required this.onPrimaryFixedVariant,
    required this.secondaryFixed,
    required this.onSecondaryFixed,
    required this.secondaryFixedDim,
    required this.onSecondaryFixedVariant,
    required this.tertiaryFixed,
    required this.onTertiaryFixed,
    required this.tertiaryFixedDim,
    required this.onTertiaryFixedVariant,
    required this.surfaceDim,
    required this.surfaceBright,
    required this.surfaceContainerLowest,
    required this.surfaceContainerLow,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.surfaceContainerHighest,
  });

  final Brightness brightness;
  final Color primary;
  final Color surfaceTint;
  final Color onPrimary;
  final Color primaryContainer;
  final Color onPrimaryContainer;
  final Color secondary;
  final Color onSecondary;
  final Color secondaryContainer;
  final Color onSecondaryContainer;
  final Color tertiary;
  final Color onTertiary;
  final Color tertiaryContainer;
  final Color onTertiaryContainer;
  final Color error;
  final Color onError;
  final Color errorContainer;
  final Color onErrorContainer;
  final Color background;
  final Color onBackground;
  final Color surface;
  final Color onSurface;
  final Color surfaceVariant;
  final Color onSurfaceVariant;
  final Color outline;
  final Color outlineVariant;
  final Color shadow;
  final Color scrim;
  final Color inverseSurface;
  final Color inverseOnSurface;
  final Color inversePrimary;
  final Color primaryFixed;
  final Color onPrimaryFixed;
  final Color primaryFixedDim;
  final Color onPrimaryFixedVariant;
  final Color secondaryFixed;
  final Color onSecondaryFixed;
  final Color secondaryFixedDim;
  final Color onSecondaryFixedVariant;
  final Color tertiaryFixed;
  final Color onTertiaryFixed;
  final Color tertiaryFixedDim;
  final Color onTertiaryFixedVariant;
  final Color surfaceDim;
  final Color surfaceBright;
  final Color surfaceContainerLowest;
  final Color surfaceContainerLow;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color surfaceContainerHighest;
}

extension MaterialSchemeUtils on MaterialScheme {
  ColorScheme toColorScheme() => ColorScheme(
        brightness: brightness,
        primary: primary,
        onPrimary: onPrimary,
        primaryContainer: primaryContainer,
        onPrimaryContainer: onPrimaryContainer,
        secondary: secondary,
        onSecondary: onSecondary,
        secondaryContainer: secondaryContainer,
        onSecondaryContainer: onSecondaryContainer,
        tertiary: tertiary,
        onTertiary: onTertiary,
        tertiaryContainer: tertiaryContainer,
        onTertiaryContainer: onTertiaryContainer,
        error: error,
        onError: onError,
        errorContainer: errorContainer,
        onErrorContainer: onErrorContainer,
        background: background,
        onBackground: onBackground,
        surface: surface,
        onSurface: onSurface,
        surfaceVariant: surfaceVariant,
        onSurfaceVariant: onSurfaceVariant,
        outline: outline,
        outlineVariant: outlineVariant,
        shadow: shadow,
        scrim: scrim,
        inverseSurface: inverseSurface,
        onInverseSurface: inverseOnSurface,
        inversePrimary: inversePrimary,
      );
}

class ExtendedColor {
  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
  final Color seed;
  final Color value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}

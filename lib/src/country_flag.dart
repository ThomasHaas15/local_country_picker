import 'package:flutter/material.dart';

import 'country_flag_shape.dart';
import 'data/countries.dart';

/// The package name used to resolve the bundled flag assets.
const String _kPackageName = 'local_country_picker';

/// Uppercased ISO alpha-2 codes the package ships flag assets for.
///
/// Built once from [kCountryCodes] (which is already uppercase) so membership
/// checks in [isKnownCountryCode] are O(1).
final Set<String> _kKnownCodes = kCountryCodes
    .map((String code) => code.toUpperCase())
    .toSet();

/// Whether [countryCode] is a known ISO 3166-1 alpha-2 code that ships with a
/// bundled flag asset.
///
/// The check is case-insensitive (e.g. both `'it'` and `'IT'` return `true`).
bool isKnownCountryCode(String countryCode) =>
    _kKnownCodes.contains(countryCode.toUpperCase());

/// Returns the in-package asset path for a country flag, e.g.
/// `'assets/flags/round/IT.png'`.
///
/// [countryCode] is an ISO 3166-1 alpha-2 code (case-insensitive; it is
/// uppercased in the returned path). [shape] selects the round or rectangular
/// flag set.
///
/// The returned path is relative to the package and is **not** prefixed with
/// `packages/...`; pass `package: 'local_country_picker'` to the relevant
/// [Image]/[AssetImage] constructor (see [countryFlagImage] and [CountryFlag]).
String countryFlagAssetPath(
  String countryCode, {
  CountryFlagShape shape = CountryFlagShape.round,
}) {
  final shapeDir = shape == CountryFlagShape.round ? 'round' : 'rect';
  return 'assets/flags/$shapeDir/${countryCode.toUpperCase()}.png';
}

/// Returns an [AssetImage] for a country flag bundled with this package.
///
/// [countryCode] is an ISO 3166-1 alpha-2 code (case-insensitive). [shape]
/// selects the round or rectangular flag set. The provider is already scoped
/// to the `local_country_picker` package, so it can be used directly anywhere
/// an [ImageProvider] is expected.
AssetImage countryFlagImage(
  String countryCode, {
  CountryFlagShape shape = CountryFlagShape.round,
}) =>
    AssetImage(
      countryFlagAssetPath(countryCode, shape: shape),
      package: _kPackageName,
    );

/// Renders a country flag image from a 2-letter ISO 3166-1 alpha-2 code.
///
/// The flag PNGs are bundled with this package, so no network access is
/// required. [countryCode] is case-insensitive (e.g. both `'it'` and `'IT'`
/// resolve to the same flag).
///
/// If the code is not a [isKnownCountryCode] (or the asset is otherwise
/// missing), the widget degrades gracefully by rendering [errorWidget], or a
/// zero-size [SizedBox] when none is supplied — it never throws.
///
/// ```dart
/// const CountryFlag('IT', width: 24, height: 24);
/// const CountryFlag('NL', shape: CountryFlagShape.rect);
/// ```
class CountryFlag extends StatelessWidget {
  /// Creates a flag widget for the given ISO 3166-1 alpha-2 [countryCode].
  const CountryFlag(
    this.countryCode, {
    super.key,
    this.shape = CountryFlagShape.round,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.errorWidget,
  });

  /// ISO 3166-1 alpha-2 country code (case-insensitive).
  final String countryCode;

  /// Which flag set to render: round (default) or rectangular.
  final CountryFlagShape shape;

  /// Optional width passed to the underlying [Image].
  final double? width;

  /// Optional height passed to the underlying [Image].
  final double? height;

  /// How the flag should be inscribed into its box. Defaults to
  /// [BoxFit.contain].
  final BoxFit fit;

  /// Widget rendered when the code is unknown or the asset fails to load.
  ///
  /// Defaults to `const SizedBox.shrink()`.
  final Widget? errorWidget;

  @override
  Widget build(BuildContext context) {
    final fallback = errorWidget ?? const SizedBox.shrink();

    // Guard: skip the asset lookup entirely for unknown codes so we never
    // attempt to load a missing asset.
    if (!isKnownCountryCode(countryCode)) {
      return fallback;
    }

    return Image.asset(
      countryFlagAssetPath(countryCode, shape: shape),
      package: _kPackageName,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (_, __, ___) => fallback,
    );
  }
}

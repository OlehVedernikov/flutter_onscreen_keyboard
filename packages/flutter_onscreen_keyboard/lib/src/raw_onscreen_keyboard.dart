import 'package:flutter/material.dart';
import 'package:flutter_onscreen_keyboard/flutter_onscreen_keyboard.dart';
import 'package:flutter_onscreen_keyboard/src/widgets/keys.dart';

/// A builder function for customizing the appearance of text keys in the keyboard.
///
/// This builder is called for each [TextKey] in the keyboard layout, allowing you
/// to provide a custom widget implementation instead of the default [TextKeyWidget].
///
/// Parameters:
/// * [textKey] - The [TextKey] instance containing the key's properties like
///   primary/secondary text and any custom child widget.
/// * [onTapDown] - Callback to be invoked when the key is pressed down.
/// * [onTapUp] - Callback to be invoked when the key is released.
/// * [showSecondary] - Whether to show the secondary value of the key (e.g., uppercase
///   or alternate symbol). When true, use [TextKey.secondary] if available, or
///   uppercase the [TextKey.primary] value.
///
/// Returns a widget that will be used to render the text key in the keyboard layout.
/// The widget should handle the tap interactions using the provided callbacks.
typedef TextKeyBuilder =
    Widget Function({
      required TextKey textKey,
      required VoidCallback onTapDown,
      required VoidCallback onTapUp,
      required bool showSecondary,
    });

/// A builder function for customizing the appearance of action keys in the keyboard.
///
/// This builder is called for each [ActionKey] in the keyboard layout, allowing you
/// to provide a custom widget implementation instead of the default [ActionKeyWidget].
///
/// Parameters:
/// * [actionKey] - The [ActionKey] instance containing the key's properties and
///   action type.
/// * [onTapDown] - Callback to be invoked when the key is pressed down.
/// * [onTapUp] - Callback to be invoked when the key is released.
/// * [pressed] - Whether the action key is currently in a pressed state, useful
///   for toggle keys like Shift or Caps Lock.
///
/// Returns a widget that will be used to render the action key in the keyboard layout.
/// The widget should handle the tap interactions using the provided callbacks.
typedef ActionKeyBuilder =
    Widget Function({
      required ActionKey actionKey,
      required VoidCallback onTapDown,
      required VoidCallback onTapUp,
      required bool pressed,
    });

/// A low-level on-screen keyboard widget that displays keys
/// based on the given [KeyboardLayout].
///
/// It handles key rendering, layout structure, and interaction callbacks
/// for key presses. This widget is useful for embedding the keyboard UI
/// inside another widget and controlling its behavior externally.
class RawOnscreenKeyboard extends StatelessWidget {
  /// Creates a [RawOnscreenKeyboard] widget.
  const RawOnscreenKeyboard({
    required this.layout,
    required this.onKeyDown,
    required this.onKeyUp,
    required this.mode,
    this.textKeyBuilder,
    this.actionKeyBuilder,
    super.key,
    this.aspectRatio,
    this.pressedActionKeys = const {},
    this.showSecondary = false,
  });

  /// The keyboard layout that defines rows and keys to render.
  final KeyboardLayout layout;

  /// {@macro keyboardLayout.aspectRatio}
  ///
  /// Defaults to the aspect ratio of [layout].
  final double? aspectRatio;

  /// Callback when a key is pressed down.
  final ValueChanged<OnscreenKeyboardKey> onKeyDown;

  /// Callback when a key is released.
  final ValueChanged<OnscreenKeyboardKey> onKeyUp;

  /// A set of currently pressed action key names (e.g., shift, capslock).
  ///
  /// Used to visually indicate active keys like modifiers.
  final Set<String> pressedActionKeys;

  /// Whether to show the secondary value for each [TextKey] (e.g., uppercase).
  final bool showSecondary;

  /// The currently active keyboard mode to render from the layout.
  ///
  /// Must match one of the keys defined in [KeyboardLayout.modes].
  final String mode;

  /// A builder function that allows customizing the rendering of [TextKey] widgets.
  ///
  /// This function is called for each [TextKey] in the layout,
  /// allowing you to provide a custom widget instead of the default [TextKeyWidget].
  ///
  /// The function takes a [TextKey] and returns a [Widget].
  final TextKeyBuilder? textKeyBuilder;

  /// A builder function that allows customizing the rendering of [ActionKey] widgets.
  ///
  /// This function is called for each [ActionKey] in the layout,
  /// allowing you to provide a custom widget instead of the default [ActionKeyWidget].
  ///
  /// The function takes an [ActionKey] and returns a [Widget].
  final ActionKeyBuilder? actionKeyBuilder;

  @override
  Widget build(BuildContext context) {
    final activeMode = layout.modes[mode]!;
    return AspectRatio(
      aspectRatio: aspectRatio ?? layout.aspectRatio,
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          spacing: activeMode.verticalSpacing,
          children: [
            for (final row in activeMode.rows)
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ?row.leading,
                    for (final k in row.keys)
                      Expanded(
                        flex: k.flex,
                        child: switch (k) {
                          TextKey() =>
                            textKeyBuilder?.call(
                                  textKey: k,
                                  showSecondary: showSecondary,
                                  onTapDown: () => onKeyDown(k),
                                  onTapUp: () => onKeyUp(k),
                                ) ??
                                TextKeyWidget(
                                  textKey: k,
                                  showSecondary: showSecondary,
                                  onTapDown: () => onKeyDown(k),
                                  onTapUp: () => onKeyUp(k),
                                ),
                          ActionKey() =>
                            actionKeyBuilder?.call(
                                  actionKey: k,
                                  onTapDown: () => onKeyDown(k),
                                  onTapUp: () => onKeyUp(k),
                                  pressed: pressedActionKeys.contains(k.name),
                                ) ??
                                ActionKeyWidget(
                                  actionKey: k,
                                  pressed: pressedActionKeys.contains(k.name),
                                  onTapDown: () => onKeyDown(k),
                                  onTapUp: () => onKeyUp(k),
                                ),
                        },
                      ),
                    ?row.trailing,
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

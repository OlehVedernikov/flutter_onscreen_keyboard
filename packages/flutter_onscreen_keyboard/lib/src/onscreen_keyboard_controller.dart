part of 'onscreen_keyboard.dart';

/// An interface for controlling the [OnscreenKeyboard] programmatically.
///
/// This allows opening and closing the keyboard, changing its alignment,
/// managing focus and text input sources, and adding listeners
/// for raw key events.
abstract interface class OnscreenKeyboardController {
  /// Opens the onscreen keyboard.
  void open();

  /// Closes the onscreen keyboard.
  void close();

  /// Sets the alignment of the onscreen keyboard.
  ///
  /// [alignment] defines where the keyboard should appear in the app.
  void setAlignment(Alignment alignment);

  /// Moves the keyboard to the top-center of the available screen space.
  void moveToTop();

  /// Moves the keyboard to the bottom-center of the available screen space.
  void moveToBottom();

  /// Attaches an [OnscreenKeyboardTextFieldState] to the keyboard,
  /// making it the active input field for text input.
  ///
  /// > This will automatically detach any previously
  /// attached [OnscreenKeyboardTextField].
  void attachTextField(OnscreenKeyboardTextFieldState state);

  /// Detaches a previously attached [OnscreenKeyboardTextFieldState].
  ///
  /// If no [state] is provided, detaches the currently active one.
  void detachTextField([OnscreenKeyboardTextFieldState? state]);

  /// Adds a listener to receive raw key down events from the keyboard.
  ///
  /// Useful for handling custom shortcuts or key-based interactions.
  void addRawKeyDownListener(OnscreenKeyboardListener listener);

  /// Removes a previously added raw key down listener.
  void removeRawKeyDownListener(OnscreenKeyboardListener listener);

  /// Cycles to the next keyboard layout mode in the order they are defined.
  ///
  /// Keyboard modes are defined in the [KeyboardLayout.modes] map.
  /// Calling this method switches the current mode to the next one,
  /// wrapping around to the first mode when the end is reached.
  void switchMode();

  /// Cycles to the next keyboard layout in the order they are defined.
  ///
  /// Keyboard layouts are defined in the [KeyboardLayout.layouts] map.
  /// Calling this method switches the current layout to the next one,
  /// wrapping around to the first layout when the end is reached.
  void switchLayout();
}

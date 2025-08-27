# Drawable Text

A Flutter package that provides a text widget with drawable widgets at the start and end positions. This package allows you to easily add icons or any widget before or after text with customizable alignment and styling options.

## Features

- Add drawable widgets at the start and/or end of text
- Customize text appearance (size, color, font family, weight, etc.)
- Support for HTML text rendering
- Text selection capability
- Customizable padding between text and drawable widgets
- Different alignment options for drawable widgets
- Support for text overflow handling and max lines
- Easy to use factory constructors for common use cases

## Getting started

Add the package to your `pubspec.yaml` file:

```yaml
dependencies:
  drawable_text: ^1.0.0
```

Run the following command to get the package:

```bash
flutter pub get
```

## Usage

### Basic Usage

```dart
DrawableText(
  text: 'Hello World',
  drawableStart: Icon(Icons.star),
  drawableEnd: Icon(Icons.arrow_forward),
  drawablePadding: 8.0,
)
```

### With Custom Styling

```dart
DrawableText(
  text: 'Styled Text',
  size: 18.0,
  color: Colors.blue,
  fontWeight: FontWeight.bold,
  drawableStart: Icon(Icons.favorite, color: Colors.red),
  drawablePadding: 10.0,
  textAlign: TextAlign.center,
  maxLines: 2,
)
```

### Using Factory Constructor for Title

```dart
DrawableText.title(
  text: 'Section Title',
  color: Colors.black87,
  drawableStart: Icon(Icons.title),
  drawablePadding: 8.0,
)
```

### With HTML Content

```dart
DrawableText(
  text: '<p>This is <b>HTML</b> content</p>',
  drawableStart: Icon(Icons.code),
  drawablePadding: 8.0,
)
```

### Selectable Text

```dart
// Initialize globally
DrawableText.initial(selectable: true);

// Or per instance
DrawableText(
  text: 'This text can be selected',
  selectable: true,
  drawableStart: Icon(Icons.select_all),
)
```

## Additional information

- Package is licensed under "Free for all"
- For issues and feature requests, please visit the [GitHub repository](https://github.com/saedAlHanash/drawable_text.git)
- Contributions are welcome through pull requests

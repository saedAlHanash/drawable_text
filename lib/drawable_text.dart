library drawable_text;

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

enum DrawableAlin { withText, between }

extension HtmlHelper on String {
  bool get isHTML {
    if (contains('<div>') || contains('<p>') || contains('<h') || contains('</')) {
      return true;
    }
    return false;
  }
}

double _initialSize = 18;
double _initialHeight = 1.8;
Color _initialColor = Colors.black;

bool _selectable = false;
String _initialFont = '';

class DrawableText extends StatelessWidget {
  const DrawableText({
    Key? key,
    required this.text,
    this.size,
    this.fontFamily,
    this.color,
    this.textAlign,
    this.maxLines,
    this.textDecoration,
    this.selectable,
    this.matchParent,
    this.padding,
    this.drawableStart,
    this.drawableEnd,
    this.drawablePadding,
    this.maxLength,
    this.fontWeight,
    this.style,
    this.drawableAlin = DrawableAlin.between,
  }) : super(key: key);

  final String text;
  final double? size;
  final String? fontFamily;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final int? maxLength;
  final TextDecoration? textDecoration;
  final bool? matchParent;
  final EdgeInsets? padding;
  final Widget? drawableStart;
  final Widget? drawableEnd;
  final double? drawablePadding;
  final DrawableAlin drawableAlin;
  final bool? selectable;
  final FontWeight? fontWeight;
  final TextStyle? style;

  static initial({
    double initialHeightText = 1.8,
    double initialSize = 20,
    Color initialColor = Colors.black,
    bool selectable = false,
    String initialFont = 'cairoSemiBold',
  }) {
    _initialSize = initialSize;
    _initialHeight = initialHeightText;
    _initialColor = initialColor;
    _selectable = selectable;
    _initialFont = initialFont;
  }

  factory DrawableText.title({
    required String text,
    double? size,
    String? fontFamily,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    int? maxLength,
    TextDecoration? textDecoration,
    bool? matchParent,
    EdgeInsets? padding,
    Widget? drawableStart,
    Widget? drawableEnd,
    double? drawablePadding,
    DrawableAlin? drawableAlin,
    bool? selectable,
    FontWeight? fontWeight,
    TextStyle? style,
  }) {
    return DrawableText(
      text: text,
      size: size,
      fontFamily: fontFamily,
      color: color,
      textAlign: textAlign ?? TextAlign.start,
      maxLines: maxLines,
      maxLength: maxLength,
      textDecoration: textDecoration,
      matchParent: matchParent ?? true,
      padding: padding,
      drawableStart: drawableStart,
      drawableEnd: drawableEnd,
      drawablePadding: drawablePadding,
      drawableAlin: drawableAlin ?? DrawableAlin.between,
      selectable: selectable,
      fontWeight: fontWeight ?? FontWeight.bold,
      style: style,
    );
  }

  @override
  Widget build(BuildContext context) {
    final text = (maxLength == null || this.text.length <= maxLength!)
        ? this.text
        : '${this.text.substring(0, maxLength)}...';

    final textStyle = style ??
        TextStyle(
          color: color ?? _initialColor,
          fontSize: size ?? _initialSize,
          decoration: textDecoration,
          decorationColor: color ?? _initialColor,
          fontFamily: fontFamily ?? _initialFont,
          fontWeight: fontWeight,
          fontFeatures: const [FontFeature.proportionalFigures()],
          height: _initialHeight,
        );

    late Widget textWidget = Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines ?? 1000,
      style: textStyle,
      softWrap: true,
      overflow: TextOverflow.ellipsis,
    );

    Widget child = textWidget;

    // if (drawableStart != null && drawableEnd != null) {
    //   dPadding = EdgeInsets.symmetric(horizontal: drawablePadding ?? 0).w;
    // } else if (drawableStart != null) {
    //   dPadding = EdgeInsets.only(right: drawablePadding ?? 0).w;
    // } else if (drawableEnd != null) {
    //   dPadding = EdgeInsets.only(left: drawablePadding ?? 0).w;
    // } else {
    //   dPadding = EdgeInsets.zero;
    // }

    if (drawableStart != null || drawableEnd != null) {
      final childList = <Widget>[];

      if (drawableStart != null) {
        childList.add(Padding(
          padding: EdgeInsetsDirectional.only(end: (drawablePadding ?? 0)),
          child: drawableStart!,
        ));
      }

      if ((matchParent ?? false) && drawableAlin == DrawableAlin.between) {
        textWidget = Expanded(child: textWidget);
      }

      childList.add(textWidget);

      if (drawableEnd != null) {
        childList.add(Padding(
          padding: EdgeInsetsDirectional.only(start: (drawablePadding ?? 0)),
          child: drawableEnd!,
        ));
      }

      child = Row(
        mainAxisSize: MainAxisSize.min,
        children: childList,
      );
    }

    Widget finalWidget = Padding(
      padding: padding ?? EdgeInsets.zero,
      child: SizedBox(
        width: (matchParent ?? false) ? MediaQuery.of(context).size.width : null,
        child: text.isHTML ? HtmlWidget(text) : child,
      ),
    );

    if ((_selectable && selectable == null) || (selectable ?? false)) {
      finalWidget = SelectionArea(
        child: finalWidget,
      );
    }

    return finalWidget;
  }
}

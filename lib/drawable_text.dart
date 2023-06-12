library drawable_text;

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:seo_renderer/renderers/text_renderer/text_renderer_vm.dart';

enum DrawableAlin { withText, between }

enum FontManager { cairo, cairoBold, cairoSemiBold }

extension HtmlHelper on String {
  bool get isHTML {
    if (contains('<div>') || contains('<p>') || contains('<h') || contains('</')) {
      return true;
    }
    return false;
  }
}

double _headerSize = 20;
double _titleSize = 18;
double _initialSize = 18;
double _initialHeight = 1.8;
Color _initialColor = Colors.black;
bool _renderHtml = false;

class DrawableText extends StatelessWidget {
  const DrawableText({
    Key? key,
    required this.text,
    this.size,
    this.fontFamily = FontManager.cairoSemiBold,
    this.color,
    this.textAlign = TextAlign.start,
    this.maxLines = 100,
    this.underLine = false,
    this.matchParent,
    this.padding,
    this.drawableStart,
    this.drawableEnd,
    this.drawablePadding,
    this.maxLength,
    this.drawableAlin = DrawableAlin.between,
  }) : super(key: key);

  final String text;
  final double? size;
  final FontManager fontFamily;
  final Color? color;
  final TextAlign textAlign;
  final int maxLines;
  final int? maxLength;
  final bool underLine;
  final bool? matchParent;
  final EdgeInsets? padding;
  final Widget? drawableStart;
  final Widget? drawableEnd;
  final double? drawablePadding;
  final DrawableAlin drawableAlin;

  static initial({
    double headerSizeText = 20,
    double titleSizeText = 18,
    double initialHeightText = 1.8,
    double initialSize = 20,
    Color initialColor = Colors.black,
    bool renderHtml = false,
  }) {
    _headerSize = headerSizeText;
    _titleSize = titleSizeText;
    _initialSize = initialSize;
    _initialHeight = initialHeightText;
    _initialColor = initialColor;
    _renderHtml = renderHtml;
  }

  factory DrawableText.header({required String text}) {
    return DrawableText(
      text: text,
      fontFamily: FontManager.cairoBold,
      color: _initialColor,
      size: _headerSize,
    );
  }

  factory DrawableText.title({required String text,
    double? size,
    Color? color,
    bool? matchParent,
    EdgeInsets? padding}) {
    return DrawableText(
      text: text,
      fontFamily: FontManager.cairoBold,
      color: color ?? _initialColor,
      size: size ?? _titleSize,
      maxLines: 1,
      textAlign: TextAlign.center,
      matchParent: matchParent,
      padding: padding,
    );
  }

  factory DrawableText.titleList({
    required String text,
    EdgeInsets? padding,
    Color? color,
    Widget? drawableStart,
    Widget? drawableEnd,
  }) {
    return DrawableText(
      text: text,
      fontFamily: FontManager.cairoBold,
      color: color ?? _initialColor,
      size: _titleSize,
      maxLines: 1,
      matchParent: true,
      textAlign: TextAlign.start,
      padding: padding,
      drawableStart: drawableStart,
      drawableEnd: drawableEnd,
    );
  }

  @override
  Widget build(BuildContext context) {
    final text = (maxLength == null || this.text.length <= maxLength!)
        ? this.text
        : '${this.text.substring(0, maxLength)}...';

    final textStyle = TextStyle(
      color: color ?? _initialColor,
      fontSize: size ?? _initialSize,
      decoration: underLine ? TextDecoration.underline : null,
      fontFamily: fontFamily.name,
      fontFeatures:  const [FontFeature.proportionalFigures()],
      height: _initialHeight,
    );

    late Widget textWidget = Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
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
        width: (matchParent ?? false) ? MediaQuery
            .of(context)
            .size
            .width : null,
        child: child,
      ),
    );

    if (_renderHtml) {
      finalWidget = TextRenderer(
        text: text,
        child: finalWidget,
      );
    }

    return finalWidget;
  }
}

library drawable_text;

import 'package:flutter/material.dart';

enum DrawableAlin { withText, between }

enum FontManager { cairo, cairoBold, cairoSemiBold }

double headerSize = 20;
double titleSize = 18;
double initialHeight = 1.8;

class DrawableText extends StatelessWidget {
  const DrawableText({
    Key? key,
    required this.text,
    this.size,
    this.fontFamily = FontManager.cairoSemiBold,
    this.color = Colors.black,
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
  final Color color;
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
  }) {
    headerSize = headerSizeText;
    titleSize = titleSizeText;
    initialHeight = initialHeightText;
  }

  factory DrawableText.header({required String text}) {
    return DrawableText(
      text: text,
      fontFamily: FontManager.cairoBold,
      color: Colors.black,
      size: headerSize,
    );
  }

  factory DrawableText.title(
      {required String text,
      double? size,
      Color? color,
      bool? matchParent,
      EdgeInsets? padding}) {
    return DrawableText(
      text: text,
      fontFamily: FontManager.cairoBold,
      color: color ?? Colors.black,
      size: size ?? titleSize,
      maxLines: 1,
      textAlign: TextAlign.center,
      matchParent: matchParent,
      padding: padding,
    );
  }

  @override
  Widget build(BuildContext context) {
    final text = (maxLength == null || this.text.length <= maxLength!)
        ? this.text
        : '${this.text.substring(0, maxLength)}...';

    final textStyle = TextStyle(
      color: color,
      fontSize: size ?? titleSize,
      decoration: underLine ? TextDecoration.underline : null,
      fontFamily: fontFamily.name,
      height: initialHeight,
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

    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: SizedBox(
        width: (matchParent ?? false) ? MediaQuery.of(context).size.width : null,
        child: child,
      ),
    );
  }
}

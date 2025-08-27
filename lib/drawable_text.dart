library;

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

bool _selectable = false;

class DrawableText extends StatelessWidget {
  const DrawableText({
    super.key,
    required this.text,
    this.size,
    this.fontFamily,
    this.color,
    this.textAlign,
    this.maxLines,
    this.textDecoration,
    this.selectable,
    this.matchParent = false,
    this.padding,
    this.drawableStart,
    this.drawableEnd,
    this.drawablePadding,
    this.maxLength,
    this.fontWeight,
    this.style,
    this.drawableAlin = DrawableAlin.between,
  });

  final String text;
  final double? size;
  final String? fontFamily;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final int? maxLength;
  final TextDecoration? textDecoration;
  final bool matchParent;
  final EdgeInsets? padding;
  final Widget? drawableStart;
  final Widget? drawableEnd;
  final double? drawablePadding;
  final DrawableAlin drawableAlin;
  final bool? selectable;
  final FontWeight? fontWeight;
  final TextStyle? style;

  static initial({
    bool selectable = false,
  }) {
    _selectable = selectable;
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
    final text = (maxLength == null || this.text.length <= maxLength!) ? this.text : '${this.text.substring(0, maxLength)}...';

    late Widget textWidget = Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines ?? 1000,
      style: style,
      softWrap: true,
      overflow: TextOverflow.ellipsis,
    );

    Widget child = textWidget;

    if (drawableStart != null || drawableEnd != null) {
      final childList = <Widget>[];

      if (drawableStart != null) {
        childList.add(Padding(
          padding: EdgeInsetsDirectional.only(end: (drawablePadding ?? 0)),
          child: drawableStart!,
        ));
      }

      if (matchParent && drawableAlin == DrawableAlin.between) {
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
        width: matchParent ? MediaQuery.of(context).size.width : null,
        child: text.isHTML ? HtmlWidget(text, textStyle: style) : child,
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

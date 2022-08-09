import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

extension FlavourTypeExtension on String {
  String getBaseUrl() {
    switch (this) {
      case 'dev':
        return 'https://4532food.ikea.ae/graphql';
      case 'qa':
        return 'https://4532food.ikea.ae/graphql';
      case 'prod':
        return 'https://food.ikea.ae/graphql';
      default:
        return 'https://4532food.ikea.ae/graphql';
    }
  }

  String getRestApiBaseUrl() {
    switch (this) {
      case 'dev':
        return 'https://4532food.ikea.ae/';
      case 'qa':
        return 'https://4532food.ikea.ae/';
      case 'prod':
        return 'https://food.ikea.ae/';
      default:
        return 'https://4532food.ikea.ae/';
    }
  }

  String capitaliseFirstLetter(String? input) {
    if (input != null) {
      return input[0].toUpperCase() + input.substring(1);
    } else {
      return '';
    }
  }
}

extension SmallLetter on String {
  String toSmall() {
    return toLowerCase();
  }
}

extension Context on BuildContext {
  double sh({double size = 1.0}) {
    return MediaQuery.of(this).size.height * size;
  }

  double sw({double size = 1.0}) {
    return MediaQuery.of(this).size.width * size;
  }

  void rootPop() {
    Navigator.of(this, rootNavigator: true).pop();
  }
}

extension DoubleExtension on double {
  String roundTo2() {
    return toStringAsFixed(2);
  }
}

extension WidgetExtension on Widget {
  Widget animatedSwitch() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: this,
    );
  }
}

extension TextExtension on Text {
  Text avoidOverFlow({int maxLine = 1}) {
    return Text(
      (data ?? '').trim().replaceAll('', '\u200B'),
      style: style,
      maxLines: maxLine,
      overflow: TextOverflow.ellipsis,
    );
  }
}

extension Log on Object {
  void log({String name = ''}) => devtools.log(toString(), name: name);
}

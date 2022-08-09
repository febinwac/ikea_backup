import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/error_model.dart';
import 'helpers.dart';

class Check {
  static checkException(dynamic resp,BuildContext context,
      {Function? noCustomer,
        Function? onError,
        Function(bool val)? onAuthError}) async {
    ErrorModel errorModel = ErrorModel.fromJson(resp);
    if (errorModel.extensions != null) {
      switch (errorModel.extensions!.category) {
        case 'no-customer':
          if (noCustomer != null) noCustomer(true);
          break;
        case 'graph-input':
          Helpers.showFlushBar('${errorModel.message}',context,Icons.sms_failed_outlined);
          break;
      ///toDo: case 'graphql-authorization':
        default:
          if (errorModel.error != null &&
              errorModel.error == 'error' &&
              errorModel.message != null) {
            Helpers.showFlushBar('${errorModel.message}',context,Icons.sms_failed_outlined);
            onError!(true);
          }
      }
    }
  }

  static checkExceptionWithOutToast(dynamic resp,
      {Function? noCustomer,
        Function? onError,
        Function(bool val)? onAuthError}) async {
    ErrorModel errorModel = ErrorModel.fromJson(resp);
    if (errorModel.extensions != null) {
      switch (errorModel.extensions!.category) {
        case 'no-customer':
          if (noCustomer != null) noCustomer(true);
          break;
        case 'graph-input':
          break;
        default:
          if (errorModel.error != null &&
              errorModel.error == 'error' &&
              errorModel.message != null) {
            onError!(true);
          }
      }
    }
  }
}
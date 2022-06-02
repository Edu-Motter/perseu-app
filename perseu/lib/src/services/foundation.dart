import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

enum ResultStatus { success, error }

enum ErrorType { response, unauthorized, forbidden, networkError }

class Result<T> {
  final ResultStatus status;
  final T? data;
  final ErrorType? errorType;
  final String? message;

  bool get success => status == ResultStatus.success;
  bool get error => status == ResultStatus.error;

  const Result.success({this.data, this.message})
      : status = ResultStatus.success,
        errorType = null;
  const Result.error({this.message})
      : status = ResultStatus.error,
        errorType = ErrorType.response,
        data = null;
  const Result.unauthorized({this.message})
      : status = ResultStatus.error,
        errorType = ErrorType.unauthorized,
        data = null;
  const Result.forbidden({this.message})
      : status = ResultStatus.error,
        errorType = ErrorType.forbidden,
        data = null;
  const Result.networkError({this.message})
      : status = ResultStatus.error,
        errorType = ErrorType.networkError,
        data = null;
  const Result._cloneError({@required this.errorType, @required this.message})
      : status = ResultStatus.error,
        data = null;

  Result<O> cloneError<O>() {
    if (success) {
      throw "Success results cannot be used in cloneError";
    }
    return Result._cloneError(errorType: errorType, message: message);
  }
}

class ApiHelper {
  Future<Result<T>> process<T>(Future<Response> request,
      {required Result<T> Function(Response) onSuccess,
      required Result<T> Function(dynamic) onError,
      bool authErrors = true}) async {
    try {
      final Response? response = await request;
      assert(response != null);
      return onSuccess(response!);
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout ||
          e.type == DioErrorType.receiveTimeout ||
          e.type == DioErrorType.sendTimeout ||
          e.type == DioErrorType.other) {
        return const Result.networkError(
            message: 'Falha de conexão, tente novamente');
      } else if (authErrors &&
          e.type == DioErrorType.response &&
          e.response?.statusCode == HttpStatus.forbidden) {
        return const Result.forbidden(message: 'Acesso negado');
      } else if (authErrors &&
          e.type == DioErrorType.response &&
          e.response?.statusCode == HttpStatus.unauthorized) {
        return const Result.unauthorized(message: 'Sua sessão expirou');
      } else {
        return onError(e);
      }
    } catch (e) {
      return onError(e);
    }
  }

  Result<T> Function(dynamic) defaultErrorProcessor<T>(
      String fallbackMessage, ErrorProcessor? errorProcessor) {
    String message = fallbackMessage;
    return (dynamic error) {
      if (error is DioError) {
        final DioError dioError = error;
        if (dioError.type == DioErrorType.response && errorProcessor != null) {
          final String? processorMessage =
              errorProcessor.process(dioError.response);
          if (processorMessage != null) {
            message = processorMessage;
          }
        }
      }
      return Result.error(message: message);
    };
  }
}

abstract class ErrorProcessor {
  String process(Response<dynamic>? response);
}

class TaskStatus {
  final bool busy;
  final String status;

  const TaskStatus.busy(this.status) : busy = true;
  const TaskStatus._idle()
      : busy = false,
        status = '';
  static const TaskStatus idle = TaskStatus._idle();
}

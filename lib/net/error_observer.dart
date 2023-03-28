import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gruene_app/common/exception/bloc_exception.dart';
import 'package:gruene_app/common/logger.dart';
import 'package:gruene_app/main.dart';

class ErrorObserver extends BlocObserver {
  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    final err = error;
    if (err is BlocError) {
      if (err.expose) {
        MyApp.scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(
            content: Center(
              child: (Text(err.message)),
            ),
          ),
        );
      } else {
        logger.d('Exception in Bloc ${bloc.runtimeType} ', [err, stackTrace]);
      }
    }
    super.onError(bloc, error, stackTrace);
  }
}

import 'package:flutter/material.dart';
import 'package:gruene_app/app/auth/bloc/auth_bloc.dart';

class AuthStream extends ChangeNotifier {
  final AuthBloc authBloc;

  AuthStream(this.authBloc) {
    authBloc.authStateStream.listen((_) => notifyListeners());
  }
}

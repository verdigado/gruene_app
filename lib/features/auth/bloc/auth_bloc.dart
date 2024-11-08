import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:gruene_app/features/auth/repository/auth_repository.dart';

class AuthEvent {}

class SignInRequested extends AuthEvent {}

class SignOutRequested extends AuthEvent {}

class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {}

class Unauthenticated extends AuthState {}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  Stream<AuthState> get authStateStream => stream;

  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<SignInRequested>((event, emit) async {
      emit(AuthLoading());
      final success = await authRepository.signIn();
      if (success) {
        emit(Authenticated());
      } else {
        emit(Unauthenticated());
      }
    });

    on<SignOutRequested>((event, emit) async {
      await authRepository.signOut();
      emit(Unauthenticated());
    });
  }
}

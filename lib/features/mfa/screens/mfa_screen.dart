import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gruene_app/features/mfa/bloc/mfa_bloc.dart';
import 'package:gruene_app/features/mfa/bloc/mfa_event.dart';
import 'package:gruene_app/features/mfa/bloc/mfa_state.dart';
import 'package:gruene_app/features/mfa/widgets/intro_view.dart';
import 'package:gruene_app/features/mfa/widgets/ready_view.dart';
import 'package:gruene_app/features/mfa/widgets/verify_view.dart';

class MfaScreen extends StatelessWidget {
  const MfaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MfaBloc, MfaState>(
      listener: (context, state) {
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error!),
            ),
          );
        }
      },
      builder: (context, state) {
        switch (state.status) {
          case MfaStatus.setup:
            return const IntroView();
          case MfaStatus.ready:
            return const ReadyView();
          case MfaStatus.verify:
            return const VerifyView();
          case MfaStatus.init:
          default:
            return const _InitView();
        }
      },
    );
  }
}

class _InitView extends StatefulWidget {
  const _InitView();

  @override
  State<_InitView> createState() => _InitViewState();
}

class _InitViewState extends State<_InitView> {
  @override
  void initState() {
    super.initState();
    context.read<MfaBloc>().add(InitMfa());
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

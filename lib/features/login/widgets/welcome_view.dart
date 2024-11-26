import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gruene_app/app/auth/bloc/auth_bloc.dart';
import 'package:gruene_app/app/constants/urls.dart';
import 'package:gruene_app/app/theme/theme.dart';
import 'package:gruene_app/app/utils/open_inappbrowser.dart';
import 'package:gruene_app/i18n/translations.g.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Spacer(),
        SizedBox(
          height: 256,
          child: SvgPicture.asset('assets/graphics/login.svg'),
        ),
        Center(
          child: Text(t.login.welcome, style: theme.textTheme.displayLarge?.apply(color: ThemeColors.text)),
        ),
        Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          height: 64,
          child: FilledButton(
            onPressed: () => context.read<AuthBloc>().add(SignInRequested()),
            child: Text(t.login.loginMembers, style: theme.textTheme.titleMedium),
          ),
        ),
        // TODO #203: Uncomment for guest login
        // https://github.com/verdigado/gruene_app/issues/203
        // Container(
        //   padding: const EdgeInsets.symmetric(horizontal: 24),
        //   child: OutlinedButton(
        //     onPressed: () => {},
        //     child: Text(
        //       t.login.loginNonMembers,
        //       style: theme.textTheme.titleMedium?.apply(color: theme.colorScheme.tertiary),
        //     ),
        //   ),
        // ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () => openInAppBrowser(dataProtectionStatementUrl, context),
              child: Text(
                t.login.dataProtection,
                style: theme.textTheme.labelSmall?.apply(color: ThemeColors.textAccent),
              ),
            ),
            Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(color: theme.primaryColor, shape: BoxShape.circle),
            ),
            TextButton(
              onPressed: () => openInAppBrowser(legalNoticeUrl, context),
              child: Text(
                t.login.legalNotice,
                style: theme.textTheme.labelSmall?.apply(color: ThemeColors.textAccent),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gruene_app/routing/routes.dart';

import '../../widget/buttons/button_group.dart';

class TwoFactorApprove extends StatefulWidget {
  const TwoFactorApprove({super.key});
  final String browser = 'NA';
  final String ipAddress = 'NA';

  @override
  State<TwoFactorApprove> createState() => _TwoFactorApproveState();
}

class _TwoFactorApproveState extends State<TwoFactorApprove> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Two Factor Approval'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      'Neue Anmeldung bei',
                      style: Theme.of(context)
                          .textTheme
                          .displayLarge
                          ?.copyWith(fontSize: 34),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 40),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).primaryColor.withOpacity(0.05),
                    ),
                    child: Center(
                      child: Text(
                        'Chatbegrünung',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                      'Jemand möchte sich mit Deinem Benutzerzugang mit folgender IP-Adresse und folgendem Browser anmelden. Bist du das? Bitte bestätige es.'),
                  const SizedBox(height: 40),
                  Text('Browser: ${widget.browser}',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  // create a text widget to display the user's IP address
                  Text(
                    'Deine IP-Adresse: ${widget.ipAddress}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  TextButton(
                    onPressed: () => context.push(twofactorregistration),
                    child: const Text('Register device'),
                  ),
                ],
              ),
              ButtonGroupNextPrevious(
                nextText: 'Ja, bestätigen',
                next: () => context.go(twofactorregistration),
                previousText: 'Ablehnen',
                previous: () => context.go(twofactorregistration),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

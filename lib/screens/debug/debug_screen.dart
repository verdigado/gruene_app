import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gruene_app/constants/app_const.dart';
import 'package:gruene_app/routing/routes.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DebugScreen extends StatelessWidget {
  const DebugScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('DebugScreen'),
            TextButton(
                onPressed: () => context.push(intro),
                child: const Text('Start Intro')),
            TextButton(
                onPressed: () => context.push(notification),
                child: const Text('Push Notification')),
            TextButton(
                onPressed: () => context.push(interests),
                child: const Text('Start Customization')),
            FutureBuilder(
              future: PackageInfo.fromPlatform(),
              builder: (context, snapshot) {
                return Column(
                  children: [
                    Text(
                        'Your App Flavor is ${GruneAppData.values.flavor.name}'),
                    Text('Version: ${snapshot.data?.version}'),
                    Text('BuildNumber: ${snapshot.data?.buildNumber}')
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

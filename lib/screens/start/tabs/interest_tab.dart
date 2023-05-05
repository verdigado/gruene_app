import 'package:flutter/widgets.dart';

class InterestTab extends StatefulWidget {
  const InterestTab({super.key});

  @override
  State<InterestTab> createState() => _InterestTabState();
}

class _InterestTabState extends State<InterestTab> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Interest'),
    );
  }
}

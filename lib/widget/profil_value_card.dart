import 'package:flutter/material.dart';
import 'package:gruene_app/constants/layout.dart';
import 'package:gruene_app/constants/theme_data.dart';
import 'package:gruene_app/widget/default_switch.dart';

class ProfilValueCard extends StatelessWidget {
  final VoidCallback? onEdit;

  final String value;

  final void Function(bool)? ontoggleVisibility;

  final bool visibility;

  final String label;

  const ProfilValueCard(
      {super.key,
      required this.label,
      required this.value,
      required this.visibility,
      required this.onEdit,
      this.ontoggleVisibility});

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.all(0).copyWith(top: medium1),
        elevation: 0.6,
        borderOnForeground: true,
        child: FractionallySizedBox(
          widthFactor: 1,
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                    onPressed: () {
                      var edit = onEdit;
                      if (edit != null) {
                        edit();
                      }
                    },
                    child: const Text(
                      'Bearbeiten',
                      style: TextStyle(),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      label,
                      style: Theme.of(context)
                          .primaryTextTheme
                          .headlineMedium
                          ?.copyWith(
                              color: darkGrey,
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              height: 1.22),
                    ),
                    const SizedBox(width: small),
                    Text(
                      value,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      'Öffentlich sichtbar ',
                      style: TextStyle(),
                    ),
                    const SizedBox(
                      width: small,
                      height: large1,
                    ),
                    DefaultSwitch(
                      value: visibility,
                      onToggle: (value) {
                        final toggle = ontoggleVisibility;
                        if (toggle != null) {
                          toggle(value);
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: small,
              ),
            ],
          ),
        ));
  }
}

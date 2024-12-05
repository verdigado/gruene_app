import 'package:flutter/material.dart';
import 'package:gruene_app/app/services/nominatim_service.dart';
import 'package:gruene_app/features/campaigns/models/flyer/flyer_create_model.dart';
import 'package:gruene_app/features/campaigns/screens/doors_add_screen.dart';
import 'package:gruene_app/features/campaigns/widgets/create_address_widget.dart';
import 'package:gruene_app/features/campaigns/widgets/save_cancel_on_create_widget.dart';
import 'package:gruene_app/features/campaigns/widgets/text_input_field.dart';
import 'package:gruene_app/i18n/translations.g.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

class FlyerAddScreen extends StatefulWidget {
  final LatLng location;
  final AddressModel address;

  const FlyerAddScreen({super.key, required this.location, required this.address});

  @override
  State<FlyerAddScreen> createState() => _FlyerAddScreenState();
}

class _FlyerAddScreenState extends State<FlyerAddScreen> with AddressMixin, FlyerValidator {
  @override
  TextEditingController streetTextController = TextEditingController();
  @override
  TextEditingController houseNumberTextController = TextEditingController();
  @override
  TextEditingController zipCodeTextController = TextEditingController();
  @override
  TextEditingController cityTextController = TextEditingController();
  TextEditingController flyerCountTextController = TextEditingController();

  @override
  void dispose() {
    disposeAddressTextControllers();
    flyerCountTextController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    setAddress(widget.address);
    flyerCountTextController.text = '1';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  t.campaigns.flyer.addFlyer,
                  style: theme.textTheme.displayMedium!.apply(color: theme.colorScheme.surface),
                ),
              ),
            ],
          ),
          CreateAddressWidget(
            streetTextController: streetTextController,
            houseNumberTextController: houseNumberTextController,
            zipCodeTextController: zipCodeTextController,
            cityTextController: cityTextController,
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(),
                ),
                Flexible(
                  child: TextInputField(
                    labelText: t.campaigns.flyer.countFlyer,
                    textController: flyerCountTextController,
                    inputType: InputFieldType.numbers0To999,
                    selectAllTextOnFocus: true,
                  ),
                ),
              ],
            ),
          ),
          SaveCancelOnCreateWidget(onSave: _onSavePressed),
        ],
      ),
    );
  }

  void _onSavePressed(BuildContext localContext) {
    if (!localContext.mounted) return;
    final validationResult = validateFlyer(flyerCountTextController.text, context);
    if (validationResult == null) return;
    Navigator.maybePop(
      context,
      FlyerCreateModel(
        location: widget.location,
        address: getAddress(),
        flyerCount: validationResult.flyerCount,
      ),
    );
  }
}

mixin FlyerValidator {
  ({int flyerCount})? validateFlyer(
    String flyerCountRawValue,
    BuildContext context,
  ) {
    final flyerCount = int.tryParse(flyerCountRawValue) ?? 0;
    if (flyerCount == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.campaigns.flyer.noFlyerWarning),
        ),
      );
      return null;
    }
    return (flyerCount: flyerCount);
  }
}

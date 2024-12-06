import 'package:flutter/material.dart';
import 'package:gruene_app/app/services/nominatim_service.dart';
import 'package:gruene_app/features/campaigns/models/doors/door_create_model.dart';
import 'package:gruene_app/features/campaigns/widgets/create_address_widget.dart';
import 'package:gruene_app/features/campaigns/widgets/save_cancel_on_create_widget.dart';
import 'package:gruene_app/features/campaigns/widgets/text_input_field.dart';
import 'package:gruene_app/i18n/translations.g.dart';
import 'package:maplibre_gl_platform_interface/maplibre_gl_platform_interface.dart';

class DoorsAddScreen extends StatefulWidget {
  final LatLng location;
  final AddressModel address;

  const DoorsAddScreen({super.key, required this.location, required this.address});

  @override
  State<StatefulWidget> createState() => DoorsAddScreenState();
}

class DoorsAddScreenState extends State<DoorsAddScreen> with AddressMixin, DoorValidator {
  @override
  TextEditingController streetTextController = TextEditingController();
  @override
  TextEditingController houseNumberTextController = TextEditingController();
  @override
  TextEditingController zipCodeTextController = TextEditingController();
  @override
  TextEditingController cityTextController = TextEditingController();
  TextEditingController openedDoorTextController = TextEditingController();
  TextEditingController closedDoorTextController = TextEditingController();

  @override
  void dispose() {
    disposeAddressTextControllers();
    openedDoorTextController.dispose();
    closedDoorTextController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    setAddress(widget.address);
    openedDoorTextController.text = '1';
    closedDoorTextController.text = '0';
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
                  t.campaigns.door.addDoor,
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
                Flexible(
                  child: Text(
                    t.campaigns.door.createDoor.hint,
                    style: theme.textTheme.labelMedium?.apply(color: theme.colorScheme.surface),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                Flexible(
                  child: Container(
                    padding: EdgeInsets.only(right: 6),
                    child: TextInputField(
                      labelText: t.campaigns.door.closedDoors,
                      textController: closedDoorTextController,
                      inputType: InputFieldType.numbers0To999,
                      selectAllTextOnFocus: true,
                    ),
                  ),
                ),
                Flexible(
                  child: TextInputField(
                    labelText: t.campaigns.door.openedDoors,
                    textController: openedDoorTextController,
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
    final validationResult = validateDoors(openedDoorTextController.text, closedDoorTextController.text, context);
    if (validationResult == null) return;
    Navigator.maybePop(
      context,
      DoorCreateModel(
        location: widget.location,
        address: getAddress(),
        openedDoors: validationResult.openedDoors,
        closedDoors: validationResult.closedDoors,
      ),
    );
  }
}

mixin DoorValidator {
  ({int closedDoors, int openedDoors})? validateDoors(
    String openedDoorsRawValue,
    String closedDoorsRawValue,
    BuildContext context,
  ) {
    final openedDoors = int.tryParse(openedDoorsRawValue) ?? 0;
    final closedDoors = int.tryParse(closedDoorsRawValue) ?? 0;
    if (openedDoors + closedDoors == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.campaigns.door.noDoorsWarning),
        ),
      );
      return null;
    }
    return (closedDoors: closedDoors, openedDoors: openedDoors);
  }
}

mixin AddressMixin {
  abstract TextEditingController streetTextController;
  abstract TextEditingController houseNumberTextController;
  abstract TextEditingController zipCodeTextController;
  abstract TextEditingController cityTextController;

  void disposeAddressTextControllers() {
    streetTextController.dispose();
    houseNumberTextController.dispose();
    zipCodeTextController.dispose();
    cityTextController.dispose();
  }

  AddressModel getAddress() {
    return AddressModel(
      street: streetTextController.text,
      houseNumber: houseNumberTextController.text,
      zipCode: zipCodeTextController.text,
      city: cityTextController.text,
    );
  }

  void setAddress(AddressModel address) {
    streetTextController.text = address.street;
    houseNumberTextController.text = address.houseNumber;
    zipCodeTextController.text = address.zipCode;
    cityTextController.text = address.city;
  }
}

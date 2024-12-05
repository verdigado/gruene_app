import 'package:flutter/material.dart';
import 'package:gruene_app/app/theme/theme.dart';
import 'package:gruene_app/features/campaigns/models/doors/door_detail_model.dart';
import 'package:gruene_app/features/campaigns/models/doors/door_update_model.dart';
import 'package:gruene_app/features/campaigns/screens/doors_add_screen.dart';
import 'package:gruene_app/features/campaigns/screens/map_consumer.dart';
import 'package:gruene_app/features/campaigns/widgets/close_save_widget.dart';
import 'package:gruene_app/features/campaigns/widgets/create_address_widget.dart';
import 'package:gruene_app/features/campaigns/widgets/delete_and_save_widget.dart';
import 'package:gruene_app/features/campaigns/widgets/text_input_field.dart';
import 'package:gruene_app/i18n/translations.g.dart';

typedef OnSaveDoorCallback = void Function(DoorUpdateModel doorUpdate);

class DoorEdit extends StatefulWidget {
  final DoorDetailModel door;
  final OnSaveDoorCallback onSave;
  final OnDeletePoiCallback onDelete;

  const DoorEdit({
    super.key,
    required this.door,
    required this.onSave,
    required this.onDelete,
  });

  @override
  State<DoorEdit> createState() => _DoorEditState();
}

class _DoorEditState extends State<DoorEdit> with AddressMixin, DoorValidator, ConfirmDelete {
  @override
  TextEditingController streetTextController = TextEditingController();
  @override
  TextEditingController houseNumberTextController = TextEditingController();
  @override
  TextEditingController zipCodeTextController = TextEditingController();
  @override
  TextEditingController cityTextController = TextEditingController();

  TextEditingController closedDoorTextController = TextEditingController();

  TextEditingController openedDoorTextController = TextEditingController();

  @override
  void dispose() {
    disposeAddressTextControllers();
    super.dispose();
  }

  @override
  void initState() {
    streetTextController.text = widget.door.street;
    houseNumberTextController.text = widget.door.houseNumber;
    zipCodeTextController.text = widget.door.zipCode;
    cityTextController.text = widget.door.city;
    openedDoorTextController.text = widget.door.openedDoors.toString();
    closedDoorTextController.text = widget.door.closedDoors.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lightBorderColor = ThemeColors.textLight;
    return Container(
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 6),
            child: CloseSaveWidget(onSave: _saveDoor, onClose: _closeDialog),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [Text(t.campaigns.door.editDoor, style: theme.textTheme.titleLarge)],
            ),
          ),
          CreateAddressWidget(
            streetTextController: streetTextController,
            houseNumberTextController: houseNumberTextController,
            zipCodeTextController: zipCodeTextController,
            cityTextController: cityTextController,
            inputBorderColor: lightBorderColor,
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
                      borderColor: lightBorderColor,
                      selectAllTextOnFocus: true,
                    ),
                  ),
                ),
                Flexible(
                  child: TextInputField(
                    labelText: t.campaigns.door.openedDoors,
                    textController: openedDoorTextController,
                    inputType: InputFieldType.numbers0To999,
                    borderColor: lightBorderColor,
                    selectAllTextOnFocus: true,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 6, bottom: 24),
            child: DeleteAndSaveWidget(
              onDelete: () => confirmDelete(context, _onDeletePressed),
              onSave: _saveDoor,
            ),
          ),
        ],
      ),
    );
  }

  void _closeDialog() {
    Navigator.maybePop(context);
  }

  void _onDeletePressed() {
    widget.onDelete(widget.door.id);
    _closeDialog();
  }

  void _saveDoor() {
    if (!context.mounted) return;
    final validationResult = validateDoors(openedDoorTextController.text, closedDoorTextController.text, context);
    if (validationResult == null) return;

    final updateModel = DoorUpdateModel(
      id: widget.door.id,
      address: getAddress(),
      openedDoors: validationResult.openedDoors,
      closedDoors: validationResult.closedDoors,
    );
    widget.onSave(updateModel);
    _closeDialog();
  }
}

mixin ConfirmDelete {
  void confirmDelete(BuildContext context, void Function() onDeletePressed) async {
    final theme = Theme.of(context);
    final shouldDelete = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: ThemeColors.alertBackground,
          title: Center(
            child: Text(
              '${t.campaigns.deleteEntry.label}?',
              style: theme.textTheme.titleMedium?.apply(color: theme.colorScheme.surface),
            ),
          ),
          content: Text(
            t.campaigns.deleteEntry.confirmation_dialog,
            textAlign: TextAlign.center,
            style: theme.textTheme.labelMedium?.apply(
              color: theme.colorScheme.surface,
              fontSizeDelta: 1,
            ),
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            TextButton(
              onPressed: () => Navigator.maybePop(context, false),
              child: Text(
                t.common.actions.cancel,
                style: theme.textTheme.labelLarge?.apply(color: ThemeColors.textCancel),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.maybePop(context, true),
              child: Text(
                t.common.actions.delete,
                style: theme.textTheme.labelLarge?.apply(
                  color: ThemeColors.textWarning,
                  fontWeightDelta: 2,
                ),
              ),
            ),
          ],
        );
      },
    );
    if (shouldDelete ?? false) {
      onDeletePressed();
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:gruene_app/gen/assets.gen.dart';
import 'package:gruene_app/widget/modal_top_line.dart';

class ProfileDetailScreen extends StatelessWidget {
  const ProfileDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Padding(
            padding: const EdgeInsets.only(left: 16.0, bottom: 8, top: 8),
            child: Column(
              children: [
                Text(
                  'Profil',
                  style: Theme.of(context).primaryTextTheme.displaySmall,
                ),
                InkWell(
                  onTap: () => openImagePickerModal(context),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage(Assets.images.download.path),
                    child: const Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.edit),
                        )),
                  ),
                ),
              ],
            )));
  }

  openImagePickerModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return LayoutBuilder(
          builder: (ctx, con) {
            return SizedBox(
              height: con.maxHeight / 100 * 45,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const ModalTopLine(color: Colors.grey),
                    InkWell(
                      onTap: () => print('Bib'),
                      child: Row(
                        children: const [
                          Icon(Icons.camera_alt_outlined),
                          SizedBox(
                            width: 8,
                          ),
                          Text('Foto Aufnehmen')
                        ],
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () => print('Bib'),
                      child: Row(
                        children: const [
                          Icon(Icons.image_outlined),
                          SizedBox(
                            width: 8,
                          ),
                          Text('Aus der Bibliothek auswählen')
                        ],
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () => print('Bib'),
                      child: Row(
                        children: const [
                          Icon(Icons.delete_outline),
                          SizedBox(
                            width: 8,
                          ),
                          Text('Profilbild löschen')
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

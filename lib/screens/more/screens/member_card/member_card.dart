import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gruene_app/common/utils/avatar_utils.dart';
import 'package:gruene_app/constants/layout.dart';
import 'package:gruene_app/net/profile/bloc/profile_bloc.dart';
import 'package:gruene_app/net/profile/data/profile.dart';
import 'package:no_screenshot/no_screenshot.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:vector_graphics/vector_graphics.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:gruene_app/common/logger.dart';
import 'package:gruene_app/gen/assets.gen.dart';

const mockModel = MemberCardModel(
    divison: 'Kreisverband',
    givenname: 'Rosenberg',
    surename: 'Rosa',
    memberId: '1000345');

class MemberCardScreen extends StatefulWidget {
  const MemberCardScreen({super.key});

  @override
  State<MemberCardScreen> createState() => _MemberCardScreenState();
}

class _MemberCardScreenState extends State<MemberCardScreen>
    with WidgetsBindingObserver {
  final _noScreenshot = NoScreenshot.instance;
  @override
  void initState() {
    setBrightness(1.0);
    _noScreenshot.screenshotOff();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.membercardTitel),
        elevation: 0,
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          return InkWell(
            onLongPress: () {
              context.pushTransparentRoute(
                MemberCardFullScreenView(
                  card: MemberCard(cardModel: state.profile),
                ),
              );
            },
            onTap: () {
              context.pushTransparentRoute(
                MemberCardFullScreenView(
                  card: MemberCard(cardModel: state.profile),
                ),
              );
            },
            child: MemberCard(
              cardModel: state.profile,
            ),
          );
        },
      ),
    );
  }

  @override
  dispose() {
    resetBrightness();
    WidgetsBinding.instance.removeObserver(this);
    _noScreenshot.screenshotOn();
    super.dispose();
  }

  Future<void> setBrightness(double brightness) async {
    try {
      await ScreenBrightness().setScreenBrightness(brightness);
    } catch (e) {
      logger.d('Failed to set brightness', [e]);
    }
  }

  Future<void> resetBrightness() async {
    try {
      await ScreenBrightness().resetScreenBrightness();
    } catch (e) {
      logger.d('Failed to reset brightness', [e]);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      _noScreenshot.screenshotOff();
    }
    if (state == AppLifecycleState.detached) {
      _noScreenshot.screenshotOn();
    }
    super.didChangeAppLifecycleState(state);
  }
}

class MemberCardFullScreenView extends StatelessWidget {
  final MemberCard card;

  const MemberCardFullScreenView({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: DismissiblePage(
        direction: DismissiblePageDismissDirection.multi,
        backgroundColor: Colors.white,
        onDismissed: () => context.pop(),
        child: SafeArea(
          child: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: card,
          ),
        ),
      ),
    );
  }
}

class MemberCardModel {
  final String surename;
  final String givenname;
  final String memberId;
  final String divison;
  const MemberCardModel({
    required this.surename,
    required this.givenname,
    required this.memberId,
    required this.divison,
  });
}

class MemberCard extends StatelessWidget {
  final double cardPadding;

  final Profile cardModel;

  const MemberCard({
    super.key,
    this.cardPadding = 18.0,
    required this.cardModel,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, con) {
      return Padding(
        padding: EdgeInsets.all(cardPadding),
        child: Container(
          decoration: const BoxDecoration(boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.4),
              offset: Offset(0, 4),
              blurRadius: 10,
            ),
          ]),
          child: ClipRRect(
            clipBehavior: Clip.antiAlias,
            borderRadius: BorderRadius.circular(10.0),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xff19B457),
                    Color(0xff145F31),
                  ],
                  stops: [
                    0.3076,
                    1.1029,
                  ],
                  transform: GradientRotation(2.085),
                ),
              ),
              child: Stack(
                fit: StackFit.passthrough,
                children: [
                  Positioned(
                    top: -con.maxHeight * 0.15,
                    left: -con.maxWidth * 0.3,
                    child: CircleAvatar(
                      radius: con.maxHeight * 0.4,
                      backgroundColor: const Color(0xff19B457),
                    ),
                  ),
                  Positioned(
                    top: con.maxHeight * 0.1,
                    left: con.maxWidth * 0.2,
                    child: CircleAvatar(
                      radius: con.maxHeight * 0.7,
                      backgroundColor: const Color.fromARGB(161, 5, 129, 55),
                    ),
                  ),
                  Positioned(
                    top: -con.maxHeight * 0.2,
                    left: -con.maxWidth * 0.1,
                    child: CircleAvatar(
                      radius: con.maxHeight * 0.35,
                      backgroundColor:
                          Theme.of(context).primaryColor.withOpacity(0.6),
                    ),
                  ),
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(
                            medium1,
                            medium3,
                            medium1,
                            medium1,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.membercard,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                  ),
                                  Text(
                                    cardModel.memberProfil.surname,
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall
                                        ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    cardModel.memberProfil.givenName,
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall
                                        ?.copyWith(
                                            height: 0.85,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: medium1,
                                  ),
                                  Text(
                                    cardModel.memberProfil.division,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                  ),
                                ],
                              ),
                              if (cardModel.profileImageUrl != null &&
                                  cardModel.profileImageUrl!.isNotEmpty) ...[
                                CircleAvatarImage(
                                  imageUrl: cardModel.profileImageUrl,
                                  editable: false,
                                )
                              ],
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0)
                              .copyWith(bottom: medium1, right: medium1),
                          child: Row(
                            children: [
                              RotatedBox(
                                quarterTurns:
                                    3, // specify the number of quarter turns (90 degrees)
                                child: Row(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: medium1),
                                      child: SvgPicture(AssetBytesLoader(
                                          Assets.images.sunflowerWhiteSvg)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          medium1, small, small, small),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "BÜNDNIS 90/DIE GRÜNEN:",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(color: Colors.white),
                                          ),
                                          Text(
                                            AppLocalizations.of(context)!
                                                .memberId,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(color: Colors.white),
                                          ),
                                          Text(
                                            cardModel.memberProfil.memberId,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              Container(
                                height: 200,
                                width: 200,
                                padding: const EdgeInsets.all(small),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12.0),
                                  ),
                                ),
                                child: QrImage(
                                  backgroundColor: Colors.white,
                                  data: cardModel.memberProfil.memberId,
                                  version: QrVersions.auto,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

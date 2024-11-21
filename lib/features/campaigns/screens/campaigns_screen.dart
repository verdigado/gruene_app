import 'package:flutter/material.dart';
import 'package:gruene_app/app/theme/theme.dart';
import 'package:gruene_app/features/campaigns/screens/doors_screen.dart';
import 'package:gruene_app/features/campaigns/screens/flyer_screen.dart';
import 'package:gruene_app/features/campaigns/screens/google_map_demo.dart';
import 'package:gruene_app/features/campaigns/screens/posters_screen.dart';
import 'package:gruene_app/features/campaigns/screens/statistics_screen.dart';
import 'package:gruene_app/features/campaigns/screens/teams_screen.dart';
import 'package:gruene_app/i18n/translations.g.dart';

class CampaignsScreen extends StatefulWidget {
  CampaignsScreen({super.key});
  @override
  State<CampaignsScreen> createState() => _CampaignsScreen();
}

class _CampaignsScreen extends State<CampaignsScreen> with SingleTickerProviderStateMixin {
  final List<CampaignMenuModel> campaignTabs = <CampaignMenuModel>[
    CampaignMenuModel(t.campaigns.door.label, true, DoorsScreen()),
    CampaignMenuModel(t.campaigns.posters.label, true, PostersScreen()),
    CampaignMenuModel(t.campaigns.flyer.label, true, FlyerScreen()),
    CampaignMenuModel('GoogleMap', true, GoogleMapDemo()),
    CampaignMenuModel(t.campaigns.team.label, false, TeamsScreen()),
    CampaignMenuModel(t.campaigns.statistic.label, false, StatisticsScreen()),
  ];
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: campaignTabs.length, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  void onTap(int index) {
    setState(() {
      _tabController.index = !campaignTabs[index]._enabled ? _tabController.previousIndex : index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: campaignTabs.length,
      child: Scaffold(
        backgroundColor: ThemeColors.background,
        appBar: AppBar(
          shape: Border(bottom: BorderSide(color: ThemeColors.textLight, width: 2)),
          toolbarHeight: 0,
          backgroundColor: ThemeColors.backgroundSecondary,
          bottom: TabBar(
            controller: _tabController,
            tabs: campaignTabs
                .map(
                  (CampaignMenuModel item) => Tab(
                    child: Semantics(
                      child: Text(
                        item._tabTitle,
                        style: item._enabled ? null : TextStyle(color: ThemeColors.textDisabled),
                      ),
                    ),
                  ),
                )
                .toList(),
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            indicatorWeight: 4,
            onTap: (int index) => onTap(index),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          physics: NeverScrollableScrollPhysics(),
          children: campaignTabs.map((CampaignMenuModel tab) {
            return tab._view;
          }).toList(),
        ),
      ),
    );
  }
}

class CampaignMenuModel {
  final String _tabTitle;
  final bool _enabled;
  final Widget _view;

  const CampaignMenuModel(this._tabTitle, this._enabled, this._view);
}

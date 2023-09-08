import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kwantapo/services/lib.dart';
import 'package:kwantapo/ui/views/SyncButtton.dart';
import 'package:kwantapo/utils/AppSpaces.dart';
import 'package:kwantapo/utils/lib.dart';

class KitchenSMAppBar extends StatefulWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const KitchenSMAppBar({
    Key? key,
    @required this.scaffoldKey,
  }) : super(key: key);

  @override
  _KitchenSMAppBarState createState() => _KitchenSMAppBarState();

  @override
  Size get preferredSize => const CupertinoNavigationBar().preferredSize;
}

class _KitchenSMAppBarState extends State<KitchenSMAppBar> {

  GlobalKey<ScaffoldState>? _scaffoldKey;

  @override
  void initState() {
    _scaffoldKey = widget.scaffoldKey;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoNavigationBar(
      backgroundColor: AppTheme.colorPrimary,
      brightness: Brightness.light,
      leading: _buildTitle(context),
      middle: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Spacer(),
          SyncButton(),
        ],
      ),
      trailing: _buildActions(),
    );
  }

  Widget _buildTitle(BuildContext context) => InkWell(
        onTap: () => _scaffoldKey?.currentState?.openDrawer(),
        child: Container(
          alignment: Alignment.centerLeft,
          child: Text(
            AppConstants().APP_NAME,
            style: TextStyles().titleStyle(),
            maxLines: 1,
            textAlign: TextAlign.left,
          ),
        ),
      );


  Widget _buildActions() => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      PopupMenuButton(
          onSelected: (index) {
            switch(index){
              case 0:
                NavigationService.getInstance.settingsActivity();
              break;
            }
          },
          icon: const Icon(
            Icons.more_vert_outlined,
            color: AppTheme.nearlyWhite,
          ),
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                  value: 0,
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Container(
                        margin: AppSpaces().smallRight,
                        child: const Text("Settings"),
                      ),),
                      const Icon(Icons.settings_outlined,
                          color: AppTheme.nearlyBlack, size: 20.0,)
                    ],
                  ),
              ),
            ];
          },)
    ],
  );

}

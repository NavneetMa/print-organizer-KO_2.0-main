import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kwantapo/controllers/lib.dart';
import 'package:kwantapo/lang/lib.dart';
import 'package:kwantapo/services/lib.dart';
import 'package:kwantapo/ui/lib.dart';
import 'package:kwantapo/utils/AppSpaces.dart';
import 'package:kwantapo/utils/lib.dart';

class MainAppBar extends StatefulWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final KOTController? controller;

  const MainAppBar({
    Key? key,
    @required this.scaffoldKey,
    @required this.controller,
  }) : super(key: key);

  @override
  _MainAppBarState createState() => _MainAppBarState();

  @override
  Size get preferredSize => const CupertinoNavigationBar().preferredSize;
}

class _MainAppBarState extends State<MainAppBar> implements ISearchListener {
  TextEditingController? _searchQueryController;
  bool _isSearching = false;
  GlobalKey<ScaffoldState>? _scaffoldKey;
  FocusNode? _searchFocus;

  @override
  void initState() {
    _searchQueryController = TextEditingController();
    _scaffoldKey = widget.scaffoldKey;
    _searchFocus = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoNavigationBar(
      backgroundColor: AppTheme.colorPrimary,
      brightness: Brightness.light,
      leading: _isSearching ? _buildSearchField() : _buildTitle(context),
      trailing: _buildActions(widget.controller!),
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

  Widget _buildSearchField() {
    _searchFocus?.requestFocus();
    return TextField(
      controller: _searchQueryController,
      autofocus: true,
      focusNode: _searchFocus,
      cursorColor: AppTheme.nearlyWhite,
      decoration: InputDecoration(
        hintText: AppLocalization.instance.translate("search"),
        border: InputBorder.none,
        hintStyle: TextStyles().hintStyle(),
      ),
      style: TextStyles().inputValueStyleWhite(),
      onChanged: updateSearchQuery,
    );
  }

  @override
  void updateSearchQuery(String newQuery) {
    newQuery != "" ? widget.controller?.searchFromList(newQuery) : widget.controller?.getKOTList();
  }

  Widget _buildActions(KOTController controller) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      if (_isSearching) IconButton(
        icon: const Icon(
            Icons.clear,
            color: AppTheme.nearlyWhite,
            size: 20.0,
        ),
        onPressed: () {
                if (_searchQueryController!.text.isEmpty) {
                  NavigationService.getInstance.goBack();
                  clearSearchQuery();
                  return;
                }
              },
      ) else IconButton(
        icon: const Icon(
            Icons.search,
            color: AppTheme.nearlyWhite,
            size: 20.0,),
        onPressed: startSearch,
      ),
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

  @override
  void clearSearchQuery() {
    if (_searchQueryController!.text.isNotEmpty) {
      setState(() {
        _searchQueryController?.clear();
        updateSearchQuery("Search query");
      });
      widget.controller?.getKOTList();
    }
  }

  @override
  void startSearch() {
    ModalRoute.of(context)?.addLocalHistoryEntry(LocalHistoryEntry(onRemove: stopSearch));
    setState(() {
      _isSearching = true;
    });
  }

  @override
  void stopSearch() {
    clearSearchQuery();
    setState(() {
      _isSearching = false;
    });
  }
}

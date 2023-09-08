import 'package:flutter/material.dart';
import 'package:kwantapo/ui/activities/model/ModeSelectionModel.dart';
import 'package:kwantapo/utils/AppSpaces.dart';
import 'package:kwantapo/utils/lib.dart';

class ModeSelectionScreen extends StatefulWidget {
  @override
  _ModeSelectionScreenState createState() => _ModeSelectionScreenState();
}

class _ModeSelectionScreenState extends State<ModeSelectionScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Container(
              margin: AppSpaces().largeTop,
              child: Column(
                children: [
                  DropdownButton<String>(
                    value: AppConstants.selectedMode, //SELECT_MODE,
                    onChanged: (value) {
                      setState(() {
                        AppConstants.selectedMode = value!;
                      });
                    },
                    items:  const [
                      DropdownMenuItem<String>(
                        value:  AppConstants.SELECT_MODE,
                        child: Text('Select Mode'),
                      ),
                      DropdownMenuItem<String>(
                        value: AppConstants.KITCHEN_MODE,
                        child: Text('Kitchen Mode'),
                      ),
                      DropdownMenuItem<String>(
                        value: AppConstants.KITCHEN_SUM_MODE,
                        child: Text('Kitchen Sum Mode'),
                      ),
                      /*DropdownMenuItem<String>(
                        child: Text('Waiter Mode'),
                        value: AppConstants.WAITER_MODE,
                      ),*/
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 70),
            Container(
              margin: AppSpaces().mediumTop,
              child: ElevatedButton(
                child: const Text('Proceed'),
                onPressed: () {
                  if (AppConstants.selectedMode == AppConstants.SELECT_MODE || AppConstants.selectedMode == "") {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Select'),
                          content: const Text('Please select any one option'),
                          actions: [
                            ElevatedButton(
                              child: const Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            )
                          ],
                        );
                      },
                    );
                  }
                  else{
                    ModeSelectionModel.getInstance.saveSelectedMode();
                    ModeSelectionModel.getInstance.updateFirstLaunchFlag();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );

  }

  // Future<void> _saveSelectedMode() async {
  //   await PrefUtils().setSaveSelectedMode(AppConstants.selectedMode);
  //   if(AppConstants.selectedMode == AppConstants.KITCHEN_SUM_MODE){
  //     AppConstants.sumMode=true;
  //     await PrefUtils().setSumMode(true);
  //     NavigationService.getInstance.kitchenSMDashboardActivityFromAll();
  //   } else {
  //     NavigationService.getInstance.dashboardActivityFromAll();
  //   }
  // }

  // Future<void> _updateFirstLaunchFlag() async {
  //   await PrefUtils().setUpdateFirstFlag(false);
  // }
}

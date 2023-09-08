import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:kwantapo/controllers/lib.dart';
import 'package:kwantapo/services/lib.dart';
import 'package:kwantapo/utils/AppSpaces.dart';
import 'package:kwantapo/utils/lib.dart';

class FilterView extends StatefulWidget {
  @override
  State<FilterView> createState() => _FilterViewState();
}

class _FilterViewState extends State<FilterView> {
  T _ambiguate<T>(T value) => value;
  final _filterController = Get.find<FilterController>();

  @override
  void initState() {
    super.initState();
    _ambiguate(SchedulerBinding.instance).addPostFrameCallback((_) => _filterController.getFilter());
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Flex(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  direction: Axis.horizontal,
                  children: _filterController.userNames
                      .map((e) => Container(
                            margin: AppSpaces().smallHorizontal,
                            child: TextButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      e.isSelected
                                          ? AppTheme.red
                                          : AppTheme.yellow,),),
                              onPressed: () {
                                e.isSelected = !e.isSelected;
                                _filterController.userNames.refresh();
                                DataService.getInstance.filterKot();
                              },
                              child: Text(
                                e.name,
                                style: const TextStyle(color: AppTheme.black),
                              ),
                            ),
                          ),)
                      .toList(),
                    ),
                ),
              ),
              const Divider(
                thickness: 1,
              ),
              SizedBox(
                width: double.infinity,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Flex(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    direction: Axis.horizontal,
                    children: _filterController.tableNames
                        .map((e) => Container(
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              child: TextButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        e.isSelected
                                            ? AppTheme.red
                                            : AppTheme.yellow,),),
                                onPressed: () {
                                  e.isSelected = !e.isSelected;
                                  _filterController.tableNames.refresh();
                                  DataService.getInstance.filterKot();
                                },
                                child: Text(
                                  e.name,
                                  style: const TextStyle(color: AppTheme.black),
                                ),
                              ),
                            ),)
                        .toList(),
                  ),
                ),
              )
            ],
          ),
        ),);
  }
}

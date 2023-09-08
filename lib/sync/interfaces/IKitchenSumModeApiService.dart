import 'package:dio/dio.dart';
import 'package:kwantapo/sync/lib.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';

part 'IKitchenSumModeApiService.g.dart';

@RestApi()
abstract class IKitchenSumModeApiService {

  factory IKitchenSumModeApiService(Dio dio, {String baseUrl}) = _IKitchenSumModeApiService;

  @POST(SyncAPI.KITCHEN_SUM_MODE_API + SyncMethods.SEND_KOT_TOKITCHEN_SUM_MODE)
  Future<dynamic> sendKotToKitchenSumMode({
    @Field("data") String? data,
    @Field("methodName") String? methodName,
  });

  @POST(SyncAPI.KITCHEN_SUM_MODE_API + SyncMethods.HIDE_KOT_ONKOT_SNOOZETIMEADDED)
  Future<dynamic> hideKotOnKOTSnoozeTimeAdded({
    @Field("data") String? data,
    @Field("methodName") String? methodName,
  });

  @POST(SyncAPI.KITCHEN_SUM_MODE_API + SyncMethods.RESET_HIDDEN_KOT)
  Future<dynamic> resetHiddenKot({
    @Field("data") String? data,
    @Field("methodName") String? methodName,
  });

  @POST(SyncAPI.KITCHEN_SUM_MODE_API + SyncMethods.SHOW_KOT_AFTER_SNOOZETIME_ISOVER)
  Future<dynamic> showKotAfterSnoozeTimeIsOver({
    @Field("data") String? data,
    @Field("methodName") String? methodName,
  });

  @POST(SyncAPI.KITCHEN_SUM_MODE_API + SyncMethods.REMOVE_ITEM_FROM_SUM)
  Future<dynamic> removeItemFromSum({
    @Field("data") String? data,
    @Field("methodName") String? methodName,
  });

  @POST(SyncAPI.KITCHEN_SUM_MODE_API + SyncMethods.REMOVE_ITEM_FROM_KOT)
  Future<dynamic> removeItemFromKot({
    @Field("data") String? data,
    @Field("methodName") String? methodName,
  });

  @POST(SyncAPI.KITCHEN_SUM_MODE_API + SyncMethods.DELETE_KOT)
  Future<dynamic> deleteKot({
    @Field("data") String? data,
    @Field("methodName") String? methodName,
  });

  @POST(SyncAPI.KITCHEN_SUM_MODE_API + SyncMethods.DISMISS_KOT)
  Future<dynamic> dismissKot({
    @Field("data") String? data,
    @Field("methodName") String? methodName,
  });

  @POST(SyncAPI.KITCHEN_SUM_MODE_API + SyncMethods.ADD_UNDO_KOT)
  Future<dynamic> addUndoKotItem({
    @Field("data") String? data,
    @Field("methodName") String? methodName,
  });

}
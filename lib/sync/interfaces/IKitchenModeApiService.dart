import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:kwantapo/sync/lib.dart';
part 'IKitchenModeApiService.g.dart';

@RestApi()
abstract class IKitchenModeApiService {

  factory IKitchenModeApiService(Dio dio, {String baseUrl}) = _IKitchenModeApiService;

  @POST(SyncAPI.KITCHEN_MODE_API + SyncMethods.GET_ALL_KOT_DATA)
  Future<dynamic> getAllKotData({
    @Field("data") String? data,
    @Field("methodName") String? methodName,
  });

  @POST(SyncAPI.KITCHEN_MODE_API + SyncMethods.GET_SNOOZED_KOT_DATA )
  Future<dynamic> getSnoozedKotData({
    @Field("data") String? data,
    @Field("methodName") String? methodName,
  });

}
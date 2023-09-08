import 'package:dio/dio.dart';
import 'package:kwantapo/sync/lib.dart';
import 'package:retrofit/retrofit.dart';

part 'IKassaService.g.dart';

@RestApi()
abstract class IKassaService {

  factory IKassaService(Dio dio, {String baseUrl}) = _IKassaService;

  @POST(SyncAPI.KASSA_PO + SyncMethods.SEND_RECEIVED_KOT)
  Future<HttpResponse> sendReceivedKot({
    @Field("currentTimestamp") String? currentTimestamp,
    @Field("tableName") String? tableName,
    @Field("userName") String? userName,
    @Field("receivedTimestamp") String? receivedTimestamp,
    @Field("noOfItems") int? noOfItems,
    @Field("ipAddress") String? ipAddress,
  });


  @POST(SyncAPI.KASSA_PO + SyncMethods.SEND_FINISHED_KOT)
  Future<HttpResponse> sendFinishedKot({
    @Field("currentTimestamp") String? currentTimestamp,
    @Field("tableName") String? tableName,
    @Field("userName") String? userName,
    @Field("receivedTimestamp") String? receivedTimestamp,
    @Field("finishedTimestamp") String? finishedTimestamp,
    @Field("durationTillFinished") String? durationTillFinished,
    @Field("noOfItems") int? noOfItems,
    @Field("category") String? category,
    @Field("ipAddress") String? ipAddress,
  });

}
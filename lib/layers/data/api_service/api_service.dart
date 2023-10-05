import '../../../commons/network/api_manager/api_manager.dart';
import '../../domain/entities/query_params.dart';

abstract class APIService<RESPONSE_TYPE, BODY_TYPE, CREATE_RESPONSE,
    UPDATE_RESPONSE, DELETE_RESPONSE> {
  final apiManager = APIManager.getInstance("http://localhost.com/");
  final String endpoint;
  APIService({required this.endpoint});

  Future<ApiManagerResponse<List<RESPONSE_TYPE>>> getAll({
    QueryParams? params,
    String? endpoint,
  }) async {
    final query = params != null ? "?${params.toString()}" : "";
    final res = await apiManager.makeRequest(
      endpoint: "${endpoint ?? this.endpoint}$query",
      requestType: RequestType.get,
    );
    if (res.isSuccess) {
      final data = fromJsonList(res.data);
      return res.copyWith(data: data);
    } else {
      return res.copyWith(data: []);
    }
  }

  Future<ApiManagerResponse<RESPONSE_TYPE>> getOne(String id) async {
    final res = await apiManager.makeRequest(
      endpoint: "$endpoint/$id",
      requestType: RequestType.get,
    );
    if (res.isSuccess) {
      final data = fromJson(res.data);
      return res.copyWith(data: data);
    } else {
      return res.copyWith(data: null);
    }
  }

  Future<ApiManagerResponse<CREATE_RESPONSE>> create(BODY_TYPE data) async {
    final res = await apiManager.makeRequest(
      endpoint: endpoint,
      body: (data as dynamic).toJson(),
      requestType: RequestType.create,
    );
    if (res.isSuccess) {
      final data = fromCreate<CREATE_RESPONSE>(res.data);
      return res.copyWith(data: data);
    } else {
      return res.copyWith(data: null);
    }
  }

  Future<ApiManagerResponse<DELETE_RESPONSE>> delete(String id) async {
    final res = await apiManager.makeRequest(
      endpoint: "$endpoint/$id",
      requestType: RequestType.delete,
    );
    if (res.isSuccess) {
      final data = fromDelete<DELETE_RESPONSE>(res.data);
      return res.copyWith(data: data);
    } else {
      return res.copyWith(data: null);
    }
  }

  Future<ApiManagerResponse<UPDATE_RESPONSE>> update(
      String id, BODY_TYPE data) async {
    final res = await apiManager.makeRequest(
      endpoint: endpoint,
      body: (data as dynamic).toJson(),
      requestType: RequestType.update,
    );
    if (res.isSuccess) {
      final data = fromUpdate<UPDATE_RESPONSE>(res.data);
      return res.copyWith(data: data);
    } else {
      return res.copyWith(data: null);
    }
  }

  List<RESPONSE_TYPE> fromJsonList(json);
  RESPONSE_TYPE fromJson(json);
  T fromCreate<T>(json);
  T fromUpdate<T>(json);
  T fromDelete<T>(json);
}

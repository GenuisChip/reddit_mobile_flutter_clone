class ApiManagerResponse<T> {
  final String? serverErrorMsg;
  final String? rawData;
  final int statusCode;
  final String? error;
  final bool isSuccess;
  final T? data;

  ApiManagerResponse({
    required this.serverErrorMsg,
    required this.statusCode,
    required this.isSuccess,
    required this.rawData,
    required this.error,
    required this.data,
  });

  ApiManagerResponse<Type> copyWith<Type>({
    String? serverErrorMsg,
    String? rawData,
    int? statusCode,
    String? error,
    bool? isSuccess,
    required Type? data,
  }) {
    return ApiManagerResponse<Type>(
      serverErrorMsg: serverErrorMsg ?? this.serverErrorMsg,
      rawData: rawData ?? this.rawData,
      statusCode: statusCode ?? this.statusCode,
      error: error ?? this.error,
      isSuccess: isSuccess ?? this.isSuccess,
      data: data,
    );
  }
}

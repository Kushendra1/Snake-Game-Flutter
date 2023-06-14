enum AppStatusCode {
  success,
  error,
  serverError,
  clientError,
  unauthorized,
  notFound,
  forbidden,
  badRequest,
  conflict,
  internalServerError,
  unknown
}

class AppResponse {
  String id;
  AppStatusCode statusCode;
  String message;
  Map<String, dynamic> data;

  AppResponse({
    required this.id,
    required this.statusCode,
    this.message = '',
    this.data = const {},
  });

  factory AppResponse.success({
    String id = '',
    String message = "",
    Map<String, dynamic> data = const {},
  }) =>
      AppResponse(
        id: id,
        statusCode: AppStatusCode.success,
        message: message,
        data: data,
      );

  factory AppResponse.notFound({
    String id = '',
    String message = '',
    Map<String, dynamic> data = const {},
  }) =>
      AppResponse(
        id: id,
        statusCode: AppStatusCode.notFound,
        message: message,
        data: data,
      );

  factory AppResponse.error({
    String id = "",
    required String message,
    Map<String, dynamic> data = const {},
    dynamic error,
    StackTrace? stackTrace,
  }) {
    return AppResponse(
      id: id,
      statusCode: AppStatusCode.error,
      message: message,
      data: data,
    );
  }


}

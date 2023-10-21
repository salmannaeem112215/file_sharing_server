import 'package:file_sharing/headers.dart';

class ApiResponseHandler {
  static const String username_ = 'username';
  static const String token_ = 'token';

  static Future<Response> createRoute(
    Future<ApiResponse> Function() routeCreater,
  ) async {
    try {
      final res = await routeCreater();
      return Response.ok(json.encode(res.toJson()));
    } catch (e) {
      if (e is ApiResponse) {
        return Response.ok(json.encode(e));
      }
      if (e is String) {
        final res = ApiResponse.fail(e).toJson();
        return Response.ok(jsonEncode(res));
      }
      return Response.badRequest();
    }
  }


  static Future<Response> get({
    required Future<dynamic> Function() getter,
  }) async {
    return await ApiResponseHandler.createRoute(() async {
      final res = await getter();
      return ApiResponse.successData(res);
    });
  }

 
  static Future<Map<String, dynamic>> data(dynamic request) async {
    if (request.runtimeType == Request) {
      try {
        final d = await (request as Request).readAsString();
        return json.decode(d);
      } catch (e) {
        throw invalidData;
      }
    } else if (request.runtimeType == Map<String, dynamic>) {
      return (request as Map<String, dynamic>);
    } else {
      throw invalidData;
    }
  }

  
  static ApiResponse get invalidData =>
      ApiResponse(success: false, payload: Payload(message: 'Invalid Data'));
  static ApiResponse get badRequest =>
      ApiResponse(success: false, payload: Payload(message: 'Bad Request'));
  static ApiResponse get networkError =>
      ApiResponse(success: false, payload: Payload(message: 'Network Error'));
  static ApiResponse get accessError =>
      ApiResponse(success: false, payload: Payload(message: 'Login First'));

  static ApiResponse customErrors(List<String?> es) {
    String message = '';
    for (int i = 0; i < es.length; i++) {
      if (es[i] != null) {
        message += es[i]!;
        message += '. ';
      }
    }
    return ApiResponse(success: false, payload: Payload(message: message));
  }

  static void ifExistThrowErrors(List<String?> es) {
    for (int i = 0; i < es.length; i++) {
      if (es[i] != null) {
        throw customErrors(es);
      }
    }
  }

  
  static ApiResponse handleError(dynamic e) {
    if (e is ApiResponse) return e;
    if (e is String) return ApiResponse.fail(e);
    return ApiResponseHandler.badRequest;
  }

  static Response errorResponse(dynamic e) {
    final res = handleError(e);
    final json = res.toJson();
    return Response.ok(jsonEncode(json));
  }
}

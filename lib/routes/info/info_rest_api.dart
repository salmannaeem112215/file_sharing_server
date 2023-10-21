import 'package:file_sharing/headers.dart';

class InfoRestApi {
  Handler get router {
    final app = Router();

    final getInfo = eRoute;
    final updateInfo = ePassword;

    //get the Info of a post
    app.get(getInfo, (
      Request request,
    ) async {
      try {
        return await ApiResponseHandler.createRoute(
          () async {
            final info = InfoContainer.getValue();
            return ApiResponse.successData(info);
          },
        );
      } catch (e) {
        return ApiResponseHandler.errorResponse(e);
      }
    });

    app.get(updateInfo, (
      Request request,
      String password,
    ) async {
      try {
        return await ApiResponseHandler.createRoute(
          () async {
            final isUpdated = InfoContainer.updateValue(password);
            return ApiResponse(success: isUpdated);
          },
        );
      } catch (e) {
        return ApiResponseHandler.errorResponse(e);
      }
    });

    return app;
  }
}

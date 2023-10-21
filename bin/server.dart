import 'package:file_sharing/headers.dart';
import 'package:file_sharing/modules/firewall/error_handling.dart';
import 'package:file_sharing/modules/firewall/firewall_rules.dart';
import 'package:shelf_static/shelf_static.dart';

void main(List<String> arguments) async {
  // OPEN PORT IN FIREWALL, if error exist stop program
  final errorMessage = FirewallRules().configure(kIsDebugMode);
  ErrorHandling().handleError(errorMessage);

  // Create routes
  final app = Router();

  app.mount(
    AppRoutes.download,
    createStaticHandler('.${AppRoutes.downloadPath}'),
  );
  app.mount(AppRoutes.info, InfoRestApi().router);

  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(handleCors())
      .addHandler(app);

  withHotreload(() => serve(handler, InternetAddress.anyIPv4, AppRoutes.port));

  print('Server Listening at http://localhost:${AppRoutes.port}/  ');
}

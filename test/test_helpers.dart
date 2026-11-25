import 'dart:convert';

import 'package:material_ui/material_ui.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:provider/provider.dart';

Widget testApp(Widget home, {String? initialToken}) {
  final apiClient = ApiClient(
    baseUrl: 'http://test',
    client: MockClient((request) async {
      if (request.method == 'GET' && request.url.path == '/api/v1/projects/') {
        return http.Response('[]', 200);
      }
      if (request.method == 'POST' &&
          request.url.path == '/api/v1/auth/token/') {
        return http.Response(jsonEncode({'token': 'test-token'}), 200);
      }
      if (request.method == 'POST' && request.url.path == '/api/v1/projects/') {
        final body = jsonDecode(request.body) as Map<String, dynamic>;
        return http.Response(jsonEncode(body), 201);
      }
      if (request.method == 'POST' &&
          request.url.path == '/api/v1/auth/logout/') {
        return http.Response('', 204);
      }
      return http.Response('Not found', 404);
    }),
  );

  return MultiProvider(
    providers: [
      Provider.value(value: apiClient),
      ChangeNotifierProvider(
        create: (_) => AuthState(apiClient, initialToken: initialToken),
      ),
    ],
    child: MaterialApp(home: home),
  );
}

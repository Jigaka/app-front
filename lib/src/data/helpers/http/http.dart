import 'http_result.dart';
import 'http_method.dart';
import 'parse_response_body.dart';
import 'send_request.dart';

typedef Parser<T> = T Function(dynamic data);

class Http {
  final String baseUrl = 'https://equipoyosh.com/stock-nutrinatalia';
  Future<HttpResult<T>> request<T>(
    String path, {
    HttpMethod method = HttpMethod.get,
    Map<String, String> headers = const {},
    Map<String, String> queryParameters = const {},
    dynamic body,
    Parser<T>? parser,
    Duration timeOut = const Duration(seconds: 10),
  }) async {
    int? statusCode;
    dynamic data;
    try {
      late Uri url;
      if (path.startsWith('http://') || path.startsWith('https://')) {
        url = Uri.parse(path);
      } else {
        url = Uri.parse("$baseUrl$path");
      }

      if (queryParameters.isNotEmpty) {
        url = url.replace(queryParameters: {
          ...url.queryParameters,
          ...queryParameters,
        });
      }

      final response = await sendRequest(
          url: url,
          method: method,
          headers: headers,
          body: body,
          timeOut: timeOut);

      data = parseResponseBody(response.body);
      statusCode = response.statusCode;
      if (statusCode >= 400) {
        throw HttpError(
          exception: null,
          stackTrace: StackTrace.current,
          data: data,
        );
      }

      return HttpResult(
        data: parser != null ? parser(data) : data,
        statusCode: statusCode,
        error: null,
      );
    } catch (e, s) {
      // ignore: avoid_print
      print(e);

      if (e is HttpError) {
        return HttpResult<T>(
          data: null,
          statusCode: statusCode!,
          error: e,
        );
      }

      return HttpResult(
        data: null,
        statusCode: statusCode ?? -1,
        error: HttpError(
          data: data,
          exception: e,
          stackTrace: s,
        ),
      );
    }
  }
}

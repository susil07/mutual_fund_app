import 'package:dio/dio.dart';
import 'package:mutual_fund_app/core/constants/api_constants.dart';
import 'package:mutual_fund_app/core/error/exceptions.dart';

class ApiClient {
  final Dio _dio;

  ApiClient()
      : _dio = Dio(
          BaseOptions(
            baseUrl: ApiConstants.baseUrl,
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
          ),
        ) {
    _dio.interceptors.add(LogInterceptor(responseBody: true));
  }

  Future<Response> get(String path) async {
    try {
      final response = await _dio.get(path);
      return response;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.unknown) {
        throw NetworkException('No internet connection or timeout.');
      }
      throw ServerException('Failed to load data. Please try again later.');
    } catch (e) {
      throw ServerException('An unexpected error occurred.');
    }
  }
}

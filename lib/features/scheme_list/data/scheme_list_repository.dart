import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import 'scheme_model.dart';

import 'package:flutter/foundation.dart';

// Top-level function for isolate parsing
List<SchemeModel> _parseSchemes(List<dynamic> jsonList) {
  return jsonList.map((json) => SchemeModel.fromJson(json)).toList();
}

class SchemeListRepository {
  final ApiClient _apiClient;

  SchemeListRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<List<SchemeModel>> fetchSchemes() async {
    final response = await _apiClient.get(ApiConstants.schemes);
    if (response.data != null && response.data is List) {
      // Use compute to parse in a separate isolate to prevent UI jank
      return await compute(_parseSchemes, response.data as List<dynamic>);
    }
    return [];
  }
}

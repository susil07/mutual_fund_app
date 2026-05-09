import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import 'scheme_detail_model.dart';

class SchemeDetailRepository {
  final ApiClient _apiClient;

  SchemeDetailRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<SchemeDetailModel> fetchSchemeDetails(int schemeCode) async {
    final response = await _apiClient.get(ApiConstants.schemeDetails(schemeCode));
    
    if (response.data != null && response.data is Map<String, dynamic>) {
      return SchemeDetailModel.fromJson(response.data);
    }
    throw Exception('Invalid response format');
  }
}

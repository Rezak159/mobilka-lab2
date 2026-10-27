import 'api_client.dart';
import 'rate.dart';

class CurrencyRepository {
  ApiClient api = ApiClient();

  Future<Rate> getRate(String from, String to) async {
    var json = await api.getRates(from);
    return Rate.fromJson(json, to);
  }
}

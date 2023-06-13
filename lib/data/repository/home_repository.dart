import 'package:memory_mind_app/data/models/media_model.dart';
import 'package:memory_mind_app/data/web_services/home_webservices.dart';

class HomeRepository {
  final HomeWebServices homeWebServices;

  HomeRepository(this.homeWebServices);

  Future<MediaModel> getUserMedia(String token) async {
    try {
      final media = await homeWebServices.getUserMedia(token);
      return media;
    } catch (e) {
      return MediaModel();
    }
  }
}

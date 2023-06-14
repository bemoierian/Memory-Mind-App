import 'package:memory_mind_app/data/models/media_model.dart';
import 'package:memory_mind_app/data/web_services/home_webservices.dart';

class HomeRepository {
  final HomeWebServices homeWebServices;

  HomeRepository(this.homeWebServices);

  Future<MediaModel> getUserMedia(String token) async {
    try {
      final media = await homeWebServices.getUserMedia(token);
      final mediaModel = MediaModel.fromJson(media);
      // print(mediaModel.media![0].fileUrl!);
      return mediaModel;
    } catch (e) {
      print("Error in home repository:\n $e");
      return MediaModel();
    }
  }
}

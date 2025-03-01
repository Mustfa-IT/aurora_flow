import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:task_app/core/config/config.dart';

Future<Uint8List?> getImageFromPocketBase(
    String collectionId, String recordId, String imageId) async {
  var request = http.Request(
      'GET',
      Uri.parse(
          '${Config.pocketBaseUrl}/api/files/$collectionId/$recordId/$imageId'));
  var res = await request.send();
  var bytes = await res.stream.toBytes();
  return Uint8List.fromList(bytes);
}

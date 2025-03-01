import 'dart:typed_data';
import 'package:http/http.dart' as http;

Future<Uint8List> fetchNetworkImageBytes(String imageUrl) async {
  final response = await http.get(Uri.parse(imageUrl));
  if (response.statusCode == 200) {
    return response.bodyBytes;
  } else {
    throw Exception('Failed to load image from network');
  }
}

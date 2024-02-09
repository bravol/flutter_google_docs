import 'dart:convert';

import 'package:flutter_google_docs/constants/constants.dart';
import 'package:flutter_google_docs/models/document_model.dart';
import 'package:flutter_google_docs/models/error_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

//creating provider
final documentRepositoryProvider =
    Provider((ref) => DocumentRepository(client: Client()));

class DocumentRepository {
  final Client _client;

  DocumentRepository({required Client client}) : _client = client;

  //creating document
  Future<ErrorModel> createDocument(String token) async {
    ErrorModel errorModel =
        ErrorModel(error: 'Some unexpected error occure', data: null);
    try {
      var res = await _client.post(Uri.parse('$host/doc/create'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token,
          },
          body: jsonEncode(
            {
              'createdAt': DateTime.now().microsecondsSinceEpoch,
            },
          ));
      if (res.statusCode == 200) {
        errorModel = ErrorModel(
          error: null,
          data: DocumentModel.fromJson(res.body),
        );
      } else {
        errorModel = ErrorModel(error: res.body, data: null);
      }
    } catch (e) {
      errorModel = ErrorModel(
        error: e.toString(),
        data: null,
      );
    }
    return errorModel;
  }
}

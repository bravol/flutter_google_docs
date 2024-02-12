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
        ErrorModel(error: 'Some unexpected error occured', data: null);
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

  //getting my  documents
  Future<ErrorModel> getMyDocuments(String token) async {
    ErrorModel errorModel =
        ErrorModel(error: 'Some unexpected error occured', data: null);

    try {
      var res = await _client.get(Uri.parse('$host/docs/me'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': token,
      });
      switch (res.statusCode) {
        case 200:
          List<DocumentModel> documents = [];

          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            documents.add(
              DocumentModel.fromJson(jsonEncode(jsonDecode(res.body)[i])),
            );
          }
          errorModel = ErrorModel(error: null, data: documents);
          break;
        default:
          errorModel = ErrorModel(
            error: res.body,
            data: null,
          );
      }
    } catch (e) {
      errorModel = ErrorModel(
        error: e.toString(),
        data: null,
      );
    }
    return errorModel;
  }

  //updating the document
  Future<ErrorModel> updateTitle(
      {required String token,
      required String id,
      required String title}) async {
    ErrorModel errorModel =
        ErrorModel(error: 'Some unexpected error occured', data: null);

    try {
      await _client.put(
        Uri.parse('$host/doc/title'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
        body: jsonEncode({'title': title, 'id': id}),
      );
    } catch (e) {
      errorModel = ErrorModel(
        error: e.toString(),
        data: null,
      );
    }
    return errorModel;
  }

//getting the document by id
  Future<ErrorModel> getDocumentById(
      {required token, required String id}) async {
    ErrorModel errorModel =
        ErrorModel(error: 'Some unexpected error occured', data: null);
    try {
      var res = await _client.get(
        Uri.parse('$host/doc/$id'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
      );
      switch (res.statusCode) {
        case 200:
          errorModel = ErrorModel(
            error: null,
            data: DocumentModel.fromJson(res.body),
          );
          break;
        default:
          throw 'This Document does not exist';
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

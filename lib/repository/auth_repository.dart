import 'dart:convert';
import 'package:flutter_google_docs/constants/constants.dart';
import 'package:flutter_google_docs/models/error_model.dart';
import 'package:flutter_google_docs/models/user_model.dart';
import 'package:flutter_google_docs/repository/local_storage_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';

//crating a provider using flutter riverpod
final authRepositoryProvider = Provider((ref) => AuthRepository(
    googleSignIn: GoogleSignIn(),
    client: Client(),
    localStorageRepository: LocalStorageRepository()));

//keeping the state of the data for the user
final userProvider = StateProvider<UserModel?>((ref) => null);

class AuthRepository {
  final GoogleSignIn _googleSignIn;
  final Client _client;
  final LocalStorageRepository _localStorageRepository;

  AuthRepository(
      {required GoogleSignIn googleSignIn,
      required Client client,
      required LocalStorageRepository localStorageRepository})
      : _googleSignIn = googleSignIn,
        _client = client,
        _localStorageRepository = localStorageRepository;

  //function
  Future<ErrorModel> signInWithGoogle() async {
    ErrorModel error =
        ErrorModel(error: 'Some Expected Error occurred', data: null);
    try {
      final user = await _googleSignIn.signIn();

      if (user != null) {
        final userAcc = UserModel(
          email: user.email,
          name: user.displayName!,
          profilePic: user.photoUrl!,
          uid: '',
          token: '',
        );

        var res = await _client.post(Uri.parse('$host/api/signup'),
            body: userAcc.toJson(),
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
            });

        switch (res.statusCode) {
          case 200:
            //editing the user we use copy with
            final newUser = userAcc.copyWith(
              uid: jsonDecode(res.body)['user']
                  ['_id'], //converting res.body to proper string
              token: jsonDecode(res.body)['token'],
            );
            error = ErrorModel(error: null, data: newUser);
            _localStorageRepository.setToken(newUser.token);

            break;
          default:
            throw 'Error Occured';
        }
      }
    } catch (e) {
      error = ErrorModel(error: e.toString(), data: null);
    }
    return error;
  }
}

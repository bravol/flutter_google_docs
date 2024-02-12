import 'package:flutter/material.dart';
import 'package:flutter_google_docs/colors.dart';
import 'package:flutter_google_docs/common/widgets/loader.dart';
import 'package:flutter_google_docs/models/document_model.dart';
import 'package:flutter_google_docs/repository/auth_repository.dart';
import 'package:flutter_google_docs/repository/document_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void signOut(WidgetRef ref) {
    ref.read(authRepositoryProvider).signOut();
    ref.read(userProvider.notifier).update((state) => null);
  }

  //create document
  void createDocument(WidgetRef ref, BuildContext context) async {
    String token = ref.read(userProvider)!.token;
    final navigator = Routemaster.of(context);
    final snackBar = ScaffoldMessenger.of(context);

    final errorModel =
        await ref.read(documentRepositoryProvider).createDocument(token);
    if (errorModel.data != null) {
      navigator.push('/document/${errorModel.data.id}');
    } else {
      snackBar.showSnackBar(SnackBar(content: Text(errorModel.error!)));
    }
  }

//going to the specific document
  void navigateToDocument(BuildContext context, String documentId) {
    Routemaster.of(context).push('/document/$documentId');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => createDocument(ref, context),
            icon: const Icon(
              Icons.add,
              color: kBlackColor,
            ),
          ),
          IconButton(
            onPressed: () => signOut(ref),
            icon: const Icon(
              Icons.logout,
              color: kRedColor,
            ),
          ),
        ],
      ),
      body: Center(
        child: FutureBuilder(
          future:
              ref.watch(documentRepositoryProvider).getMyDocuments(user.token),
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Loader();
            }
            return Center(
              child: Container(
                margin: const EdgeInsets.only(top: 20),
                width: 500,
                child: ListView.builder(
                  itemCount: snapshot.data!.data.length,
                  itemBuilder: ((context, index) {
                    DocumentModel document = snapshot.data!.data[index];
                    return SizedBox(
                      height: 50,
                      child: InkWell(
                        onTap: () => navigateToDocument(context, document.id),
                        child: Card(
                          child: Center(
                            child: Text(
                              document.title,
                              style: const TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

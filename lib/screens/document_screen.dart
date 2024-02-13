import 'package:flutter/material.dart';
import 'package:flutter_google_docs/colors.dart';
import 'package:flutter_google_docs/models/document_model.dart';
import 'package:flutter_google_docs/models/error_model.dart';
import 'package:flutter_google_docs/repository/auth_repository.dart';
import 'package:flutter_google_docs/repository/document_repository.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DocumentScreen extends ConsumerStatefulWidget {
  const DocumentScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  final String id;

  @override
  ConsumerState<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends ConsumerState<DocumentScreen> {
  final titlecontroller = TextEditingController(text: 'Untitled Document ');
  final _controller = quill.QuillController.basic();
  ErrorModel? errorModel;

  @override
  void initState() {
    super.initState();
    //initally we load the data of the document
    fetchDocumentData();
  }

  void fetchDocumentData() async {
    errorModel = await ref.read(documentRepositoryProvider).getDocumentById(
          ref.read(userProvider)!.token,
          widget.id,
        );

    if (errorModel!.data != null) {
      titlecontroller.text = (errorModel!.data as DocumentModel).title;
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
    titlecontroller.dispose();
  }

  //update title

  void updateTitle(WidgetRef ref, String title) {
    ref.read(documentRepositoryProvider).updateTitle(
        token: ref.read(userProvider)!.token, id: widget.id, title: title);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(
                Icons.lock,
                size: 16,
                color: kWhiteColor,
              ),
              label: const Text(
                'Share',
                style: TextStyle(color: kWhiteColor),
              ),
              style: ElevatedButton.styleFrom(
                  backgroundColor: kBlueColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5))),
            ),
          ),
        ],
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            children: [
              Image.asset(
                'assets/images/docs-logo.png',
                height: 40,
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 180,
                child: TextField(
                  controller: titlecontroller,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: kBlackColor)),
                    contentPadding: EdgeInsets.only(left: 10),
                  ),
                  onSubmitted: (value) => updateTitle(ref, value),
                ),
              )
            ],
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: kGreyColor, width: 0.1),
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Card(
              child: quill.QuillToolbar.simple(
                configurations: quill.QuillSimpleToolbarConfigurations(
                  controller: _controller,
                  sharedConfigurations: const quill.QuillSharedConfigurations(
                    locale: Locale('de'),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SizedBox(
                width: 750,
                child: Card(
                  color: kWhiteColor,
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: quill.QuillEditor.basic(
                      configurations: quill.QuillEditorConfigurations(
                        controller: _controller,
                        readOnly: false,
                        sharedConfigurations:
                            const quill.QuillSharedConfigurations(
                          locale: Locale('de'),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

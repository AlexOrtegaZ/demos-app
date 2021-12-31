import 'dart:convert';

import 'package:demos_app/shared/screens/edit_content.screen.dart';
import 'package:demos_app/modules/spaces/pages/new_proposal/screens/content_step/widgets/view_content.widget.dart';
import 'package:demos_app/widgets/buttons/big_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;

class ContentStepScreen extends StatefulWidget {
  final VoidCallback goToNextStep;

  const ContentStepScreen({Key? key, required this.goToNextStep})
      : super(key: key);

  @override
  _ContentStepScreenState createState() => _ContentStepScreenState();
}

class _ContentStepScreenState extends State<ContentStepScreen> {
  final TextEditingController titleController = TextEditingController();
  QuillController controller = QuillController.basic();
  dynamic content;
  final FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          getProposalName(),
          const SizedBox(height: 16),
          Expanded(child: SingleChildScrollView(child: getAndShowContent())),
          BigButton(text: 'Continuar', onPressed: () => widget.goToNextStep())
        ],
      ),
    );
  }

  Widget getAndShowContent() {
    return ListTile(
      title: const Text('Contenido'),
      subtitle: ViewContent(controller: controller, focusNode: focusNode),
      trailing: IconButton(
        onPressed: () => openContentEditor(),
        icon: const Icon(
          Icons.edit,
          color: Colors.blue,
        ),
      ),
      contentPadding: const EdgeInsets.only(left: 4),
    );
  }

  Widget getProposalName() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Título de la propuesta'),
      textCapitalization: TextCapitalization.words,
      controller: titleController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'El título de la propuesta es requerido';
        }
        return null;
      },
    );
  }

  void openContentEditor() async {
    String? content = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditContentScreen(content: this.content)));

    if (content != null) {
      setState(
        () {
          this.content = content;
          controller = QuillController(
              document: Document.fromJson(jsonDecode(content)),
              selection: const TextSelection.collapsed(offset: 0));
        },
      );
    }
  }
}

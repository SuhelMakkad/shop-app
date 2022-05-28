import 'package:flutter/material.dart';

import '../providers/product.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({Key? key}) : super(key: key);

  static const routeName = "/edit-product";

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();

  final _imageUrlContoller = TextEditingController();
  final _form = GlobalKey<FormState>();

  var _editedProduct = Product(
    id: '',
    title: '',
    description: '',
    imageUrl: '',
    price: 0,
  );

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);

    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();

    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      final value = _imageUrlContoller.text;

      if (!value.startsWith("http") && !value.startsWith("https")) {
        return;
      }

      setState(() {});
    }
  }

  void _saveForm() {
    final currentState = _form.currentState!;
    final isValid = currentState.validate();

    if (!isValid) {
      return;
    }
    currentState.save();
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = _imageUrlContoller.text;
    final focusScope = FocusScope.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Product"),
        actions: [
          IconButton(onPressed: _saveForm, icon: const Icon(Icons.save)),
        ],
      ),
      body: Form(
        key: _form,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Title'),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    focusScope.requestFocus(_priceFocusNode);
                  },
                  onSaved: (value) {
                    _editedProduct = _editedProduct.copy(title: value);
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter a title";
                    }

                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Price'),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  focusNode: _priceFocusNode,
                  onFieldSubmitted: (_) {
                    focusScope.requestFocus(_descriptionFocusNode);
                  },
                  onSaved: (value) {
                    _editedProduct = _editedProduct.copy(
                        price: double.parse(value as String));
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter a price";
                    }

                    if (double.tryParse(value) == null) {
                      return "Please enter valid number";
                    }

                    if (double.parse(value) <= 0) {
                      return "Please enter a number greater then zero";
                    }

                    return null;
                  },
                ),
                TextFormField(
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: 'Description'),
                  keyboardType: TextInputType.multiline,
                  focusNode: _descriptionFocusNode,
                  onSaved: (value) {
                    _editedProduct = _editedProduct.copy(description: value);
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter a description";
                    }

                    if (value.length < 5) {
                      return "Description should be at least 5 charates long";
                    }

                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Image URL'),
                  keyboardType: TextInputType.url,
                  controller: _imageUrlContoller,
                  focusNode: _imageUrlFocusNode,
                  onEditingComplete: () {
                    setState(() {});
                  },
                  onSaved: (value) {
                    _editedProduct = _editedProduct.copy(imageUrl: value);
                  },
                  onFieldSubmitted: (_) => _saveForm(),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter an Image URL";
                    }

                    if (!value.startsWith("http") &&
                        !value.startsWith("https")) {
                      return "Please enter a valid URL";
                    }

                    return null;
                  },
                ),
                if (imageUrl.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(top: 16),
                    width: double.infinity,
                    height: 150,
                    child: FadeInImage(
                      placeholder:
                          const AssetImage("assets/images/image-preview.jpg"),
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

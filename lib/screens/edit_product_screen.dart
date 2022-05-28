import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({Key? key}) : super(key: key);

  static const routeName = "/edit-product";

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  var _isInit = true;
  var _isLoading = false;

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
  var appBarTitle = 'Add Product';

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context)!.settings.arguments as String?;

      if (productId != null) {
        final productsData = Provider.of<Products>(context, listen: false);

        _editedProduct = productsData.findById(productId);
        _imageUrlContoller.text = _editedProduct.imageUrl;
        appBarTitle = "Edit Product";
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

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

  void _saveForm() async {
    final currentState = _form.currentState!;
    final isValid = currentState.validate();

    if (!isValid) return;

    currentState.save();
    setState(() {
      _isLoading = true;
    });

    final productData = Provider.of<Products>(context, listen: false);

    if (_editedProduct.id == '') {
      await productData.addProduct(_editedProduct);
    } else {
      productData.updateProduct(_editedProduct);
    }

    if (!mounted) return;
    Navigator.of(context).pop();
    setState(() {
      _isLoading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = _imageUrlContoller.text;
    final focusScope = FocusScope.of(context);
    final deivceSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        actions: [
          IconButton(onPressed: _saveForm, icon: const Icon(Icons.save)),
        ],
      ),
      body: Stack(
        children: [
          Form(
            key: _form,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Title'),
                      initialValue: _editedProduct.title,
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
                      initialValue: _editedProduct.price == 0
                          ? ''
                          : _editedProduct.price.toString(),
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
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                      initialValue: _editedProduct.description,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      onSaved: (value) {
                        _editedProduct =
                            _editedProduct.copy(description: value);
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
                        decoration: BoxDecoration(
                          border: Border.all(),
                        ),
                        child: FadeInImage(
                          placeholder: const AssetImage(
                              "assets/images/image-preview.jpg"),
                          image: NetworkImage(imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          if (_isLoading)
            Container(
              width: deivceSize.width,
              height: deivceSize.height,
              color: Colors.black26,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}

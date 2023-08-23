
import 'package:flutter/material.dart';
import 'package:tdv2_showcase_mobile/domain/entity/product.dart';

class ProductItemView extends StatefulWidget {
  final Product product;
  final FontWeight titleFontWeight;
  final double aspectRatio, buttonSize;
  final bool buttonShrink, buttonAttachedToBottom;

  const ProductItemView({
    super.key,
    required this.product,
    this.aspectRatio=9.0/16.0,
    this.buttonSize=30.0,
    this.titleFontWeight=FontWeight.bold,
    this.buttonShrink=false,
    this.buttonAttachedToBottom=false,
  });

  @override
  State createState() => _ProductItemViewState();
}

class _ProductItemViewState extends State<ProductItemView> {
  final Duration _duration = const Duration(milliseconds: 300);

  int _count = 0;
  bool _isBookmark = false;

  _incrementCount() async {
    setState(() {
      _count++;
    });
  }

  _decrementCount() async {
    setState(() {
      _count--;
    });
  }

  _setBookmark() {
    setState(() {
      _isBookmark = !_isBookmark;
    });
  }

  @override
  void initState() {
    _count = widget.product.count;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Product data = widget.product;
    bool isCount = _count > 0;

    return AspectRatio(
      aspectRatio: widget.aspectRatio,
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: Image.network(
                    data.imageUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(
                      _isBookmark
                          ? Icons.bookmark
                          : Icons.bookmark_border,
                      color: Colors.white,
                    ),
                    onPressed: _setBookmark,
                  ),
                ),
              ],
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                    child: Text(
                      data.name,
                      textAlign: TextAlign.start,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: widget.titleFontWeight,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: FittedBox(
                      child: Text(
                        data.formattedPrice,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: widget.buttonAttachedToBottom
                        ? EdgeInsets.zero
                        : const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
                    child: widget.buttonAttachedToBottom
                        ? Container(
                          padding: isCount ? const EdgeInsets.only(bottom: 4.0, left: 4.0, right: 4.0) : EdgeInsets.zero,
                          child: _buildButton(data, isCount, context)
                        )
                        : _buildButton(data, isCount, context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Stack _buildButton(Product data, bool isCount, BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            height: widget.buttonShrink
                ? isCount
                  ? widget.buttonSize - 8.0
                  : widget.buttonSize
                : widget.buttonSize,
            child: Row(
              children: [
                SizedBox(
                  width: widget.buttonSize,
                  child: OutlinedButton(
                    style: ButtonStyle(
                      shape: widget.buttonAttachedToBottom
                          ? isCount ? null : MaterialStateProperty.all(const RoundedRectangleBorder())
                          : null,
                      padding: MaterialStateProperty.all(EdgeInsets.zero),
                    ),
                    onPressed: () {
                      if (_count != 0) {
                        _decrementCount();
                      }
                    },
                    child: const Icon(Icons.remove, size: 18, color: Colors.black),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 4.0),
                    child: OutlinedButton(
                      style: ButtonStyle(
                        shape: widget.buttonAttachedToBottom
                            ? isCount ? null : MaterialStateProperty.all(const RoundedRectangleBorder())
                            : null,
                        padding: MaterialStateProperty.all(EdgeInsets.zero),
                      ),
                      onPressed: () {},
                      child: Text('$_count', softWrap: false),
                    ),
                  ),
                ),
                Container(width: widget.buttonSize),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: AnimatedContainer(
            curve: Curves.easeOut,
            duration: _duration,
            width: isCount ? widget.buttonSize : 200.0,
            height: widget.buttonShrink
                ? isCount
                ? widget.buttonSize - 8.0
                    : widget.buttonSize
                    : widget.buttonSize,
            child: ElevatedButton(
              style: ButtonStyle(
                shape: widget.buttonAttachedToBottom
                    ? isCount ? null : MaterialStateProperty.all(const RoundedRectangleBorder())
                    : null,
                padding: MaterialStateProperty.all(EdgeInsets.zero),
                elevation: MaterialStateProperty.all(0),
                backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor),
              ),
              onPressed: () => _incrementCount(),
              child: Container(
                width: 90.0,
                height: widget.buttonShrink
                    ? isCount
                      ? widget.buttonSize - 8.0
                      : widget.buttonSize
                    : widget.buttonSize,
                alignment: Alignment.center,
                child: ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  children: [
                    SizedBox(
                      width: widget.buttonSize,
                      height: widget.buttonShrink
                          ? isCount
                            ? widget.buttonSize - 8.0
                            : widget.buttonSize
                          : widget.buttonSize,
                      child: Icon(isCount ? Icons.add : Icons.shopping_cart, size: 18, color: Colors.white),
                    ),
                    Container(
                      height: widget.buttonShrink
                          ? isCount
                            ? widget.buttonSize - 8.0
                            : widget.buttonSize
                          : widget.buttonSize,
                      alignment: Alignment.center,
                      child: const Text(' Tambah',
                        softWrap: false,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
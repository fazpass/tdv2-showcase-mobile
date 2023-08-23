
import 'package:flutter/material.dart';

class Carousel extends StatefulWidget {
  final IndexedWidgetBuilder itemBuilder;
  final double viewportFraction, imageAspectRatio;
  final int itemsLength;

  const Carousel({
    super.key,
    required this.itemBuilder,
    required this.itemsLength,
    this.imageAspectRatio=16.0/9.0,
    this.viewportFraction=0.85,
  });

  @override
  State createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  late int _currentPage;
  late PageController _controller;

  PageView buildPageView() {
    return PageView.builder(
      onPageChanged: (value) {
        setState(() {
          _currentPage = value;
        });
      },
      itemCount: widget.itemsLength,
      controller: _controller,
      itemBuilder: (context, index) => AnimatedBuilder(
        animation: _controller,
        child: widget.itemBuilder(context, index),
        builder: (context, child) {
          return child!;
        },
      ),
    );
  }

  @override
  void initState() {
    _currentPage = 0;
    _controller = PageController(
      viewportFraction: widget.viewportFraction,
      initialPage: _currentPage,
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Center(
          child: AspectRatio(
            aspectRatio: widget.imageAspectRatio,
            child: buildPageView(),
          ),
        ),
        Positioned(
          bottom: 0.0, left: 0, right: 0,
          child: _DotsIndicator(
            controller: _controller,
            itemCount: widget.itemsLength,
            onPageSelected: (page) => _controller.animateToPage(page,
                duration: const Duration(milliseconds: 400), curve: Curves.easeOut),
            activeColor: Theme.of(context).primaryColor,
            inactiveColor: Theme.of(context).primaryColor.withOpacity(0.5),
          ),
        ),
      ],
    );
  }
}

class _DotsIndicator extends AnimatedWidget {
  const _DotsIndicator({
    required this.controller,
    required this.itemCount,
    required this.onPageSelected,
    this.inactiveColor=Colors.grey,
    this.activeColor=Colors.white,
  }) : super(listenable: controller);

  /// The PageController that this DotsIndicator is representing.
  final PageController controller;

  /// The number of items managed by the PageController
  final int itemCount;

  /// Called when a dot is tapped
  final ValueChanged<int> onPageSelected;

  /// The color of the inactive dots.
  ///
  /// Defaults to `Colors.grey`.
  final Color inactiveColor;

  /// The color of the active dot.
  ///
  /// Defaults to `Colors.white`.
  final Color activeColor;

  // The base size of the dots
  static const double _kDotSize = 9.0;

  // The distance between the center of each dot
  static const double _kDotSpacing = 20.0;

  Widget _buildDot(int index) {
    bool isSelected = (controller.page ?? controller.initialPage) == index;
    return SizedBox(
      width: _kDotSpacing,
      child: Center(
        child: Material(
          color: isSelected ? activeColor : inactiveColor,
          type: MaterialType.circle,
          child: SizedBox(
            width: _kDotSize,
            height: _kDotSize,
            child: InkWell(
              onTap: () => onPageSelected(index),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(itemCount, _buildDot),
    );
  }
}
import 'package:flutter/material.dart';

class FadeOnScroll extends StatefulWidget {
  final ScrollController scrollController;
  final double zeroOpacityOffset;
  final double fullOpacityOffset;
  final Widget child;

  const FadeOnScroll({
    Key? key, 
    required this.scrollController,
    required this.child,
    this.zeroOpacityOffset = 0,
    this.fullOpacityOffset = 0}) : super(key: key);

  @override
  _FadeOnScrollState createState() => _FadeOnScrollState();
}

class _FadeOnScrollState extends State<FadeOnScroll> {
  late double _offset;

  @override
  initState() {
    super.initState();
    _offset = widget.scrollController.offset;
    widget.scrollController.addListener(_setOffset);
  }

  @override
  dispose() {
    widget.scrollController.removeListener(_setOffset);
    super.dispose();
  }

  void _setOffset() {
    setState(() {
      _offset = widget.scrollController.offset;
    });
  }

  double _calculateOpacity() {
    if (widget.fullOpacityOffset == widget.zeroOpacityOffset) {
      return 1;
    }
    
    if (widget.fullOpacityOffset > widget.zeroOpacityOffset) {
      // fading in
      if (_offset <= widget.zeroOpacityOffset) {
        return 0;
      } 
      
      if (_offset >= widget.fullOpacityOffset) {
        return 1;
      } 
      
      return (_offset - widget.zeroOpacityOffset) / (widget.fullOpacityOffset - widget.zeroOpacityOffset);
    }
    
    if (_offset <= widget.fullOpacityOffset) {
      return 1;
    }
    
    if (_offset >= widget.zeroOpacityOffset) {
      return 0;
    } 
    
    return (_offset - widget.fullOpacityOffset) / (widget.zeroOpacityOffset - widget.fullOpacityOffset);
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _calculateOpacity(),
      child: widget.child,
    );
  }
}

import 'package:flutter/material.dart';

class servico_fixed_appbar extends StatefulWidget {
  final Widget child;

  const servico_fixed_appbar({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  _servico_fixed_appbarState createState() {
    return new _servico_fixed_appbarState();
  }
}

class _servico_fixed_appbarState extends State<servico_fixed_appbar> {
  ScrollPosition _position;
  bool _visible;

  @override
  void dispose() {
    _removeListener();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _removeListener();
    _addListener();
  }

  void _addListener() {
    _position = Scrollable.of(context)?.position;
    _position?.addListener(_positionListener);
    _positionListener();
  }

  void _removeListener() {
    _position?.removeListener(_positionListener);
  }

  void _positionListener() {
    final FlexibleSpaceBarSettings settings =
        context.dependOnInheritedWidgetOfExactType();
    bool visible =
        settings == null || settings.currentExtent <= settings.minExtent;
    if (_visible != visible) {
      setState(() {
        _visible = visible;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _visible,
      child: widget.child,
    );
  }
}

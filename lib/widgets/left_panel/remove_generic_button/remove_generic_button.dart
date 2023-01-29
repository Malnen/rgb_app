import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_bloc.dart';

class RemoveGenericButton<T> extends StatefulWidget {
  final T value;
  final void Function(T value) onTap;

  const RemoveGenericButton({required this.value, required this.onTap});

  @override
  State<RemoveGenericButton<T>> createState() => _RemoveGenericButtonState<T>();
}

class _RemoveGenericButtonState<T> extends State<RemoveGenericButton<T>> {
  late DevicesBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = GetIt.instance.get();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        height: 36,
        width: 36,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 16, 16, 16),
          borderRadius: BorderRadius.all(
            Radius.circular(4),
          ),
        ),
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      onTap: () => widget.onTap(widget.value),
    );
  }
}

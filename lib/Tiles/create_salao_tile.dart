import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CreateSalaoTile extends StatelessWidget {
  final DocumentSnapshot snapshot;
  CreateSalaoTile(this.snapshot);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(snapshot['nome']),
    );
  }
}

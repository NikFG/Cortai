import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SalaoTile extends StatelessWidget {
  final DocumentSnapshot snapshot;
  SalaoTile(this.snapshot);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(snapshot['nome']),
    );
  }
}

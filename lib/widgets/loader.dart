
import 'package:flutter/material.dart';

/// Simple widget that maintains the styling of the circular progress indicator
class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(color: Colors.orange[200], valueColor: const AlwaysStoppedAnimation(Colors.orange),);
  }
}
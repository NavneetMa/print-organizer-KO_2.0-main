import 'package:flutter/material.dart';
import 'package:kwantapo/utils/lib.dart';

class LoadingIndicator extends StatelessWidget {

  const LoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        height: 50,
        width: 50,
        child: CircularProgressIndicator(
          color: AppTheme.colorAccent,
        ),
      ),
    );
  }

}

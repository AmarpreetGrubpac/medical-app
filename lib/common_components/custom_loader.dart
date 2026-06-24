import 'package:flutter/material.dart';

class CustomLoader extends StatelessWidget {
  final bool colorcircular;
  const CustomLoader({super.key,  this.colorcircular = false});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10)),
          alignment: Alignment.center,
          child:  CircularProgressIndicator(color: !colorcircular ?Colors.white:Colors.red),
        ));
  }
}
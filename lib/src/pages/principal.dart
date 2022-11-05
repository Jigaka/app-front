import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class PrincipalPage extends StatelessWidget {
  static String id = 'principal_page';
  const PrincipalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text("principal")),
    );
  }
}

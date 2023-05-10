import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key});

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: Column(children: [
        // Container(color: Colors.amber,),
        Expanded(child: FutureBuilder(
          future: Future.delayed(const Duration(microseconds: 150)).then((value) => rootBundle.loadString('assets/privacy.md')),
        builder:(context, snapshot){
          if (snapshot.hasData) {
            return  Markdown(
              styleSheet: MarkdownStyleSheet.fromTheme(
                ThemeData(textTheme: const TextTheme(
                  bodyMedium: TextStyle(fontSize: 14,
                  color: Colors.black)
                ))
              ),
              data: snapshot.data!);
            
          }
          return const Center(child: CircularProgressIndicator(),);
        },
         ))],),
    );
  }
}
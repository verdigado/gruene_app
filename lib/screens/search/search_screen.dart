import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:go_router/go_router.dart';
import 'package:gruene_app/routing/router.dart';
import 'package:gruene_app/routing/routes.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text('Search'),
          TextButton(
              onPressed: () => context.push(newsScreen), child: Text('News'))
        ],
      ),
    );
  }
}

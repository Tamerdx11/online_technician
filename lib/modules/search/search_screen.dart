import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_technician/shared/components/components.dart';
import 'package:online_technician/shared/cubit/cubit.dart';
import 'package:online_technician/shared/cubit/states.dart';

// ignore: must_be_immutable
class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key}) : super(key: key);

  var searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        var data = AppCubit.get(context).search; ///search data

        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: defaultFormText(
                    validate: (value)
                    {
                      if(value == null)
                      {
                        return "search must not be empty";
                      }
                      return null;
                    },
                    controller: searchController,
                    onchange: (value) {
                      AppCubit.get(context).getSearchData(value);
                    },
                    label: "Search...",
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),
                Expanded(child: searchResultsBuilder(data, context)),
              ],
            ),
          ),
        );
      },
    );
  }
}

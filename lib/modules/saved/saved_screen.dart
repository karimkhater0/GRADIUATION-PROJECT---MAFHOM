import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafhom/shared/cubit/cubit.dart';
import 'package:mafhom/shared/cubit/states.dart';

import '../../shared/components.dart';
import '../../shared/constants.dart';

class SavedScreen extends StatelessWidget {
  SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..getSavedSentences(),
      child: BlocBuilder<AppCubit, AppStates>(
          builder: (context, state) {
            var cubit = AppCubit.get(context);
            return Scaffold(
                body: Container(
                    decoration: backgroundDecoration,
                    height: screenHeight(context),
                    child: ConditionalBuilder(
                        condition: state is! AppGetSavedSentencesLoadingState &&
                            state is! AppDeleteSavedSentenceLoadingState,
                        builder: (context) => cubit.sentences.length > 0
                            ? SavedListView()
                            : Center(
                                child: Text('There is no saved sentences.')),
                        fallback: (context) =>
                            const Center(child: CircularProgressIndicator())),

                ),

            );
          }),
    );
  }
}
class SavedListView extends StatelessWidget {
  const SavedListView({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.get(context);

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) => buildSavedItem(
          cubit.sentences[index], index, context),
      separatorBuilder: (context, index) =>
          myDivider(),
      itemCount: cubit.sentences.length,
    );
  }
}

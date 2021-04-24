import 'package:appdiet/data/repository/plan_alimentaire_repository.dart';
import 'package:appdiet/logic/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:appdiet/logic/cubits/plan_alimentaire/plan_alimentaire_cubit.dart';
import 'package:flutter/material.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlanAlimentaire extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthenticationBloc bloc) => bloc.state.user);
    return BlocProvider(
      create: (context) => PlanAlimentaireCubit(
          planAlimentaireRepository: PlanAlimentaireRepository(user: user))
        ..loadDocument(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Plan Alimentaire'),
        ),
        body: Center(
          child: BlocBuilder<PlanAlimentaireCubit, PlanAlimentaireState>(
              builder: (context, state) {
            if (state is PlanAlimentaireLoadSuccess) {
              return PDFViewer(
                document: state.document,
                zoomSteps: 1,
                //uncomment below line to preload all pages
                lazyLoad: false,
                // uncomment below line to scroll vertically
                scrollDirection: Axis.vertical,
              );
            }
            if (state is PlanAlimentaireLoadFailure) {
              return Center(
                  child: Text(
                "Vous n'avez pas de plan alimentaire actuellement ou une erreur est survenue lors du téléchargement",
                textAlign: TextAlign.center,
              ));
            } else {
              return CircularProgressIndicator();
            }
          }),
        ),
      ),
    );
  }
}

import 'package:appdiet/data/models/poids_mesures/poids_mesures.dart';
import 'package:appdiet/data/repository/poids_mesures_repository.dart';
import 'package:appdiet/logic/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:appdiet/logic/cubits/poids_mesures/poidsmesures_cubit.dart';
import 'package:appdiet/presentation/pages/photos/photos_page.dart';
import 'package:appdiet/presentation/pages/poids_mesures/add_poids_mesures.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PoidsMesuresPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User user =
        context.select((AuthenticationBloc bloc) => bloc.state.user);
    return BlocProvider(
      create: (context) => PoidsMesuresCubit(
          poidsMesuresRepository: PoidsMesuresRepository(user: user))
        ..loadPoidsMesures(),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Poids et Mesures"),
            actions: [
              BlocBuilder<PoidsMesuresCubit, PoidsMesuresState>(
                builder: (context, state) {
                  return IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AddPoidsMesures(),
                          ),
                        );
                        context.read<PoidsMesuresCubit>().loadPoidsMesures();
                      });
                },
              ),
            ],
            bottom: TabBar(
              tabs: [
                Tab(
                  child: Text("Poids"),
                ),
                Tab(
                  child: Text("Mesures"),
                ),
              ],
            ),
          ),
          body: BlocBuilder<PoidsMesuresCubit, PoidsMesuresState>(
            builder: (context, state) {
              if (state is PoidsMesuresLoadSuccess) {
                return TabBarView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _Poids(poids: state.poidsMesures.poids),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _Mesures(mesures: state.poidsMesures.mesures),
                    ),
                  ],
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ),
      ),
    );
  }
}

class _Poids extends StatelessWidget {
  const _Poids({Key key, this.poids}) : super(key: key);

  final List<Poids> poids;

  @override
  Widget build(BuildContext context) {
    PoidsMesuresRepository poidsMesuresRepository = PoidsMesuresRepository(
        user: context.select((AuthenticationBloc bloc) => bloc.state.user));
    poidsMesuresRepository.loadPoidsMesures();
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: 15,
          ),
          Expanded(
            child: SfCartesianChart(
              primaryXAxis:
                  DateTimeAxis(intervalType: DateTimeIntervalType.months),
              legend: Legend(isVisible: true),
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <LineSeries<Poids, DateTime>>[
                LineSeries<Poids, DateTime>(
                    dataSource: poids,
                    xValueMapper: (Poids poids, _) => poids.date,
                    yValueMapper: (Poids poids, _) => poids.poids,
                    name: "Poids",
                    // Enable data label
                    dataLabelSettings: DataLabelSettings(isVisible: true)),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          _PhotosButton(),
          SizedBox(height: 35),
        ],
      ),
    );
  }
}

class _Mesures extends StatelessWidget {
  const _Mesures({Key key, this.mesures}) : super(key: key);

  final Map<MesureType, List<Mesures>> mesures;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          //enum MesureType { taille,ventre,hanche,cuisses,bras, poitrine }
          Expanded(
            child: SfCartesianChart(
              primaryXAxis:
                  DateTimeAxis(intervalType: DateTimeIntervalType.months),
              legend: Legend(
                  isVisible: true,
                  isResponsive: true,
                  orientation: LegendItemOrientation.horizontal,
                  overflowMode: LegendItemOverflowMode.wrap),
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <LineSeries<Mesures, DateTime>>[
                LineSeries<Mesures, DateTime>(
                  dataSource: mesures[MesureType.taille],
                  xValueMapper: (Mesures mesures, _) => mesures.date,
                  yValueMapper: (Mesures mesures, _) => mesures.mesure,
                  name: "taille",
                  // Enable data label
                  dataLabelSettings: DataLabelSettings(isVisible: true),
                ),
                LineSeries<Mesures, DateTime>(
                  dataSource: mesures[MesureType.ventre],
                  xValueMapper: (Mesures mesures, _) => mesures.date,
                  yValueMapper: (Mesures mesures, _) => mesures.mesure,
                  name: "ventre",
                  // Enable data label
                  dataLabelSettings: DataLabelSettings(isVisible: true),
                ),
                LineSeries<Mesures, DateTime>(
                  dataSource: mesures[MesureType.hanche],
                  xValueMapper: (Mesures mesures, _) => mesures.date,
                  yValueMapper: (Mesures mesures, _) => mesures.mesure,
                  name: "hanche",
                  // Enable data label
                  dataLabelSettings: DataLabelSettings(isVisible: true),
                ),
                LineSeries<Mesures, DateTime>(
                  dataSource: mesures[MesureType.cuisses],
                  xValueMapper: (Mesures mesures, _) => mesures.date,
                  yValueMapper: (Mesures mesures, _) => mesures.mesure,
                  name: "cuisses",
                  // Enable data label
                  dataLabelSettings: DataLabelSettings(isVisible: true),
                ),
                LineSeries<Mesures, DateTime>(
                  dataSource: mesures[MesureType.bras],
                  xValueMapper: (Mesures mesures, _) => mesures.date,
                  yValueMapper: (Mesures mesures, _) => mesures.mesure,
                  name: "bras",
                  // Enable data label
                  dataLabelSettings: DataLabelSettings(isVisible: true),
                ),
                LineSeries<Mesures, DateTime>(
                  dataSource: mesures[MesureType.poitrine],
                  xValueMapper: (Mesures mesures, _) => mesures.date,
                  yValueMapper: (Mesures mesures, _) => mesures.mesure,
                  name: "poitrine",
                  // Enable data label
                  dataLabelSettings: DataLabelSettings(isVisible: true),
                ),
              ],
            ),
          ),
          _PhotosButton(),
          SizedBox(height: 25),
        ],
      ),
    );
  }
}

class _PhotosButton extends StatelessWidget {
  const _PhotosButton({this.photos});

  final List<String> photos;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        SizedBox(
          width: 15,
        ),
        Expanded(
          child: SizedBox(
            height: 50.0,
            child: ElevatedButton(
              key: const Key('photos_mesures_open_photos_key'),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.photo_camera_outlined,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Voir les photos',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              style: ElevatedButton.styleFrom(
                primary: theme.primaryColor,
                onSurface: theme.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => PhotosPage())),
            ),
          ),
        ),
        SizedBox(
          width: 15,
        )
      ],
    );
  }
}

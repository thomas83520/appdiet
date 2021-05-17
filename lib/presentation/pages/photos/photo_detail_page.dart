import 'package:appdiet/data/repository/photos_repository.dart';
import 'package:appdiet/logic/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:appdiet/logic/cubits/photo_detail/photo_detail_cubit.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class PhotoDetailPage extends StatelessWidget {
  const PhotoDetailPage({Key key, this.url}) : super(key: key);

  final String url;

  @override
  Widget build(BuildContext context) {
    final User user =
        context.select((AuthenticationBloc bloc) => bloc.state.user);
    return BlocProvider(
      create: (context) => PhotoDetailCubit(
        photosRepository: PhotosRepository(user: user),
      )..loadDetail(url),
      child: Scaffold(
        appBar: AppBar(
          title: BlocBuilder<PhotoDetailCubit, PhotoDetailState>(
            builder: (context, state) {
              if (state is PhotoDetailLoadSuccess)
                return Text("Photo du : " +
                    DateFormat("dd-MM-yyyy").format(state.detailPhoto.date));
              return Text("Date");
            },
          ),
          actions: [
            TextButton(
                onPressed: () => null,
                child: Text(
                  "Supprimer",
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
        body: BlocBuilder<PhotoDetailCubit, PhotoDetailState>(
          builder: (context, state) {
            if (state is PhotoDetailLoadSuccess)
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.network(url),
                      _MesuresView(),
                    ],
                  ),
                ),
              );
            else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}

class _MesuresView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhotoDetailCubit, PhotoDetailState>(
      builder: (context, state) {
        if (state is PhotoDetailLoadSuccess)
          return Center(
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Poids: " + state.detailPhoto.poids.toString() + " Kg",
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  "Mesures :",
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  height: 8,
                ),
                Column(
                  children: state.detailPhoto.mesures != null
                      ? loadMesures(state.detailPhoto.mesures)
                      : Container(),
                )
              ],
            ),
          );
        else
          return Container();
      },
    );
  }

  List<Widget> loadMesures(Map<String, double> mesures) {
    List<Widget> list = [];

    mesures.forEach((key, value) {
      list.add(Text(key + " : " + value.toString() + " cm"));
    });

    return list;
  }
}

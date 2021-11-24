import 'package:appdiet/data/models/models.dart';
import 'package:appdiet/data/repository/photos_repository.dart';
import 'package:appdiet/logic/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:appdiet/logic/cubits/photo_detail/photo_detail_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class PhotoDetailPage extends StatelessWidget {
  const PhotoDetailPage({Key? key, required this.url,required this.image}) : super(key: key);

  final String url;
  final Image image;

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
            BlocBuilder<PhotoDetailCubit, PhotoDetailState>(
              builder: (context, state) {
                return TextButton(
                    onPressed: () async {
                      await context
                        .read<PhotoDetailCubit>()
                        .supprPhoto(
                            (state as PhotoDetailLoadSuccess).detailPhoto);
                      Navigator.of(context).pop();
                        },
                    child: Text(
                      "Supprimer",
                      style: TextStyle(color: Colors.white),
                    ));
              },
            )
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
                      image,
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
                Column(children: loadMesures(state.detailPhoto.mesures))
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

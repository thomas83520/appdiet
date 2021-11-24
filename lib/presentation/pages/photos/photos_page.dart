import 'package:appdiet/data/models/models.dart';
import 'package:appdiet/data/models/photos/photos_detail.dart';
import 'package:appdiet/data/repository/photos_repository.dart';
import 'package:appdiet/logic/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:appdiet/logic/cubits/photos/photos_cubit.dart';
import 'package:appdiet/presentation/pages/photos/photo_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PhotosPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User user =
        context.select((AuthenticationBloc bloc) => bloc.state.user);
    return BlocProvider(
      create: (context) =>
          PhotosCubit(photosRepository: PhotosRepository(user: user))
            ..loadimages(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Albums Photos"),
        ),
        body: BlocBuilder<PhotosCubit, PhotosState>(
          builder: (context, state) {
            if (state is PhotosLoadSuccess)
              return Container(
                child: GridView.count(
                  crossAxisCount: 3,
                  mainAxisSpacing: 3,
                  crossAxisSpacing: 3,
                  padding: EdgeInsets.all(5),
                  children: loadImage(state.photosUrl, context),
                ),
              );
            else
              return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  List<Widget> loadImage(List<DetailPhoto> photosUrl, BuildContext context) {
    List<Widget> photos = [];
    photosUrl.forEach((photo) {
      photos.add(
        BlocBuilder<PhotosCubit, PhotosState>(
          builder: (context, state) {
            return InkWell(
              child: Stack(children: [
                Center(child: CircularProgressIndicator()),
                Center(child: Image.network(photo.photoUrl))
              ]),
              onTap: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PhotoDetailPage(
                      url: photo.photoUrl,
                      image: Image.network(photo.photoUrl),
                    ),
                  ),
                );
                context.read<PhotosCubit>().loadimages();
              },
            );
          },
        ),
      );
    });

    return photos;
  }
}

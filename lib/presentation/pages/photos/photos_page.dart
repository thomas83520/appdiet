import 'package:appdiet/data/repository/photos_repository.dart';
import 'package:appdiet/logic/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:appdiet/logic/cubits/photos/photos_cubit.dart';
import 'package:appdiet/presentation/pages/photos/photo_detail_page.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PhotosPage extends StatelessWidget {
  final List<String> photosUrl = [
    "https://placeimg.com/500/500/any",
    "https://placeimg.com/500/500/any",
    "https://placeimg.com/500/500/any",
    "https://placeimg.com/500/500/any"
  ];

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
                  children: loadImage(state.photosUrl,context),
                ),
              );
            else
              return CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  List<Widget> loadImage(List<String> photosUrl,BuildContext context) {
    List<Widget> photos = [];
    photosUrl.forEach((url) {
      photos.add(
        InkWell(
          child: Image.network(url),
          onTap: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (context)=> PhotoDetailPage(url: url,))),
        ),
      );
    });

    return photos;
  }
}

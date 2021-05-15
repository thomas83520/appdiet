import 'package:appdiet/data/repository/photos_repository.dart';
import 'package:appdiet/logic/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:appdiet/logic/cubits/photo_detail/photo_detail_cubit.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
          title: Text("Date"),
        ),
        body: BlocBuilder<PhotoDetailCubit, PhotoDetailState>(
          builder: (context, state) {
            if(state is PhotoDetailLoadSuccess)
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.network(url),
                Text(state.detailPhoto.poids.toString()),
              ],
            );
            else{
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}

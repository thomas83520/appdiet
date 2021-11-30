import 'dart:io';

import 'package:appdiet/data/models/models.dart';
import 'package:appdiet/data/repository/photos_repository.dart';
import 'package:appdiet/data/repository/poids_mesures_repository.dart';
import 'package:appdiet/logic/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:appdiet/logic/cubits/add_mesures_cubits/add_mesures_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class AddPoidsMesures extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User user =
        context.select((AuthenticationBloc bloc) => bloc.state.user);
    return BlocProvider(
      create: (context) => AddMesuresCubit(
          PhotosRepository(user: user), PoidsMesuresRepository(user: user))
        ..dateChange(DateTime.now()),
      child: BlocListener<AddMesuresCubit, AddMesuresState>(
        listener: (context, state) {
          if (state.formState == AddMesureFormState.complete)
            Navigator.of(context).pop();
          if (state.formState == AddMesureFormState.error)
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Une erreur est surevenue")),
            );
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text("Ajoutez poids et mesures"),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Column(
                  children: [
                    _DateMesureInput(),
                    SizedBox(
                      height: 10,
                    ),
                    _PhotoMesure(),
                    SizedBox(
                      height: 10,
                    ),
                    _PoidsMesureInput(),
                    SizedBox(
                      height: 10,
                    ),
                    _MesuresInput(),
                    SizedBox(
                      height: 15,
                    ),
                    _AddButton(),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MesuresInput extends StatelessWidget {
  const _MesuresInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddMesuresCubit, AddMesuresState>(
      builder: (context, state) => Material(
        elevation: 2,
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        child: Container(
          constraints: BoxConstraints(minHeight: 70.0),
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Mesures :",
                style: TextStyle(fontSize: 25),
              ),
              Row(
                children: [
                  Text(
                    "Tour de taille :",
                    style: TextStyle(fontSize: 15),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        onChanged: (taille) => taille == ""
                            ? null
                            : context
                                .read<AddMesuresCubit>()
                                .tailleChanged(taille),
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          hintText: "Entrez votre tour de taille",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "Tour de ventre :",
                    style: TextStyle(fontSize: 15),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        onChanged: (ventre) => ventre == ""
                            ? null
                            : context
                                .read<AddMesuresCubit>()
                                .ventreChanged(ventre),
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          hintText: "Entrez votre tour de ventre",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "Tour de hanches :",
                    style: TextStyle(fontSize: 15),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        onChanged: (hanches) => hanches == ""
                            ? null
                            : context
                                .read<AddMesuresCubit>()
                                .hanchesChanged(hanches),
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          hintText: "Entrez votre tour de hanches",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "Tour de cuisses :",
                    style: TextStyle(fontSize: 15),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        onChanged: (cuisses) => cuisses == ""
                            ? null
                            : context
                                .read<AddMesuresCubit>()
                                .cuissesChanged(cuisses),
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          hintText: "Entrez votre tour de cuisses",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "Tour de bras :",
                    style: TextStyle(fontSize: 15),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        onChanged: (bras) => bras == ""
                            ? null
                            : context.read<AddMesuresCubit>().brasChanged(bras),
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          hintText: "Entrez votre tour de bras",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "Tour de poitrine :",
                    style: TextStyle(fontSize: 15),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        onChanged: (poitrine) => poitrine == ""
                            ? null
                            : context
                                .read<AddMesuresCubit>()
                                .poitrineChanged(poitrine),
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          hintText: "Entrez votre tour de poitrine",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PoidsMesureInput extends StatelessWidget {
  const _PoidsMesureInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddMesuresCubit, AddMesuresState>(
      builder: (context, state) {
        return Material(
          elevation: 2,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          child: Container(
            constraints: BoxConstraints(minHeight: 70.0),
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            width: double.infinity,
            child: Row(
              children: [
                Text(
                  "Poids:",
                  style: TextStyle(fontSize: 20),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      onChanged: (poids) => poids == ""
                          ? null
                          : context.read<AddMesuresCubit>().poidsChanged(poids),
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      key: const Key('signUpForm_poidsMesursInput_textField'),
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(), hintText: "Poids"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PhotoMesure extends StatelessWidget {
  const _PhotoMesure({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddMesuresCubit, AddMesuresState>(
      builder: (context, state) {
        return InkWell(
          onTap: () async {
            XFile? file =
                await ImagePicker().pickImage(source: ImageSource.gallery);
            if (file != null) context.read<AddMesuresCubit>().fileChanged(file);
          },
          child: Material(
            elevation: 2,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            child: Container(
              constraints: BoxConstraints(minHeight: 70.0),
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              width: double.infinity,
              child: Row(
                children: [
                  Text(
                    "Ajoutez une photo:",
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    width: 50,
                  ),
                  BlocBuilder<AddMesuresCubit, AddMesuresState>(
                    builder: (context, state) {
                      return Container(
                        height: 150,
                        width: 100,
                        child: state.file.path == ''
                            ? Container()
                            : Image.file(File(state.file.path)),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DateMesureInput extends StatelessWidget {
  const _DateMesureInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddMesuresCubit, AddMesuresState>(
      builder: (context, state) {
        return Material(
          elevation: 2,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          child: Container(
            constraints: BoxConstraints(minHeight: 70.0),
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            width: double.infinity,
            child: Row(
              children: [
                Text(
                  "Date:",
                  style: TextStyle(fontSize: 20),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: BlocBuilder<AddMesuresCubit, AddMesuresState>(
                      builder: (context, state) {
                        return TextFormField(
                          readOnly: true,
                          controller: TextEditingController(
                              text: state.date.toString().length > 10
                                  ? state.date.toString().substring(0, 10)
                                  : null),
                          key: const Key('AddMesures_dateInput_textField'),
                          onTap: () async {
                            DateTime? date = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now());
                            if (date != null)
                              context.read<AddMesuresCubit>().dateChange(date);
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AddButton extends StatelessWidget {
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
            height: 60.0,
            child: BlocBuilder<AddMesuresCubit, AddMesuresState>(
              builder: (context, state) {
                if (state.formState == AddMesureFormState.loadInProgress)
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                else
                  return ElevatedButton(
                    child: Text(
                      'Ajoutez les mesures',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: theme.primaryColor,
                      onSurface: theme.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onPressed: () =>
                        context.read<AddMesuresCubit>().addMesures(),
                  );
              },
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

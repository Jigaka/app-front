import 'package:flutter/material.dart';
import 'package:frontend/src/data/data_source/remote/pacientes_api.dart';
import 'package:frontend/src/data/helpers/http/http.dart';
import 'package:frontend/src/data/helpers/pacientes_repository_impl.dart';
import 'package:frontend/src/domain/models/Paciente.dart';
import 'package:frontend/src/domain/repositories/pacientes_repository.dart';
import 'package:frontend/src/pages/fisioterapeuta_page.dart';
import 'package:frontend/src/pages/registrar_paciente_page.dart';
import 'package:frontend/src/utils/expandable_fab.dart';

class PacientesPage extends StatefulWidget {
  static String id = 'pacientes_page';

  const PacientesPage({super.key});

  @override
  State<PacientesPage> createState() => _PacientesState();
}

class _PacientesState extends State<PacientesPage> {
  List<Paciente> pacientes = [];
  bool isLoading = true;
  bool _isSearching = false;
  String nombre = '';
  bool isTotal = false;
  final myController = TextEditingController();

  PacientesRepository? pacientesRest;
  @override
  void initState() {
    super.initState();
    final http = Http();

    pacientesRest = PacientesRepositoryImpl(
      PacientesApi(http),
    );

    pacientesRest!.obtenerPacientes().then(
      (value) {
        setState(
          () {
            pacientes = value;
            isLoading = false;
          },
        );
      },
    );
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isSearching
          ? _getAppBarSearching(onSearchCancel, onSearch, myController)
          : _getAppBarNotSearching("Pacientes", startSearching),
      body: _getBody(),
      floatingActionButton: ExpandableFabClass(
        distanceBetween: 80.0,
        subChildren: [
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, FisioterapeutaPage.id);
            },
            child: const Text('Obtener fisioterapeutas'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, RegistrarPacientePage.id);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _getAppBarNotSearching(
    String title,
    Function startSearchFunction,
  ) {
    return AppBar(
      title: Text(title),
      actions: <Widget>[
        IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              startSearchFunction();
            }),
      ],
    );
  }

  void startSearching() {
    setState(() {
      _isSearching = true;
    });
  }

  void onSearchCancel() {
    myController.text = '';
    setState(() {
      pacientes = [];
      _isSearching = false;
      isLoading = true;
    });
    pacientesRest!.obtenerPacientes().then(
      (value) {
        setState(
          () {
            pacientes = value;
            isLoading = false;
          },
        );
      },
    );
  }

  void onSearch() {
    setState(() {
      pacientes = [];
      isLoading = true;
    });

    if (isTotal) {
      pacientesRest!.obtenerPacientesByNombre(myController.text).then(
        (value) {
          setState(
            () {
              pacientes = value;
              isLoading = false;
            },
          );
        },
      );
    } else {
      pacientesRest!.obtenerPacientesByNombreParcial(myController.text).then(
        (value) {
          setState(
            () {
              pacientes = value;
              isLoading = false;
            },
          );
        },
      );
    }
  }

  PreferredSizeWidget _getAppBarSearching(
    Function cancelSearch,
    Function searching,
    TextEditingController searchController,
  ) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          isLoading ? () {} : cancelSearch();
        },
      ),
      actions: <Widget>[
        const Center(
          child: Text(
            'Total',
          ),
        ),
        Checkbox(
          checkColor: Colors.white,
          fillColor: MaterialStateProperty.resolveWith(getColor),
          value: isTotal,
          onChanged: (bool? value) {
            setState(
              () {
                isTotal = value!;
              },
            );
          },
        ),
      ],
      title: Padding(
        padding: const EdgeInsets.only(
          bottom: 10,
          right: 40,
        ),
        child: TextField(
          controller: searchController,
          onEditingComplete: () {
            searching();
          },
          style: const TextStyle(
            color: Colors.white,
          ),
          cursorColor: Colors.white,
          autofocus: true,
          decoration: const InputDecoration(
            focusColor: Colors.white,
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Colors.red;
  }

  Widget _getBody() {
    return Stack(
      children: [
        Expanded(
          child: pacientes.isEmpty
              ? const Center(
                  child: Text(
                    "Sin datos",
                  ),
                )
              : ListView.builder(
                  itemCount: pacientes.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      padding: const EdgeInsets.all(15.0),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.blue, width: 1),
                        ),
                      ),
                      child: ListTile(
                        trailing: const Icon(Icons.person),
                        title: Text(
                            '${pacientes[index].nombre} ${pacientes[index].apellido ?? ""}'),
                      ),
                    );
                  },
                ),
        ),
        isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Container(),
      ],
    );
  }
}

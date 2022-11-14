import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:frontend/src/domain/models/Ficha.dart';

class ItemsFichaPage extends StatefulWidget {
  List<Ficha> fichas = [];

  ItemsFichaPage({
    required this.fichas,
  });

  @override
  State<ItemsFichaPage> createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsFichaPage> {
  bool cerroCampeon = true;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Expanded(
          child: widget.fichas.isEmpty
              ? const Center(
                  child: Text(
                    "Sin datos",
                  ),
                )
              : ListView.builder(
                  itemCount: widget.fichas.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      padding: const EdgeInsets.all(15.0),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.blue, width: 1),
                        ),
                      ),
                      child: Slidable(
                        key: const ValueKey(0),

                        // The start action pane is the one at the left or the top side.
                        startActionPane: ActionPane(
                          // A motion is a widget used to control how the pane animates.
                          motion: const ScrollMotion(),

                          // All actions are defined in the children parameter.
                          children: [
                            // A SlidableAction can have an icon and/or a label.
                            SlidableAction(
                              onPressed: null,
                              // onPressed: (value) {
                              //   widget.cancelReserva(
                              //     context,
                              //     widget.reservas[index].idReserva,
                              //     widget.reservas[index],
                              //     index,
                              //   );
                              //   widget.reservas.removeAt(index);
                              //   setState(() {});
                              // },
                              backgroundColor: const Color(0xFFFE4A49),
                              foregroundColor: Colors.white,
                              icon: Icons.cancel,
                              label: 'Cancelar',
                            ),
                            SlidableAction(
                              onPressed: null,
                              // onPressed: (value) async {
                              //   List<String> lista = await widget.editReserva(
                              //     context,
                              //     widget.reservas[index].idReserva,
                              //     widget.reservas[index],
                              //     index,
                              //     widget.reservas[index].observacion ?? '',
                              //     widget.reservas[index].flagAsistio ?? '',
                              //   );
                              //   setState(() {
                              //     cerroCampeon = !cerroCampeon;
                              //     widget.reservas[index].observacion = lista[0];
                              //     widget.reservas[index].flagAsistio = lista[1];
                              //   });
                              // },
                              backgroundColor: const Color(0xFF21B7CA),
                              foregroundColor: Colors.white,
                              icon: Icons.edit,
                              label: 'Editar',
                            ),
                          ],
                        ),
                        child: ListTile(
                          trailing: const Icon(Icons.exit_to_app),
                          title: Text(
                            '${widget.fichas[index].idFichaClinica} ${widget.fichas[index].motivoConsulta}',
                          ),
                          subtitle: Text(
                            '${widget.fichas[index].diagnostico}',
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );

    // ListView.builder(
    //   itemBuilder: (_, int index) {
    //     if (widget.filter == "none") {
    //       return ListTile(title: Text("Item $index"));
    //     } else if (widget.filter == "even") {
    //       return ListTile(title: Text("Item ${index * 2}"));
    //     } else {
    //       return ListTile(title: Text("Item ${index * 2 + 1}"));
    //     }
    //   },
    //   itemCount: 100,
    // );
  }

  String convertToDateFormat(String value) {
    String year = value.substring(0, 4);
    String month = value.substring(4, 6);
    String day = value.substring(6);
    return '$day/$month/$year';
  }

  String convertToHourFormat(String value) {
    String hora = value.substring(0, 2);
    String minuto = value.substring(2);
    return '$hora:$minuto';
  }
}

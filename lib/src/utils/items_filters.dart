import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:frontend/src/domain/models/Paciente.dart';

class ItemsFilters extends StatefulWidget {
  final Function(int idFisio, int idCliente, String desde, String hasta)
      onFilterChange;
  final List<Paciente> pacientes;
  final List<Paciente> fisios;
  ItemsFilters({
    super.key,
    required this.onFilterChange,
    required this.pacientes,
    required this.fisios,
  });

  @override
  State<ItemsFilters> createState() => _ItemsFiltersState(pacientes, fisios);
}

class _ItemsFiltersState extends State<ItemsFilters> {
  DateTime? selectedDateInicial;
  DateTime? selectedDateFinal;
  Paciente? idFisio;
  Paciente? idCliente;

  _ItemsFiltersState(List<Paciente> pacientes, List<Paciente> fisios)
      : idCliente = pacientes.isEmpty ? null : pacientes.first,
        idFisio = fisios.isEmpty ? null : fisios.first;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      width: double.infinity,
      child: Column(
        children: [
          idFisio != null
              ? (widget.fisios.length == 1
                  ? Container(
                      child: Text(widget.fisios.first.nombre),
                    )
                  : DropdownButton<Paciente>(
                      value: idFisio,
                      icon: const Icon(Icons.arrow_downward),
                      elevation: 16,
                      style: const TextStyle(color: Colors.deepPurple),
                      underline: Container(
                        height: 2,
                        color: Colors.deepPurpleAccent,
                      ),
                      onChanged: (Paciente? value) {
                        // This is called when the user selects an item.
                        setState(() {
                          idFisio = value!;
                        });
                      },
                      items: widget.fisios
                          .map<DropdownMenuItem<Paciente>>((Paciente value) {
                        return DropdownMenuItem<Paciente>(
                          value: value,
                          child: Text(value.nombre),
                        );
                      }).toList(),
                    ))
              : Container(
                  child: Text('sin fisioterapeutas'),
                ),
          const SizedBox(height: 10),
          idCliente != null
              ? (widget.pacientes.length == 1
                  ? Container(
                      child: Text(widget.pacientes.first.nombre),
                    )
                  : DropdownButton<Paciente>(
                      value: idCliente,
                      icon: const Icon(Icons.arrow_downward),
                      elevation: 16,
                      style: const TextStyle(color: Colors.deepPurple),
                      underline: Container(
                        height: 2,
                        color: Colors.deepPurpleAccent,
                      ),
                      onChanged: (Paciente? value) {
                        // This is called when the user selects an item.
                        setState(() {
                          idCliente = value!;
                        });
                      },
                      items: widget.pacientes
                          .map<DropdownMenuItem<Paciente>>((Paciente value) {
                        return DropdownMenuItem<Paciente>(
                          value: value,
                          child: Text(value.nombre),
                        );
                      }).toList(),
                    ))
              : Container(
                  child: Text("sin clientes"),
                ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100.0),
            child: DateTimeField(
                mode: DateTimeFieldPickerMode.date,
                decoration: const InputDecoration(
                  hintText: 'Desde',
                ),
                selectedDate: selectedDateInicial,
                onDateSelected: (DateTime value) {
                  setState(() {
                    selectedDateInicial = value;
                  });
                }),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100.0),
            child: DateTimeField(
                mode: DateTimeFieldPickerMode.date,
                decoration: const InputDecoration(
                  hintText: 'Hasta',
                ),
                selectedDate: selectedDateFinal,
                onDateSelected: (DateTime value) {
                  setState(() {
                    selectedDateFinal = value;
                  });
                }),
          ),
          ElevatedButton(
            onPressed: () => widget.onFilterChange(
                idCliente != null ? idCliente!.idPersona! : 0,
                idFisio != null ? idFisio!.idPersona! : 0,
                selectedDateInicial != null
                    ? format(
                        selectedDateInicial!,
                      )
                    : 'no',
                selectedDateFinal != null
                    ? format(
                        selectedDateFinal!,
                      )
                    : 'no'),
            child: Text('Filtrar'),
          ),
        ],
      ),
    );
  }

  String format(DateTime value) {
    int year = value.year;
    int month = value.month;
    int day = value.day;
    return '$year$month$day';
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:counter_convert_todo/bloc/todo_bloc.dart';
import 'package:counter_convert_todo/Model/todo.dart';


class TodoPage extends StatelessWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final _key = GlobalKey<FormState>();
    final _controller = TextEditingController();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Fixed padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Todo List',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Selected Date'),
                        BlocBuilder<TodoBloc, TodoState>(
                          builder: (context, state) {
                            if (state is TodoLoaded) {
                              if (state.selectedDate != null) {
                                return Text(
                                  '${state.selectedDate!.day}/${state.selectedDate!.month}/${state.selectedDate!.year}',
                                );
                              }
                            }
                            return const Text('No Date Selected');
                          },
                                    ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        ).then((selectedDate) {
                          if (selectedDate != null) {
                            context.read<TodoBloc>().add(
                              TodoSelectDate(date: selectedDate),
                            );
                          }
                        });
                      },
                      child: const Text('Select Date'),
                    ),
                  ),
                ],
              ),
              Form(
                key: _key,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _controller,
                        decoration: InputDecoration(
                          labelText: 'Todo',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a todo';
                          }
                          return null;
                        },
                      ),
                    ),
                    FilledButton(
                      onPressed: () {
                        if (_key.currentState!.validate()) {
                          final state = context.read<TodoBloc>().state;
                          if (state is TodoLoaded &&
                              state.selectedDate != null) {
                            context.read<TodoBloc>().add(
                              TodoEventAdd(
                                title: _controller.text,
                                date: state.selectedDate!,
                              ),
                            );
                            _controller.clear();
                            // No need to nullify the selectedDate here, as it's managed by the state
                          }
                        }
                      },
                      child: const Text('Tambah'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              Expanded(
                child: BlocBuilder<TodoBloc, TodoState>(
                  builder: (context, State) {
                    if (State is TodoLoading) {
                      return Center(child: CircularProgressIndicator());
                        if (State.todos.isEmpty) {
                        return Center(child: Text('Todo list is empty'));
                      }







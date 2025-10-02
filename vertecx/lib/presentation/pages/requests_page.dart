import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vertecx/blocs/requests_bloc.dart';
import 'package:vertecx/blocs/requests_event.dart';
import 'package:vertecx/blocs/requests_state.dart';
import 'package:vertecx/data/repositories/request_repository.dart';
import 'package:vertecx/presentation/widgets/request_card.dart';
import 'package:vertecx/presentation/widgets/app_top_bar.dart'; // <- tu topbar

class RequestsPage extends StatelessWidget {
  const RequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RequestsBloc>(
      create: (_) => RequestsBloc(RequestRepositoryMock())
        ..add(const RequestsLoadRequested()),
      child: const _RequestsScaffold(),
    );
  }
}

class _RequestsScaffold extends StatelessWidget {
  const _RequestsScaffold();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: const AppTopBar(
        title: 'Solicitudes',  // <- título fijo para esta pantalla
        centerTitle: true,
        showBack: false,
      ),
      body: Column(
        children: const [
          Padding(
            padding: EdgeInsets.fromLTRB(12, 12, 12, 6),
            child: _SearchBox(),
          ),
          Expanded(child: _RequestsList()),
        ],
      ),
    );
  }
}

class _RequestsList extends StatelessWidget {
  const _RequestsList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RequestsBloc, RequestsState>(
      builder: (context, state) {
        if (state.loading) return const Center(child: CircularProgressIndicator());
        if (state.error != null) {
          return Center(child: Text(state.error!, style: const TextStyle(color: Colors.red)));
        }

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 20),
          itemCount: state.visible.length + (state.hasMore ? 1 : 0),
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (_, i) {
            if (i < state.visible.length) {
              return RequestCard(data: state.visible[i]);
            }
            // Footer "Cargar más"
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Center(
                child: OutlinedButton.icon(
                  onPressed: state.loadingMore
                      ? null
                      : () => context.read<RequestsBloc>().add(const RequestsLoadMorePressed()),
                  icon: state.loadingMore
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.expand_more),
                  label: const Text('Cargar más'),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _SearchBox extends StatefulWidget {
  const _SearchBox();

  @override
  State<_SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<_SearchBox> {
  final c = TextEditingController();

  @override
  void initState() {
    super.initState();
    c.addListener(() {
      context.read<RequestsBloc>().add(RequestsSearchChanged(c.text));
    });
  }

  @override
  void dispose() {
    c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(blurRadius: 2, color: Color(0x11000000), offset: Offset(0, 1))],
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          const Icon(Icons.search, size: 20, color: Colors.black54),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: c,
              decoration: const InputDecoration(
                hintText: 'Buscar  Solicitudes...',
                border: InputBorder.none,
              ),
              textInputAction: TextInputAction.search,
            ),
          ),
          BlocBuilder<RequestsBloc, RequestsState>(
            builder: (context, state) {
              if (state.query.isEmpty) return const SizedBox.shrink();
              return IconButton(icon: const Icon(Icons.close, size: 18), onPressed: () => c.clear());
            },
          ),
        ],
      ),
    );
  }
}

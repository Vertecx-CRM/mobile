import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vertecx/blocs/requests_event.dart';
import 'package:vertecx/blocs/requests_state.dart';

class RequestsBloc extends Bloc<RequestsEvent, RequestsState> {
  final dynamic repo; // usa IRequestRepository real

  RequestsBloc(this.repo) : super(const RequestsState()) {
    on<RequestsLoadRequested>(_onLoad);
    on<RequestsSearchChanged>(_onSearch);
    on<RequestsLoadMorePressed>(_onLoadMore);
  }

  Future<void> _onLoad(
    RequestsLoadRequested event,
    Emitter<RequestsState> emit,
  ) async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final data = await repo.getAll();
      final filtered = data;
      final firstCount =
          filtered.length < state.pageSize ? filtered.length : state.pageSize;

      emit(state.copyWith(
        all: data,
        filtered: filtered,
        visibleCount: firstCount,
        visible: filtered.take(firstCount).toList(),
        loading: false,
      ));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  void _onSearch(
    RequestsSearchChanged event,
    Emitter<RequestsState> emit,
  ) {
    final q = event.query.trim().toLowerCase();

    final filtered = q.isEmpty
        ? state.all
        : state.all.where((r) {
            final id = 'id:${r.id}';
            final est = r.estadoLabel.toLowerCase();
            return r.titulo.toLowerCase().contains(q) ||
                r.tipo.toLowerCase().contains(q) ||
                id.contains(q) ||
                est.contains(q);
          }).toList();

    final firstCount =
        filtered.length < state.pageSize ? filtered.length : state.pageSize;

    emit(state.copyWith(
      query: event.query,
      filtered: filtered,
      visibleCount: firstCount,
      visible: filtered.take(firstCount).toList(),
    ));
  }

  void _onLoadMore(
    RequestsLoadMorePressed event,
    Emitter<RequestsState> emit,
  ) {
    // Evita llamadas simultáneas y corta si no hay más
    if (state.loadingMore || !state.hasMore) return;

    // 1) Enciende el loader del botón
    emit(state.copyWith(loadingMore: true));

    // 2) Calcula el siguiente bloque visible
    final nextCount = (state.visibleCount + state.pageSize)
        .clamp(0, state.filtered.length);

    // 3) Actualiza lista visible y apaga loader
    emit(state.copyWith(
      visibleCount: nextCount,
      visible: state.filtered.take(nextCount).toList(),
      loadingMore: false,
    ));
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/mocks/user_mock_data.dart';
import '../../../../data/models/users/user_model.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    on<LoadUsers>(_onLoadUsers);
    on<ToggleUserStatus>(_onToggleUserStatus);
  }

  void _onLoadUsers(LoadUsers event, Emitter<UserState> emit) {
    emit(UserLoaded(List.from(mockUsers)));
  }

  void _onToggleUserStatus(ToggleUserStatus event, Emitter<UserState> emit) {
    if (state is UserLoaded) {
      final current = (state as UserLoaded).users;
      final updated = current.map((u) {
        if (u.id == event.userId) {
          return toggleStatus(u); // ✅ usa tu función helper de user_model.dart
        }
        return u;
      }).toList();

      emit(UserLoaded(updated));
    }
  }
}

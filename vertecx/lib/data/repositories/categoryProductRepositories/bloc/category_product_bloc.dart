import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vertecx/data/mocks/categoryProducts_mock_data.dart';
import 'package:vertecx/data/models/categoryProducts/categoryProducts_model.dart';
part 'category_product_event.dart';
part 'category_product_state.dart';

class CategoryProductBloc extends Bloc<CategoryProductEvent, CategoryProductState> {
  CategoryProductBloc() : super(CategoryProductInitial()) {
    on<LoadCategories>(_onLoadCategories);
    on<ToggleCategoryStatus>(_onToggleCategoryStatus);
  }

  void _onLoadCategories(
      LoadCategories event, Emitter<CategoryProductState> emit) {
    emit(CategoryProductLoaded(List.from(mockCategoryProducts)));
  }

  void _onToggleCategoryStatus(
      ToggleCategoryStatus event, Emitter<CategoryProductState> emit) {
    if (state is CategoryProductLoaded) {
      final current = (state as CategoryProductLoaded).categories;
      final updated = current.map((c) {
        if (c.id == event.categoryId) {
          return CategoryProduct(
            id: c.id,
            imagenPath: c.imagenPath,
            nombre: c.nombre,
            descripcion: c.descripcion,
            estado: c.estado == CategoryStatus.activo
                ? CategoryStatus.inactivo
                : CategoryStatus.activo,
          );
        }
        return c;
      }).toList();

      emit(CategoryProductLoaded(updated));
    }
  }
}

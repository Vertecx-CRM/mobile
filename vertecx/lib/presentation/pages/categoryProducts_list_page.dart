import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vertecx/data/models/categoryProducts/categoryProducts_model.dart';
import '../widgets/categoryProductsWidgets/categoryProduct_card_widget.dart';
import '../widgets/components/search/search.dart';
import '../../data/repositories/categoryProductRepositories/bloc/category_product_bloc.dart';

class CategoryProductListPage extends StatefulWidget {
  const CategoryProductListPage({super.key});

  @override
  State<CategoryProductListPage> createState() =>
      _CategoryProductListPageState();
}

class _CategoryProductListPageState extends State<CategoryProductListPage> {
  int _categoriesToShow = 4;
  String _searchQuery = "";
  final ScrollController _scrollController = ScrollController();

  void _loadMoreCategories(int totalCategories) {
    setState(() {
      _categoriesToShow = (_categoriesToShow + 2).clamp(0, totalCategories);
    });
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CategoryProductBloc()..add(LoadCategories()),
      child: Scaffold(
        backgroundColor: const Color(0xFFE8E8E8),
        body: BlocBuilder<CategoryProductBloc, CategoryProductState>(
          builder: (context, state) {
            if (state is CategoryProductLoaded) {
              // Filtrar categorías por búsqueda
              final filteredCategories = state.categories
                  .where((c) => c.matchesQuery(_searchQuery))
                  .toList();

              final categories = filteredCategories
                  .take(_categoriesToShow)
                  .toList();
              final allCategoriesLoaded =
                  _categoriesToShow >= filteredCategories.length;

              return SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                 

                    const SizedBox(height: 20),

                    // buscador
                    Buscar(
                      hintText: "Buscar categoría...",
                      onChanged: (value) {
                        setState(() => _searchQuery = value);
                      },
                    ),

                    const SizedBox(height: 20),

                    // lista de categorías
                    ...categories.map(
                      (category) => CategoryCard(
                        category: category,
                        onToggleStatus: () {
                          context.read<CategoryProductBloc>().add(
                            ToggleCategoryStatus(category.id),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 20),

                    // botón o mensaje final
                    if (filteredCategories.isNotEmpty)
                      if (!allCategoriesLoaded)
                        TextButton(
                          onPressed: () =>
                              _loadMoreCategories(filteredCategories.length),
                          child: Column(
                            children: [
                              Image.asset(
                                "assets/icons/Vector.png",
                                width: 20,
                                height: 20,
                              ),
                              const Text(
                                "Cargar más Categorías de productos",
                                style: TextStyle(color: Color(0xFFB20000)),
                              ),
                            ],
                          ),
                        )
                      else
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            "Ya están todas las categoría de productos",
                            style: TextStyle(
                              color: Color(0xFFB20000),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                    else
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          "No se encontraron categoría de productos",
                          style: TextStyle(
                            color: Color(0xFFB20000),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                    const SizedBox(height: 40),
                  ],
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _scrollToTop,
          backgroundColor: const Color(0xFFB20000),
          child: const Icon(Icons.arrow_upward, color: Colors.white),
        ),
      ),
    );
  }
}

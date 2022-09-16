import 'package:animations/animations.dart';
import 'package:eyepetizer_flutter/page/discovery/category_detail_page.dart';
import 'package:eyepetizer_flutter/state/base_state.dart';
import 'package:eyepetizer_flutter/utils/cache_image.dart';
import 'package:eyepetizer_flutter/viewmodel/discovery/category_viewmodel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends BaseState<CategoryViewModel, CategoryPage> {
  @override
  Widget getContentChild(model) {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(color: Color(0xfff2f2f2)),
      child: GridView.builder(
        itemCount: model.list.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, mainAxisSpacing: 5, crossAxisSpacing: 5),
        itemBuilder: (context, index) {
          return OpenContainer(
            closedBuilder: (context, action) {
              return _categoryImage(model, index);
            },
            openBuilder: (context, action) {
              return CategoryDetailPage(categoryModel: model.list[index]);
            },
          );
        },
      ),
    );
  }

  @override
  get viewModel => CategoryViewModel();

  Widget _categoryImage(CategoryViewModel model, int index) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: cacheImage(model.list[index].bgPicture!),
        ),
        Center(
          child: Text(
            "#${model.list[index].name}",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }
}

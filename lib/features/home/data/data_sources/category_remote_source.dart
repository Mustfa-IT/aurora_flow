import 'package:pocketbase/pocketbase.dart';
import 'package:task_app/features/home/data/models/category_model.dart';

abstract class CategoryRemoteSource {
  Future<List<CategoryModel>?> fetchCategories();
  Future<CategoryModel?> getCategory(String id);
  Future<CategoryModel> createCategory(Map<String, dynamic> data);
  Future<CategoryModel> updateCategory(String id,String name);
  Future<void> deleteCategory(String id);
  Future<void> onCategoryUpdate(String id, Function callBack);
  Future<void> onCategoriesUpdates(Function callBack);
}

class CategoryRemoteSourceImpl implements CategoryRemoteSource {
  final PocketBase pocketBase;

  CategoryRemoteSourceImpl({required this.pocketBase});

  @override
  Future<List<CategoryModel>?> fetchCategories() async {
    final records = await pocketBase.collection('categories').getFullList();
    return records.map((r) => CategoryModel.fromJson(r.toJson())).toList();
  }

  @override
  Future<CategoryModel?> getCategory(String id) async {
    try {
      final record = await pocketBase.collection('categories').getOne(id);
      return CategoryModel.fromJson(record.toJson());
    } catch (e) {
      return null;
    }
  }

  @override
  Future<CategoryModel> createCategory(Map<String, dynamic> data) async {
    final record = await pocketBase.collection('categories').create(body: data);
    return CategoryModel.fromJson(record.toJson());
  }

  @override
  Future<CategoryModel> updateCategory(
    String id,
    String name,
  ) async {
    final body = <String, dynamic>{
      "name": name,
    };

    final record =
        await pocketBase.collection('categories').update(id, body: body);
    print(record);
    return CategoryModel.fromJson(record.toJson());
  }

  @override
  Future<void> deleteCategory(String id) async {
    await pocketBase.collection('categories').delete(id);
  }

  @override
  Future<void> onCategoryUpdate(String id, Function callBack) async {
    await pocketBase.collection('categories').subscribe(
      id,
      (e) {
        if (e.record != null) {
          callBack(CategoryModel.fromJson(e.record!.toJson()));
        }
      },
    );
  }

  @override
  Future<void> onCategoriesUpdates(Function callBack) async {
    await pocketBase.collection('categories').subscribe(
      "*",
      (e) {
        callBack();
      },
    );
  }
}

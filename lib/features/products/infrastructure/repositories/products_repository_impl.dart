

import '../../domain/domain.dart';
class ProductRepositoryImpl extends ProductsRepository {


  final ProductsDataSource dataSource;

  ProductRepositoryImpl(this.dataSource);

  @override
  Future<Product> createUpdateProduct(Map<String, dynamic> productLike) {
    return dataSource.createUpdateProduct(productLike);
  }

  @override
  Future<Product> getProductById(String id) {
    return dataSource.getProductById(id);
  }

  @override
  Future<List<Product>> getProductByPage({int limit = 10, int offset = 0}) {
    return dataSource.getProductByPage( limit:  limit, offset: offset );
  }

  @override
  Future<List<Product>> searchProductByTerm(String term) {
    return dataSource.searchProductByTerm(term);
  }

}



import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/presentation/providers/providers.dart';
import 'package:teslo_shop/features/shared/shared.dart';


//family para enviar el tipo de dato
final  productFormProvider = StateNotifierProvider.autoDispose.family<ProductFormNotifier, ProductFormState, Product>(
  (ref, product){
    //TODO: createUpdateCallback
    // final createUpdateCallback = ref.watch(productRepositoryProvider).createUpdateProduct;

    final createUpdateCallback = ref.watch( productsProvider.notifier ).createOrUpdateProduct;


    return ProductFormNotifier(
      product: product,
      onSubmitCallback: createUpdateCallback

      //TODO: onsubmitCallback: createUpdateCallback
    );
  }

);

class ProductFormNotifier extends StateNotifier<ProductFormState>{
  final Future<bool> Function( Map<String, dynamic> productLike)? onSubmitCallback;

  ProductFormNotifier({
    this.onSubmitCallback,
    required Product product
  }): super(
    ProductFormState(
      id: product.id,
      title: Title.dirty(product.title),
      slug: Slug.dirty(product.slug),
      price: Price.dirty(product.price),
      inStock: Stock.dirty(product.stock),
      sizes: product.sizes,
      gender: product.gender,
      description: product.description,
      tags: product.tags.join(', '),
      images: product.images,
    )
  );

  Future<bool> onFormSubmit() async {

    _touchedEverything();

    if ( !state.isFormValid ) return false;
    if ( onSubmitCallback == null ) return false;

    final productLike = {
      'id': (state.id == 'new' ) ? null : state.id,
      'title': state.title.value,
      'price': state.price.value,
      'description': state.description,
      'slug': state.slug.value,
      'stock': state.inStock.value,
      'sizes': state.sizes,
      'gender': state.gender,
      'tags': state.tags.split(','),
      'images': state.images.map(
        (e) => e.replaceAll("${ Environment.apiUrl }/files/products/", '')
      ).toList()
    };

    try {
      return await onSubmitCallback!( productLike );
      // return true;
    } catch (e) {
      return false;
    }

  }

  void updateProductImage( String path ){
    state = state.copyWith(
      images: [ ...state.images, path ]
    );
  }

  //TODO: FORZAR QUE TODOS LOS CAMPOS HAYAN SIDO MANIPULADOS
  void _touchedEverything(){
    state = state.copyWith(
      //Si se intentan postear los formularios
      isFormValid: Formz.validate([
        Title.dirty( state.title.value ),
        Slug.dirty( state.slug.value ),
        Price.dirty( state.price.value ),
        Stock.dirty( state.inStock.value ),
      ])
    );
  }

  void onTitleChanged ( String value ){
    state = state.copyWith(
      title: Title.dirty(value),
      isFormValid:  Formz.validate([
        Title.dirty(value),
        Slug.dirty( state.slug.value ),
        Price.dirty( state.price.value ),
        Stock.dirty( state.inStock.value ),
      ])
    );
  }

  void onSlugChanged ( String value ){
    state = state.copyWith(
      slug: Slug.dirty(value),
      isFormValid:  Formz.validate([
        Title.dirty( state.title.value ),
        Slug.dirty( value ),
        Price.dirty( state.price.value ),
        Stock.dirty( state.inStock.value ),
      ])
    );
  }

  void onPriceChanged ( double value ){
    state = state.copyWith(
      price: Price.dirty(value),
      isFormValid:  Formz.validate([
        Title.dirty( state.title.value ),
        Slug.dirty( state.slug.value ),
        Price.dirty( value ),
        Stock.dirty( state.inStock.value ),
      ])
    );
  }
  void onStockChanged ( int value ){
    state = state.copyWith(
      inStock: Stock.dirty(value),
      isFormValid:  Formz.validate([
        Title.dirty( state.title.value ),
        Slug.dirty( state.slug.value ),
        Price.dirty( state.price.value ),
        Stock.dirty( value ),
      ])
    );
  }

  //TODO: ON SIZE CHANGE
  void onSizeChange ( List<String> sizes ){
    state = state.copyWith(
      sizes: sizes
    );
  }

  void onGenderChange ( String gender ){
    state = state.copyWith(
      gender: gender
    );
  }

  void onDescriptionChange ( String description ){
    state = state.copyWith(
      description: description
    );
  }

  void onTagsChange ( String tags ){
    state = state.copyWith(
      tags: tags
    );
  }


}


class ProductFormState {
  final bool isFormValid;
  final String? id;
  final Title title;
  final Slug slug;
  final Price price;
  final List<String> sizes;
  final String gender;
  final Stock inStock;
  final String description;
  final String tags;
  final List<String> images;

  ProductFormState({
    this.isFormValid = false,
    this.id,
    this.title = const Title.dirty(""),
    this.slug = const Slug.dirty(""),
    this.price = const Price.dirty(0),
    this.sizes = const [],
    this.gender = "men",
    this.inStock = const Stock.dirty(0),
    this.description = "",
    this.tags = "", 
    this.images = const []
  });

  ProductFormState copyWith ({
    bool? isFormValid,
    String? id,
    Title? title,
    Slug? slug,
    Price? price,
    List<String>? sizes,
    String? gender,
    Stock? inStock,
    String? description,
    String? tags,
    List<String>? images,
  }) => ProductFormState(
    isFormValid: isFormValid ?? this.isFormValid,
    id: id ?? this.id,
    title: title ?? this.title,
    slug: slug ?? this.slug,
    price: price ?? this.price,
    sizes: sizes ?? this.sizes,
    gender: gender ?? this.gender,
    inStock: inStock ?? this.inStock,
    description: description ?? this.description,
    tags: tags ?? this.tags,
    images: images ?? this.images,
  );




}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_shop/features/products/presentation/providers/products_provider.dart';
import 'package:teslo_shop/features/products/presentation/widgets/product_card.dart';
import 'package:teslo_shop/features/shared/shared.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      drawer: SideMenu( scaffoldKey: scaffoldKey ),
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            onPressed: (){}, 
            icon: const Icon( Icons.search_rounded)
          )
        ],
      ),
      body: const _ProductsView(),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Nuevo producto'),
        icon: const Icon( Icons.add ),
        onPressed: () {
          context.push('/product/new');
          print("click");
          
        },
      ),
    );
  }
}


class _ProductsView extends ConsumerStatefulWidget {
  const _ProductsView();

  @override
  _ProductsViewState createState() => _ProductsViewState();
}

class _ProductsViewState extends ConsumerState{

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {    
    super.initState();
    //TODO: INFINITE SCROLL

    scrollController.addListener(() {
      if ( (scrollController.position.pixels + 400) >= scrollController.position.maxScrollExtent ) {
        ref.read( productsProvider.notifier ).loadNextPage();
        
      }
    });

    
  }

  @override
  void dispose() {    
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final productsState = ref.watch( productsProvider );

    return Padding(
      padding: const EdgeInsets.symmetric( horizontal: 10 ),
      child: MasonryGridView.count(        
        crossAxisCount: 2,
        mainAxisSpacing: 20,
        crossAxisSpacing: 35,
        controller: scrollController,
        itemCount: productsState.products.length,
        itemBuilder: (context, index) {
          final product = productsState.products[index];
          return GestureDetector(
            child: ProductCard(product: product),
            onTap: () => context.push("/product/${ product.id }"),
          );
        },

      ),
    );
  }
}




// ,        SliverAppBar(
//           pinned: false,
//           forceMaterialTransparency: false,
//           floating: true,
//           elevation: 4,
//           actions: [
//             const SizedBox(
//               width: 3,
//             ),
//             GestureDetector(
//                 child: const CircleAvatar(
//                   backgroundImage: NetworkImage(
//                       'https://www.headshotscostarica.com/static/c56f1a3d4ec59061b398ce10f6310cdd/87945/MG_2096.jpg'),
//                 ),
//                 onTap: () {
//                   print("click");
//                   // _scaffoldKey.currentState?.openDrawer();
//                 }),
//             const Spacer(),
//             FilledButton.icon(
//                 style: TextButton.styleFrom(
//                   // backgroundColor:
//                   //     const Color.fromARGB(255, 69, 69, 69).withOpacity(0.5),
//                   backgroundColor: Colors.blueGrey.shade100.withOpacity(0.5),
//                   iconColor: Colors.black,
//                   fixedSize: const Size.fromWidth(200),
//                   // textStyle: TextStyle( )
//                 ),
//                 onPressed: () {
//                   // Scaffold.of(context).openDrawer();
//                   // _scaffoldKey.currentState?.openDrawer();
//                 },
//                 icon: Icon(Icons.search_rounded),
//                 label: Text(
//                   'Search...',
//                   style: TextStyle(color: Colors.black),
//                 )),
//             const Spacer(),
//             IconButton(
//                 onPressed: () {},
//                 icon: Badge(
//                     label: Text('2'), child: Icon(Icons.message_rounded))),
//           ],
//         ),
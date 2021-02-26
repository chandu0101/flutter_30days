import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final appTheme = ThemeData(
    primarySwatch: Colors.yellow,
    textTheme: TextTheme(
        headline1: TextStyle(
            color: Colors.black,
            fontFamily: "Corben",
            fontWeight: FontWeight.w700,
            fontSize: 24)));

class ProviderCartApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => CatalogModel()),
        ChangeNotifierProxyProvider<CatalogModel, CartModel>(
            create: (context) => CartModel(),
            update: (context, catalog, cart) {
              cart?.catalog = catalog;
              return cart!;
            })
      ],
      child: MaterialApp(
        title: "Provider Cart",
        theme: appTheme,
        initialRoute: "/",
        routes: {
          "/": (context) => LoginScreen(),
          "/catalog": (context) => CatalogScreen(),
          "/cart": (context) => CartScreen()
        },
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(80),
          child: Column(
            children: [
              Text(
                'Welcome',
                style: Theme.of(context).textTheme.headline1,
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Username',
                ),
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Password',
                ),
                obscureText: true,
              ),
              SizedBox(
                height: 24,
              ),
              ElevatedButton(
                child: Text('ENTER'),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/catalog');
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.yellow,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CatalogScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: [
      _MyAppBar(),
      SliverToBoxAdapter(
        child: const SizedBox(
          height: 10,
        ),
      ),
      SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
        return _MyListItem(index: index);
      }, childCount: CatalogModel.itemNames.length))
    ]);
  }
}

class _AddButton extends StatelessWidget {
  final Item item;

  const _AddButton({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inCart =
        context.select<CartModel, bool>((value) => value.items.contains(item));
    return TextButton(
      onPressed: inCart
          ? null
          : () {
              final cart = context.read<CartModel>();
              cart.add(item);
            },
      child: inCart ? Icon(Icons.check) : Text("Add"),
      style: ButtonStyle(
          overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
        if (states.contains(MaterialState.pressed)) {
          return Theme.of(context).primaryColor;
        }
        return null;
      })),
    );
  }
}

class _MyListItem extends StatelessWidget {
  final int index;

  const _MyListItem({Key? key, required this.index}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final item = context.select<CatalogModel, Item>((value) {
      return value.getByPosition(index);
    });
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: LimitedBox(
        maxHeight: 48,
        child: Row(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                color: item.color,
              ),
            ),
            SizedBox(width: 24),
            Expanded(
              child:
                  Text(item.name, style: Theme.of(context).textTheme.headline6),
            ),
            SizedBox(width: 24),
            _AddButton(item: item),
          ],
        ),
      ),
    );
  }
}

class _MyAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      title: Text("Catalog", style: Theme.of(context).textTheme.headline1),
      actions: [
        IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.of(context).pushNamed("/cart");
            })
      ],
    );
  }
}

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
      ),
      body: Container(
        color: Colors.yellow,
        child: Column(
          children: [
            Expanded(child: _CartList()),
            Divider(
              height: 4,
              color: Colors.black,
            ),
            _CartTotal()
          ],
        ),
      ),
    );
  }
}

class _CartTotal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final hugeStyle =
        Theme.of(context).textTheme.headline1?.copyWith(fontSize: 48);
    return SizedBox(
      height: 200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Consumer<CartModel>(
              builder: (context, cart, child) =>
                  Text('\$${cart.totalPrice}', style: hugeStyle)),
          SizedBox(width: 24),
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Buying not supported yet.')));
            },
            style: TextButton.styleFrom(primary: Colors.white),
            child: Text('BUY'),
          ),
        ],
      ),
    );
  }
}

class _CartList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartModel>();
    return ListView.builder(
        itemCount: cart.items.length,
        itemBuilder: (context, index) {
          final item = cart.items[index];
          return ListTile(
            leading: Icon(Icons.done),
            title: Text(item.name),
            trailing: IconButton(
                icon: Icon(Icons.remove_circle_outline),
                onPressed: () {
                  cart.remove(item);
                }),
          );
        });
  }
}

/// A proxy of the catalog of items the user can buy.
///
/// In a real app, this might be backed by a backend and cached on device.
/// In this sample app, the catalog is procedurally generated and infinite.
///
/// For simplicity, the catalog is expected to be immutable (no products are
/// expected to be added, removed or changed during the execution of the app).
class CatalogModel {
  static List<String> itemNames = [
    'Code Smell',
    'Control Flow',
    'Interpreter',
    'Recursion',
    'Sprint',
    'Heisenbug',
    'Spaghetti',
    'Hydra Code',
    'Off-By-One',
    'Scope',
    'Callback',
    'Closure',
    'Automata',
    'Bit Shift',
    'Currying',
  ];

  /// Get item by [id].
  ///
  /// In this sample, the catalog is infinite, looping over [itemNames].
  Item getById(int id) => Item(id, itemNames[id % itemNames.length]);

  /// Get item by its position in the catalog.
  Item getByPosition(int position) {
    // In this simplified case, an item's position in the catalog
    // is also its id.
    return getById(position);
  }
}

@immutable
class Item {
  final int id;
  final String name;
  final Color color;
  final int price = 42;

  Item(this.id, this.name)
      // To make the sample app look nicer, each item is given one of the
      // Material Design primary colors.
      : color = Colors.primaries[id % Colors.primaries.length];

  @override
  int get hashCode => id;

  @override
  bool operator ==(Object other) => other is Item && other.id == id;
}

class CartModel extends ChangeNotifier {
  late CatalogModel _catalog;
  final List<int> _itemIds = [];

  CatalogModel get catalog => _catalog;
  set catalog(CatalogModel newCatalog) {
    assert(_itemIds.every((id) => newCatalog.getById(id) != null),
        'The catalog $newCatalog does not have one of $_itemIds in it.');
    _catalog = newCatalog;
    // Notify listeners, in case the new catalog provides information
    // different from the previous one. For example, availability of an item
    // might have changed.
    notifyListeners();
  }

  /// List of items in the cart.
  List<Item> get items => _itemIds.map((id) => _catalog.getById(id)).toList();

  /// The current total price of all items.
  int get totalPrice =>
      items.fold(0, (total, current) => total + current.price);

  /// Adds [item] to cart. This is the only way to modify the cart from outside.
  void add(Item item) {
    _itemIds.add(item.id);
    // This line tells [Model] that it should rebuild the widgets that
    // depend on it.
    notifyListeners();
  }

  void remove(Item item) {
    _itemIds.remove(item.id);
    // Don't forget to tell dependent widgets to rebuild _every time_
    // you change the model.
    notifyListeners();
  }
}

class CartListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

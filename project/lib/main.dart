import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void _login() {
    if (usernameController.text == 'razia' &&
        passwordController.text == '1234') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ShoppingPage()),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Invalid password")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade100,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Login", style: TextStyle(fontSize: 28)),
              const SizedBox(height: 20),
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _login, child: const Text("Login")),
            ],
          ),
        ),
      ),
    );
  }
}

class ShoppingPage extends StatefulWidget {
  const ShoppingPage({super.key});
  @override
  State<ShoppingPage> createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  final List<Map<String, dynamic>> products = [
    {'name': 'T-Shirt', 'price': 14.00},
    {'name': 'Pant', 'price': 29.00},
    {'name': 'Belt', 'price': 9.00},
    {'name': 'Hat', 'price': 12.00},
    {'name': 'Party Dress', 'price': 59.00},
    {'name': 'Jeans', 'price': 3.00},
    {'name': 'Jacket', 'price': 9.99},
    {'name': 'Shoes', 'price': 3.00},
    {'name': 'Tops', 'price': 4.00},
  ];

  final List<Map<String, dynamic>> cart = [];

  void addToCart(Map<String, dynamic> product) {
    setState(() => cart.add(product));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("${product['name']} added to cart")));
  }

  void openCart() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => CartPage(
              cartItems: cart,
              onRemove: (item) => setState(() => cart.remove(item)),
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("A Random Store"),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: openCart,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed:
                () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                ),
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final item = products[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(item['name'], style: const TextStyle(fontSize: 16)),
                Text("\$${item['price'].toStringAsFixed(2)}"),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => addToCart(item),
                  child: const Text("Buy now"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class CartPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final Function(Map<String, dynamic>) onRemove;

  const CartPage({super.key, required this.cartItems, required this.onRemove});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  double get total =>
      widget.cartItems.fold(0, (sum, item) => sum + (item['price'] as double));

  void removeItem(Map<String, dynamic> item) {
    setState(() => widget.onRemove(item));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${item['name']} removed from cart")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Cart"),
        backgroundColor: Colors.blue,
      ),
      body:
          widget.cartItems.isEmpty
              ? const Center(child: Text("Your cart is empty"))
              : ListView.builder(
                itemCount: widget.cartItems.length,
                itemBuilder: (context, index) {
                  final item = widget.cartItems[index];
                  return ListTile(
                    title: Text(item['name']),
                    subtitle: Text("\$${item['price'].toStringAsFixed(2)}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => removeItem(item),
                    ),
                  );
                },
              ),
      bottomNavigationBar: Container(
        color: Colors.blue,
        padding: const EdgeInsets.all(16),
        child: Text(
          "Total: \$${total.toStringAsFixed(2)}",
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}

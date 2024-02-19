/*import 'package:flutter/material.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FilieraToken-Shop',
      home: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('FilieraToken-Shop')), // Centra la scritta
          leading: Image.asset('../assets/favicon.png'),
        ),
        body: const Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center, // Centra la riga
            children: <Widget>[
            ],
          ),
        ),
      ),
    );
  }
}*/




import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile Product Acquistati',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Profile Product Acquistati'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({
    Key? key, 
    required this.title
    }) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _buildHeader(),
            _buildNavigationBar(),
           // _buildProductsGrid(),
            _buildButtons(),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: <Widget>[
        Image.asset('../assets/favicon.png'),
        Text('Filiera Token Shop'),
        Spacer(),
        IconButton(
          icon: Icon(Icons.logout),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildNavigationBar() {
    return Container(
      color: Colors.grey,
      child: Text(
        'Pagina - Profile Product Acquistati',
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildProductsGrid() {
  return GridView.count(
    crossAxisCount: 2,
    childAspectRatio: 1.5,
    mainAxisSpacing: 10.0,
    crossAxisSpacing: 10.0,
    children: List.generate(12, (index) {
      return ProductCard();
    }),
  );
}


  Widget _buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        ElevatedButton(
          child: Text('History'),
          onPressed: () {},
        ),
        ElevatedButton(
          child: Text('Profile'),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Container(
      color: Colors.grey,
      child: Text(
        'Back',
        textAlign: TextAlign.center,
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Image.asset('../assets/favicon.png'),
          Text('Prodotto 1'),
        ],
      ),
    );
  }
}


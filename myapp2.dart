import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Muahang extends StatelessWidget {
  const Muahang({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  late Future<List<Product>> lsProduct;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    lsProduct = Product.fetchData();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: lsProduct,
        builder: (BuildContext context,
            AsyncSnapshot<dynamic> snapshot){
          if (snapshot.hasData){
            List<Product> data = snapshot.data;
            return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index){
                  var product = data[index];
                  return Card(
                        elevation: 0,
                        child: ListTile(

                        leading: Image.network(product.image, width: 80,)   ,
                        title: Column(
                          children: [
                            Text(product.title,textDirection: TextDirection.ltr ,style: TextStyle(fontWeight: FontWeight.bold,),),
                            Text("Giá : "+ product.price.toString() +" VNĐ",textDirection: TextDirection.ltr , style: TextStyle(color: Colors.red),),
                            Text(product.description, textDirection: TextDirection.ltr,style: TextStyle(color: Colors.blueGrey),overflow: TextOverflow.ellipsis, softWrap: false,),
                          ],
                        ),
                          trailing: IconButton(onPressed: () => showBox(context),
                              color: Colors.red,
                              padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                              icon: Icon(Icons.add_shopping_cart_outlined)),

                    ),
                  );
                });
          }
          else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
showBox(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Nhập số lượng mua:'),
        content: TextField(
          onChanged: (value) { },
          decoration: InputDecoration(hintText: "Số lượng"),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel',textAlign: TextAlign.left,),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK',textAlign: TextAlign.right,),
          ),
        ],
      );
    },
  );
}
// class Rating{
//   final double rate;
//   final int count;
//
//   Rating(this.rate, this.count);
//
// }

class Product{
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final Map rating;

  Product(this.id, this.title, this.price, this.description, this.category,
      this.image, this.rating);

  static Future<List<Product>> fetchData() async{
    String url = "https://fakestoreapi.com/products";
    var client = http.Client();
    var response = await client.get(Uri.parse(url));
    if (response.statusCode==200){
      var result = response.body;
      var jsonData = jsonDecode(result);
      List<Product> lsProduct =[];
      for(var item in jsonData){
        var id = item['id'];
        var title = item['title'];
        var price = item['price'];
        var description = item['description'];
        var category = item['category'];
        var image = item['image'];
        // var rt = item['rating'];
        var rating = item['rating'];
        // for(var rating_item in rt) {
        //   var rate = rating_item['rate'];
        //   var count = rating_item['count'];
        //   Rating rating = new Rating(rate, count);
          Product p = new Product(id, title, price, description, category, image, rating);
          lsProduct.add(p);
        // }

      }
      return lsProduct;
    }else{
      print(response.statusCode);
      throw Exception("Loi lay du lieu");
    }
  }
}



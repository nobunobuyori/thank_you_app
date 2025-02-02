import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coupon App',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: CouponListScreen(),
    );
  }
}

class CouponListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('クーポン'),
      ),
      body: CouponListView(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddCouponScreen()),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.local_offer),
            label: 'クーポン',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: 'お店',
          ),
        ],
        currentIndex: 0,
      ),
    );
  }
}

class CouponListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('coupons').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final coupons = snapshot.data!.docs;

        return ListView.builder(
          itemCount: coupons.length,
          itemBuilder: (context, index) {
            final coupon = coupons[index];
            return ListTile(
              title: Text(coupon['productName']),
              subtitle: Text('値段: ${coupon['price']}円 \n 割引後: ${coupon['discountedPrice']}円'),
            );
          },
        );
      },
    );
  }
}

class AddCouponScreen extends StatelessWidget {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController discountedPriceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('クーポンを追加'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: productNameController,
              decoration: InputDecoration(labelText: '商品名'),
            ),
            TextField(
              controller: priceController,
              decoration: InputDecoration(labelText: '値段'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: discountedPriceController,
              decoration: InputDecoration(labelText: '割引後の値段'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await FirebaseFirestore.instance.collection('coupons').add({
                  'productName': productNameController.text,
                  'price': int.parse(priceController.text),
                  'discountedPrice': int.parse(discountedPriceController.text),
                });
                Navigator.pop(context);
              },
              child: Text('追加'),
            ),
          ],
        ),
      ),
    );
  }
}

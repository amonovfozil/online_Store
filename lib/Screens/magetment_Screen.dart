import 'package:flutter/material.dart';
import 'package:online_market/models/product_model.dart';
import 'package:online_market/widgets/Sidebar.dart';
import 'package:provider/provider.dart';

class ManegmentScreen extends StatefulWidget {
  @override
  State<ManegmentScreen> createState() => _ManegmentScreenState();
}

class _ManegmentScreenState extends State<ManegmentScreen> {
  Future<void> _refreshPage(BuildContext context) async {
    await Provider.of<ProductList>(context, listen: false)
        .getProductsInFireBase(true);
  }

  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      isLoading = true;
    });
    Future.delayed(Duration.zero).then((value) => {
          Provider.of<ProductList>(context, listen: false)
              .getProductsInFireBase(true)
              .then((value) => {
                    setState(() {
                      isLoading = false;
                    })
                  })
        });
  }

  @override
  Widget build(BuildContext context) {
    // final products = Provider.of<ProductList>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text('Mahsulotlarni boshqarish'),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: IconButton(
                onPressed: () =>
                    Navigator.of(context).pushNamed('EditAddScreen'),
                icon: Icon(
                  Icons.add_chart_sharp,
                  size: 25,
                ),
              ),
            )
          ],
        ),
        drawer: SideBar(),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: () => _refreshPage(context),
                child: Consumer<ProductList>(builder: ((ctx, productss, _) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: productss.Lists.length,
                    itemBuilder: ((context, index) {
                      final product = productss.Lists[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: product.url.startsWith('assets/')
                                ? CircleAvatar(
                                    backgroundImage: AssetImage(product.url),
                                  )
                                : CircleAvatar(
                                    backgroundImage: NetworkImage(product.url),
                                  ),
                            title: Text(
                              product.Title,
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () => Navigator.of(context)
                                      .pushNamed('EditAddScreen',
                                          arguments: product.id),
                                  icon: Icon(
                                    Icons.edit,
                                    size: 18,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: ((context) {
                                          return AlertDialog(
                                            titlePadding: const EdgeInsets.only(
                                                left: 40, top: 20),
                                            contentPadding:
                                                const EdgeInsets.only(
                                                    left: 50,
                                                    top: 10,
                                                    bottom: 10),
                                            actionsAlignment:
                                                MainAxisAlignment.center,
                                            title:
                                                Text('Ishonchingiz komilmi?'),
                                            content: Text(
                                                'Mahsulotlarni o\`chirishga'),
                                            actions: [
                                              ElevatedButton(
                                                onPressed: () =>
                                                    Navigator.of(context).pop(),
                                                child: Text('YUQ'),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  productss.DeleteProduct(
                                                      product.id);
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('HA'),
                                              )
                                            ],
                                          );
                                        }));
                                  },
                                  icon: Icon(
                                    Icons.delete_outline,
                                    size: 20,
                                    color: Theme.of(context).errorColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                })),
              ));
  }
}

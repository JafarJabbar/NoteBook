import 'package:flutter/material.dart';
import 'package:notebook/models/categories.dart';
import 'package:notebook/utils/database_helper.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  DatabaseHelper dbHelper;
  List<Categories> categoriesList;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbHelper=DatabaseHelper();
  }

  @override
  Widget build(BuildContext context) {

    if(categoriesList==null){
      categoriesList=List<Categories>();
      dbHelper.getCategoryList()
      .then((value) {
        setState(() {
          categoriesList=value;
        });
      });
    }
    var scaffold=GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffold,
        appBar: AppBar(
          title: Text("Kateqoriyalar"),
        ),
      body: Container(
        child: ListView.builder(itemCount : categoriesList.length,itemBuilder: (context,index){
          return ListTile(
            title: Text(categoriesList[index].category_title),
            leading: Icon(Icons.category),
            trailing: InkWell(
              child: Icon(Icons.delete,),
              onTap: (){
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context){
                    return AlertDialog(
                      title: Text("Silmək istədiyinizdən əminsiniz?"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text('Kateqoriya silinərsə buna bağlı qeydlərdə silinəcək.'),
                          ButtonBar(
                            children: <Widget>[
                              RaisedButton(color: Colors.red,onPressed: ()=>Navigator.pop(context),child: Row(children: <Widget>[Text("Ləğv et"),Icon(Icons.cancel)],),),
                              RaisedButton(
                              color: Theme.of(context).primaryColor,onPressed: (){
                                dbHelper.deleteCategory(categoriesList[index].category_id).then((value){
                                });
                                setState(() {});
                                Navigator.pop(context);
                                scaffold.currentState.showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.green,
                                      content: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text('Kateqoriya uğurla əlavə olundu!'),
                                          Icon(Icons.done)
                                        ],
                                      ),
                                      duration: Duration(seconds: 3),
                                    )
                                );

                              },child: Row(children: <Widget>[Text("Sil"),Icon(Icons.delete)],),),
                            ],
                          )
                        ],
                      ),
                    );
                  }
                );
              },
            ),
          );
        }),
      ),
    );
  }
}

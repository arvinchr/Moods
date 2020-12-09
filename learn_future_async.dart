void main() async {
  /*getOrder().then((value) {
    print('Anda memesan: $value');
  }).catchError((error) {
    print('Maaf $error pesanan anda tidak dapat diproses');
  }).whenComplete(() {
    print('Terima Kasih');
  });*/
  print('Menunggu pesanan anda');
  try {
    var order = await getOrder();
    print('Anda memesan $order');
  }catch(error){
    print('Maaf $error');
  }finally{
    print('Terima Kasih');
  }
}

Future<String> getOrder(){
 return Future.delayed(Duration(seconds: 2),() {
   bool isWagyuAvailable = false;
   if(isWagyuAvailable) {
     return 'Wagyu Steak';
   }else {
    throw 'Wagyu Steak Sold Out';
   }
 });
}


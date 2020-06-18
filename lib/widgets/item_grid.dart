//Item List Grid

import 'package:auto_size_text/auto_size_text.dart';
import 'package:daily_kitchen_base/data/models/item.dart';
import 'package:daily_kitchen_base/data/repositories/item_repository.dart';
import 'package:daily_kitchen_base/data/repositories/user_repository.dart';
import 'package:daily_kitchen_base/theme/constants.dart';
import 'package:daily_kitchen_base/widgets/custom_clippers.dart';
import 'package:flutter/material.dart';

class ItemGrid extends StatelessWidget {
  List<Item> items;
  UserRepository userRepository;
  ItemRepository itemRepository;
  ItemGrid({
    Key key,
    @required this.userRepository,
    @required this.itemRepository,
    @required this.items,
    @required this.context,
  }) : super(key: key);

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height) / 2.5;
    final double itemWidth = size.width / 2;
    return Container(
      
      child: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: (itemWidth / itemHeight),
        crossAxisSpacing: 5,
        mainAxisSpacing: 10,
        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
        children: List<ItemTile>.generate(items.length, (index) {
          return ItemTile(
            tileItem: items[index],
            context: context,
            onTapRoute:null
              //  ItemViewPage(itemRepository: itemRepository, item: items[index]),
          );
        }),
      ),
    );
  }
}

//Item Tile
class ItemTile extends StatelessWidget {
  Widget onTapRoute;
  Item tileItem;
  ItemTile({
    Key key,
    @required this.tileItem,
    this.onTapRoute,
    @required this.context,
  }) : super(key: key);

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) {
            return onTapRoute;
          },
        ));
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0,0),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black38, blurRadius: 5, offset: Offset(2, 2))
            ],
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Stack(
                children: [
                  Container(
                    height: 150,
                    margin: EdgeInsets.all(5),
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: tileItem.imageUrls.length > 0
                                ? NetworkImage(
                                    tileItem.imageUrls.first.toString())
                                : NetworkImage(
                                    "https://image.shutterstock.com/image-vector/no-image-available-icon-vector-260nw-1323742826.jpg"))),
                  ),
                  if (tileItem.discount > 0)
                    ClipPath(
                      clipper: OfferClipper(),
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                        padding: EdgeInsets.fromLTRB(5, 5, 10, 5),
                        decoration:
                            BoxDecoration(color: DKTheme.orange, boxShadow: [
                          BoxShadow(
                              offset: Offset(2, 2),
                              color: Colors.black,
                              blurRadius: 2),
                        ]),
                        child: AutoSizeText("${tileItem.discount} % Off",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            )),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child:
                  Padding(
                    padding: const EdgeInsets.fromLTRB(2, 0, 2, 2),
                    child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                AutoSizeText(
                    tileItem.title,
                    maxFontSize: 20,
                    minFontSize: 15,
                    textAlign: TextAlign.center,
                    style: DKTheme.medCapsOnStyle,
                    maxLines: 1,
                ),
                AutoSizeText(
                    tileItem.description.length > 40
                        ? "${tileItem.description.substring(0, 40)}...."
                        : tileItem.description,
                    maxFontSize: 18,
                    minFontSize: 12,
                    textAlign: TextAlign.left,
                    //style: DKTheme.medCapsOnStyle,
                    maxLines: 2,
                ),
                AutoSizeText.rich(
                    TextSpan(
                        style: TextStyle(fontSize: 17, color: Colors.grey[500]),
                        children: [
                          TextSpan(
                              text: "Prize  ",
                              style: TextStyle(fontWeight: FontWeight.w300)),
                          TextSpan(
                              text:
                                  "Rs.${tileItem.ratePerQuantity} / ${tileItem.rateUnit}"),
                        ]),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                ),
              ]),
                  ),
            )
          ],
        ),
      ),
    );
  }
}

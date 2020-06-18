import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:daily_kitchen_base/data/models/item.dart';
import 'package:daily_kitchen_base/data/models/location.dart';
import 'package:daily_kitchen_base/data/repositories/item_repository.dart';
import 'package:daily_kitchen_base/data/repositories/shop_setting_repository.dart';
import 'package:daily_kitchen_base/data/repositories/user_repository.dart';
import 'package:daily_kitchen_base/theme/constants.dart';
import 'package:daily_kitchen_base/widgets/custom_clippers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';


enum FocusNav { unfocus, next, previous }

class WhiteRoundedTextBox extends StatelessWidget {
  TextEditingController controller;
  String hintText = "", label = "";
  Function onChangedFunction;
  TextInputType keyboardType;
  bool hideText, readOnly;
  TextInputAction textInputAction;
  Function onSubmitted;
  FocusNav focusNav;
  int maxLength;
  final focus = FocusNode();
  WhiteRoundedTextBox(
      {@required this.controller,
      this.hintText,
      this.label,
      this.readOnly = false,
      this.onChangedFunction,
      this.keyboardType,
      this.maxLength = null,
      this.textInputAction = TextInputAction.next,
      this.focusNav = FocusNav.next,
      this.hideText = false});
  @override
  Widget build(BuildContext context) {
    switch (focusNav) {
      case FocusNav.unfocus:
        {
          this.onSubmitted = (_) => FocusScope.of(context).unfocus();
          break;
        }
      case FocusNav.next:
        {
          this.onSubmitted = (_) => FocusScope.of(context).nextFocus();
          break;
        }
      case FocusNav.previous:
        {
          this.onSubmitted = (_) => FocusScope.of(context).previousFocus();
          break;
        }
    }
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            SizedBox(width: 20),
            Text(label),
          ],
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(15, 4, 2, 2),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(50), right: Radius.circular(0)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black38, offset: Offset(4, 4), blurRadius: 5),
              ]),
          child: TextField(
            autofocus: false,
            readOnly: readOnly,
            //focusNode: focus,
            obscureText: hideText,
            textInputAction: textInputAction,
            keyboardType: keyboardType,
            maxLength: maxLength,
            onChanged: onChangedFunction,
            controller: controller,
            onSubmitted: onSubmitted,
            decoration: InputDecoration(
                hintText: hintText,
                counter: Container(),
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.white),
          ),
        ),
      ],
    );
  }
}

class WhiteRoundedDropDownField extends StatefulWidget {
  //UserRepository userRepository;
  ShopSettingsRepository shopSettingsRepository;
  Function onChanged;
  String initialValue;
  WhiteRoundedDropDownField(
      {@required this.shopSettingsRepository,
      @required this.onChanged,
      this.initialValue});
  @override
  _WhiteRoundedDropDownFieldState createState() =>
      _WhiteRoundedDropDownFieldState();
}

class _WhiteRoundedDropDownFieldState extends State<WhiteRoundedDropDownField> {
  String label = "Location", location;
  List<Location> locationList;
  List<DropdownMenuItem> locationMenuOptions = [];
  var currentValue;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    widget.shopSettingsRepository.getLocations().then((response) {
      locationList = response;
      if (locationList.length > 0) {
        location = "${locationList[0].city} - ${locationList[0].locality}";
      }
      for (var each in locationList) {
        setState(() {
          locationMenuOptions.add(DropdownMenuItem(
            child: Text("${each.city} - ${each.locality}"),
            value: "${each.city} - ${each.locality}",
          ));
        });
      }

      if (widget.initialValue != null) {
        setState(() {
          location = widget.initialValue;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            SizedBox(width: 20),
            Text(label),
          ],
        ),
        Container(
          padding: EdgeInsets.fromLTRB(20, 2, 2, 2),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(50), right: Radius.circular(0)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black38, offset: Offset(4, 4), blurRadius: 5),
              ]),
          height: 50,
          child: DropdownButton(
            value: location,
            isExpanded: true,
            icon: Container(),
            underline: Container(),
            items: locationMenuOptions,
            onChanged: (value) {
              setState(() {
                location = value;
                widget.onChanged(value);
              });
            },
          ),
        ),
      ],
    );
  }
}

class OneSideRoundedBtn extends StatelessWidget {
  String text;
  Color color, bgColor;
  Function onPressed;
  bool shadow;
  Gradient gradient;
  OneSideRoundedBtn(
      {@required this.text,
      @required this.onPressed,
      this.color = Colors.white,
      this.bgColor,
      this.gradient = DKTheme.greenShade,
      this.shadow = true}) {
    if (bgColor != null) {
      gradient = null;
    }
  }
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Container(
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
              gradient: gradient,
              color: bgColor,
              borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(50), right: Radius.circular(0)),
              boxShadow: shadow
                  ? [
                      BoxShadow(
                          color: Colors.black38,
                          offset: Offset(4, 4),
                          blurRadius: 5),
                    ]
                  : []),
          child: Center(
            child: Text(
              text,
              style: TextStyle(color: color, fontSize: 20),
            ),
          )),
      onPressed: onPressed,
    );
  }
}

//DailyKitchen Theme Toast
class DKToast {
  static Future<bool> showToast({@required String message}) {
    return Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: DKTheme.greenLight,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}

class LoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitWave(
        color: DKTheme.green1,
      ),
    );
  }
}
//Item List Grid

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
                //ItemViewPage(itemRepository: itemRepository, item: items[index]),
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

///PopUp Menu

//ImageSlider
class ImageSlider extends StatelessWidget {
  List<List> sliderImages = [
    [AssetImage('images/slider/fish.jpg'), "Fresh & Hygienic"],
    [AssetImage('images/slider/chicken.jpg'), "Halal & Hygienic"],
    [AssetImage('images/slider/fruits.jpg'), "Ripe & Delicious"],
    [AssetImage('images/slider/beef.jpg'), "Halal & Hygienic"],
    [AssetImage('images/slider/vegetables.jpg'), "Fresh & Ripe"],
    [AssetImage('images/slider/grocery.png'), "Kitchen @ doorstep"],
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      child: Stack(
        children: <Widget>[
          CarouselSlider(
            items: sliderImages.map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: i[0],
                        fit: BoxFit.cover,
                      )),
                      child: Container(
                        padding: EdgeInsets.only(bottom: 20),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            decoration: BoxDecoration(
                                gradient: DKTheme.greenShadeTlBr,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child: Text(
                              i[1],
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.white),
                            ),
                          ),
                        ),
                      ));
                },
              );
            }).toList(),
            options: CarouselOptions(
                height: 240.0,
                viewportFraction: 1.0,
                autoPlayInterval: Duration(seconds: 5),
                autoPlay: true),
          ),
          Positioned(
            top: 225,
            child: Column(
              children: <Widget>[
                Container(
                  height: 100,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      gradient: DKTheme.greenShade,
                      borderRadius: BorderRadius.vertical(
                          top: Radius.circular(25),
                          bottom: Radius.circular(0))),
                ),
              ],
            ),
          ),
          Positioned(
            top: 230,
            child: Column(
              children: <Widget>[
                Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.vertical(
                          top: Radius.circular(25),
                          bottom: Radius.circular(0))),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

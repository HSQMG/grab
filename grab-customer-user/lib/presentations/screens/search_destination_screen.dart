import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grab/controller/map_controller.dart';
import 'package:grab/data/model/search_place_model.dart';
import 'package:grab/presentations/screens/book_ride_screen.dart';
import 'package:grab/state.dart';
import 'package:grab/utils/constants/type_place.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class SearchDestinationceScreen extends StatefulWidget {
  const SearchDestinationceScreen({Key? key}) : super(key: key);

  @override
  State<SearchDestinationceScreen> createState() =>
      _SearchDestinationceScreenState();
}

class _SearchDestinationceScreenState extends State<SearchDestinationceScreen> {
  late List<SearchPlaceModel> searchedDestinations = [];
  late List<SearchPlaceModel> searchedPickup = [];
  late bool isPickupSelected = false;
  late bool isDestinationSelected = false;
  final searchDestinationTextController = TextEditingController();
  final searchPickupTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchPickupTextController.addListener(() {
      setState(() {
        isPickupSelected = false;
      });
    });

    searchDestinationTextController.addListener(() {
      setState(() {
        isDestinationSelected = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          icon: const Icon(
            Icons.cancel_outlined,
            color: Colors.black,
          ),
          onPressed: () {
            finish(context);
          },
          constraints: const BoxConstraints.tightFor(
            width: 20,
            height: 20,
          ),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextFormField(
                      controller: searchPickupTextController,
                      onChanged: (address) async {
                        MapController().searchPlaces(address).then((places) => {
                              setState(() {
                                searchedPickup = places;
                                isPickupSelected = true;
                              })
                            });
                      },
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                          hintText: 'Nhập địa điểm bắt đầu',
                          prefixIcon: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: SvgPicture.asset(
                              "assets/icons/location_from.svg",
                            ),
                          )),
                    ),
                    if (searchedPickup.isNotEmpty && isPickupSelected)
                      ListSearchedPlaces(
                        searchedPlaces: searchedPickup,
                        textController: searchPickupTextController,
                        type: TypePlace.pickup,
                      ),
                  ],
                ),
              ),
            ),
            const Divider(
              height: 2,
              thickness: 2,
              color: Color(0xFFF8F8F8),
            ),
            Form(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextFormField(
                      controller: searchDestinationTextController,
                      onChanged: (address) async {
                        MapController().searchPlaces(address).then((places) => {
                              setState(() {
                                searchedDestinations = places;
                                isDestinationSelected = true;
                              })
                            });
                      },
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                        hintText: 'Nhập địa điểm đến',
                        prefixIcon: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: SvgPicture.asset(
                            "assets/icons/location_to.svg",
                          ),
                        ),
                      ),
                    ),
                    if (searchedDestinations.isNotEmpty &&
                        isDestinationSelected)
                      ListSearchedPlaces(
                        searchedPlaces: searchedDestinations,
                        textController: searchDestinationTextController,
                        type: TypePlace.destination,
                      ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BookingRideScreen()));
              },
              child: const Text('Xác nhận'),
            ),
          ],
        ),
      ),
    );
  }
}

class ListSearchedPlaces extends StatelessWidget {
  const ListSearchedPlaces({
    super.key,
    required this.searchedPlaces,
    required this.textController,
    required this.type,
  });

  final List<SearchPlaceModel> searchedPlaces;
  final TextEditingController textController;
  final String type;

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<AppState>(context);
    return ListView.builder(
      shrinkWrap: true,
      itemCount: searchedPlaces.length,
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () {
            textController.text = searchedPlaces[index].stringName;

            switch (type) {
              case TypePlace.pickup:
                appState.setPickupAddress(searchedPlaces[index]);
                break;
              case TypePlace.destination:
                appState.setDestinationAddress(searchedPlaces[index]);
                break;
            }
          },
          title: Text(
            searchedPlaces[index].stringName,
            maxLines: 2,
            style: const TextStyle(fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
        );
      },
    );
  }
}

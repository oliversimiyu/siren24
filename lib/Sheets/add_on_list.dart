import 'package:flutter/material.dart';
import 'package:siren24/Models/facility.dart';
import 'package:siren24/services/facility_service.dart';
import '../my-globals.dart' as globals;

class AddOnList extends StatefulWidget {
  final DraggableScrollableController addoncontroller;
  final VoidCallback addnext;
  final String ambid;
  AddOnList(
      {required this.addoncontroller,
      required this.addnext,
      required this.ambid,
      Key? key})
      : super(key: key);

  @override
  State<AddOnList> createState() => _AddOnListState();
}

class _AddOnListState extends State<AddOnList> {
  List<Color> facilityColors = [];
  List<Facility> selectedFacilities = [];
  List<Facility> availableFacilities = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadFacilities();
  }

  void loadFacilities() {
    setState(() {
      isLoading = true;
    });

    // Simulate loading delay
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        availableFacilities = FacilityService.getNearbyFacilities();
        facilityColors =
            List.generate(availableFacilities.length, (index) => Colors.white);
        isLoading = false;
      });
    });
  }

  void toggleFacilitySelection(int index) {
    setState(() {
      if (facilityColors[index] == Colors.white) {
        // Select facility
        facilityColors[index] = Color(0xff4C6EE5).withOpacity(0.5);
        selectedFacilities.add(availableFacilities[index]);
      } else {
        // Deselect facility
        facilityColors[index] = Colors.white;
        selectedFacilities.remove(availableFacilities[index]);
      }
      // Update global variables for compatibility
      globals.addons = selectedFacilities.map((f) => f.name).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
          color: Colors.white),
      child: ListView(
        children: [
          SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Medical Facilities',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Choose hospitals or medical centers for your emergency service',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          isLoading
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(
                      color: Color(0xff4C6EE5),
                    ),
                  ),
                )
              : availableFacilities.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          'No facilities available',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: availableFacilities.length,
                      itemBuilder: (BuildContext context, int index) {
                        Facility facility = availableFacilities[index];
                        return Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 12),
                              color: Colors.white,
                              child: GestureDetector(
                                onTap: () => toggleFacilitySelection(index),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: facilityColors[index],
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color:
                                          facilityColors[index] == Colors.white
                                              ? Colors.grey[300]!
                                              : Color(0xff4C6EE5),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  facility.name,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                                SizedBox(height: 4),
                                                Text(
                                                  facility.type,
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.blue[600],
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                SizedBox(height: 4),
                                                Text(
                                                  facility.address,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey[600],
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 8, vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: Colors.green[100],
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Text(
                                                  '${facility.distance} km',
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.green[700],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.star,
                                                    size: 12,
                                                    color: Colors.amber[600],
                                                  ),
                                                  SizedBox(width: 2),
                                                  Text(
                                                    '${facility.rating}',
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.grey[600],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                          ],
                        );
                      },
                    ),
          SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              border: Border(
                top: BorderSide(color: Colors.grey[300]!, width: 1),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${selectedFacilities.length} facilities selected',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      if (selectedFacilities.isNotEmpty) ...[
                        SizedBox(height: 4),
                        Text(
                          selectedFacilities
                                  .map((f) => f.name)
                                  .take(2)
                                  .join(', ') +
                              (selectedFacilities.length > 2 ? '...' : ''),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: widget.addnext,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0XFF4C6EE5),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0XFF4C6EE5).withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

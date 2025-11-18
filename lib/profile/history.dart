import 'package:flutter/material.dart';
import 'package:siren24/Models/history_model.dart';
import 'package:siren24/state/api_calling.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import '../services/ride_history_service.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);
  static String id = 'history';
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  // Combine local history and API history
  Future<List<HistoryModel>> _getCombinedHistory() async {
    List<HistoryModel> combinedHistory = [];

    try {
      // Get local history first (faster response)
      List<HistoryModel> localHistory =
          await RideHistoryService.getHistoryModels();
      combinedHistory.addAll(localHistory);

      // Try to get API history (may fail in demo mode)
      try {
        List<HistoryModel> apiHistory = await ApiCaller().GetHistory();
        combinedHistory.addAll(apiHistory);
      } catch (e) {
        print('API history unavailable, showing local history only: $e');
      }

      // Sort by date (most recent first)
      combinedHistory.sort((a, b) {
        DateTime? dateA = DateTime.tryParse(a.orderDate ?? '');
        DateTime? dateB = DateTime.tryParse(b.orderDate ?? '');
        if (dateA == null || dateB == null) return 0;
        return dateB.compareTo(dateA);
      });
    } catch (e) {
      print('Error getting combined history: $e');
    }

    return combinedHistory;
  }

  Future<String?> getAddress(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        return "${place.street}, ${place.locality}, ${place.country}";
      }
    } catch (e) {
      print("Error getting address: $e");
    }
    return "Address not found";
  }

  Widget _buildHistoryCard(HistoryModel ride) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        child: Column(
          children: [
            // Header with ride type and date
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF4C6EE5).withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        ride.orderType == 'scheduled'
                            ? Icons.schedule
                            : Icons.flash_on,
                        color: const Color(0xFF4C6EE5),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        ride.orderType == 'scheduled'
                            ? 'Scheduled Ride'
                            : 'Immediate Ride',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4C6EE5),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    _formatDate(ride.orderDate),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            // Location details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Route indicators
                  Column(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: Color(0xFF4C6EE5),
                          shape: BoxShape.circle,
                        ),
                      ),
                      Container(
                        width: 2,
                        height: 40,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                      Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),

                  // Addresses
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildAddressRow(
                            "From", ride.source?.lat, ride.source?.lng),
                        const SizedBox(height: 32),
                        _buildAddressRow(
                            "To", ride.destination?.lat, ride.destination?.lng),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Divider
            Container(
              height: 1,
              color: Colors.grey[200],
            ),

            // Bottom section with amount and status
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.attach_money,
                        color: Colors.green,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'KSH ${ride.orderAmount ?? 0}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getStatusColor(ride.orderStatus).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: _getStatusColor(ride.orderStatus),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      ride.orderStatus ?? 'Unknown',
                      style: TextStyle(
                        fontSize: 14,
                        color: _getStatusColor(ride.orderStatus),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressRow(String label, double? lat, double? lng) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        if (lat != null && lng != null)
          FutureBuilder<String?>(
            future: getAddress(lat, lng),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text(
                  'Address unavailable',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[600],
                  ),
                );
              }
              if (snapshot.hasData) {
                return Text(
                  snapshot.data.toString(),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                );
              }
              return const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4C6EE5)),
                ),
              );
            },
          )
        else
          const Text(
            'Location not available',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey,
            ),
          ),
      ],
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'Unknown date';

    try {
      DateTime date = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy • HH:mm').format(date);
    } catch (e) {
      return 'Invalid date';
    }
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      case 'in_progress':
        return const Color(0xFF4C6EE5);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 250,
                width: width,
                color: Color(0Xff4C6EE5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 40,
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.chevron_left,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'History',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            color: Colors.transparent,
            margin: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 155,
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                    child: FutureBuilder<List<HistoryModel>>(
                      future: _getCombinedHistory(),
                      builder: (
                        BuildContext context,
                        AsyncSnapshot<List<HistoryModel>> snapshot,
                      ) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFF4C6EE5)),
                            ),
                          );
                        } else if (snapshot.connectionState ==
                            ConnectionState.done) {
                          if (snapshot.hasError) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.error_outline,
                                    size: 60,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'Error loading history',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else if (snapshot.hasData) {
                            List<HistoryModel>? data = snapshot.data;

                            return data!.isEmpty
                                ? Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.history,
                                          size: 80,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(height: 20),
                                        const Text(
                                          'No ride history yet',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        const Text(
                                          'Your completed rides will appear here',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  )
                                : ListView.builder(
                                    itemCount: data.length,
                                    itemBuilder: (context, index) =>
                                        _buildHistoryCard(data[index]),
                                  );
                          } else {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.history,
                                    size: 80,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(height: 20),
                                  const Text(
                                    'No ride history yet',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    'Your completed rides will appear here',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 30),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF4C6EE5),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 30,
                                        vertical: 15,
                                      ),
                                    ),
                                    child: const Text(
                                      'Book Your First Ride',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                        } else {
                          return Text('State: ${snapshot.connectionState}');
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

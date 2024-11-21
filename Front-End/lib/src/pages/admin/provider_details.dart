import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:seyoni/src/constants/constants_color.dart';
import 'dart:convert';
import '../../widgets/background_widget.dart';
import '../../constants/constants_font.dart';
import '../../widgets/custom_button.dart';
import '../../config/url.dart';

class ProviderDetails extends StatefulWidget {
  final String providerId;

  const ProviderDetails({super.key, required this.providerId});

  @override
  State<ProviderDetails> createState() => _ProviderDetailsState();
}

class _ProviderDetailsState extends State<ProviderDetails> {
  late Map<String, dynamic> providerDetails;
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchProviderDetails();
  }

  Future<void> _fetchProviderDetails() async {
    try {
      final response =
          await http.get(Uri.parse('$getProvidersUrl/${widget.providerId}'));
      if (response.statusCode == 200) {
        setState(() {
          providerDetails = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception(
            'Failed to load provider details ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load provider details: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _approveProvider() async {
    try {
      final response = await http.patch(
        Uri.parse('$updateProviderStatusUrl/${widget.providerId}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'isApproved': true}),
      );

      if (response.statusCode == 200) {
        Navigator.pop(context, true);
      } else {
        final errorBody = jsonDecode(response.body);
        throw Exception(errorBody['message'] ??
            'Failed to approve provider ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to approve provider: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _rejectProvider() async {
    try {
      final response = await http
          .delete(Uri.parse('$updateProviderStatusUrl/${widget.providerId}'));
      if (response.statusCode == 200) {
        Navigator.pop(context, true);
      } else {
        throw Exception('Failed to reject provider ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to reject provider: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(
          child: BackgroundWidget(child: SizedBox.expand()),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text('Provider Details', style: kAppBarTitleTextStyle),
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                  color: kPrimaryColor,
                ))
              : errorMessage.isNotEmpty
                  ? Center(
                      child: Text(
                        errorMessage,
                        style: const TextStyle(color: Colors.red, fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Profile section
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 20,
                                  ),
                                  decoration: BoxDecoration(
                                    border: const Border(
                                      bottom: BorderSide(
                                        color:
                                            Color.fromARGB(150, 255, 255, 255),
                                        width: 1,
                                      ),
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white.withOpacity(0.05),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    providerDetails[
                                                        'profileImageUrl']),
                                                radius: 40,
                                              ),
                                              Text(
                                                providerDetails['firstName'],
                                                style: kSubtitleTextStyle,
                                              ),
                                              Text(
                                                providerDetails['lastName'],
                                                style: kSubtitleTextStyle,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(width: 30),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              const SizedBox(width: 5),
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.email,
                                                    color: Colors.white,
                                                    size: 16,
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Text(
                                                    providerDetails['email'],
                                                    style: kBodyTextStyle,
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 5),
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.phone,
                                                    color: Colors.white,
                                                    size: 16,
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Text(
                                                    providerDetails['phone'],
                                                    style: kBodyTextStyle,
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 5),
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.location_on,
                                                    color: Colors.white,
                                                    size: 16,
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Text(
                                                    providerDetails['location'],
                                                    style: kBodyTextStyle,
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 5),
                                              Row(
                                                children: [
                                                  const Icon(Icons.category,
                                                      color: Colors.white,
                                                      size: 16),
                                                  const SizedBox(width: 5),
                                                  Text(
                                                    providerDetails['category'],
                                                    style: kBodyTextStyle,
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 5),
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.work,
                                                    color: Colors.white,
                                                    size: 16,
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Text(
                                                    providerDetails[
                                                        'profession'],
                                                    style: kBodyTextStyle,
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10),
                                const Text(
                                  'NIC Front and Back',
                                  style: kSubtitleTextStyle2,
                                ),
                                const SizedBox(height: 5),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        providerDetails['nicFrontUrl'],
                                        width: 320,
                                        height: 180,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        providerDetails['nicBackUrl'],
                                        width: 320,
                                        height: 180,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                PrimaryOutlinedButton(
                                  text: 'Reject',
                                  onPressed: _rejectProvider,
                                ),
                                PrimaryFilledButton(
                                  text: 'Approve',
                                  onPressed: _approveProvider,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
        ),
      ],
    );
  }
}

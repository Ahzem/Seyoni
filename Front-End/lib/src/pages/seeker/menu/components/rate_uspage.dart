import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:seyoni/src/constants/constants_color.dart';
import 'package:seyoni/src/constants/constants_font.dart';
import 'package:seyoni/src/widgets/custom_button.dart';
import 'package:seyoni/src/widgets/background_widget.dart';

class RateUsPage extends StatefulWidget {
  const RateUsPage({super.key});

  @override
  _RateUsPageState createState() => _RateUsPageState();
}

class _RateUsPageState extends State<RateUsPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _feedbackController = TextEditingController();
  double _rating = 0;

  List<Map<String, dynamic>> _reviews = [];

  @override
  void initState() {
    super.initState();
    _fetchReviews(); // Fetch reviews when the page loads
  }

  Future<void> _fetchReviews() async {
    // Simulate fetching data from the database
    // Replace this with your API call to get reviews from the database
    List<Map<String, dynamic>> fetchedReviews = [
      {
        'rating': 4.5,
        'feedback': 'Great service! Will use again.',
        'username': 'JohnDoe'
      },
      {
        'rating': 5,
        'feedback': 'Excellent app! Very useful.',
        'username': 'JaneSmith'
      },
      {
        'rating': 3,
        'feedback': 'It was okay, but can improve.',
        'username': 'AlexW'
      }
    ];

    setState(() {
      _reviews = fetchedReviews; // Update the reviews list with fetched data
    });
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: kTransparentColor,
        ),
        body: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  Text(
                    'Love SEYONI? ❤️ Let Us Know!',
                    style: kSubtitleTextStyle.copyWith(fontSize: 18.0),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    '🌟 Rate & Review Today!',
                    style: kSubtitleTextStyle.copyWith(fontSize: 18.0),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20.0),

                  // Card for Rating
                  Card(
                    elevation: 4,
                    color: kContainerColor.withOpacity(0.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            'Rate us with stars:',
                            style: kSubtitleTextStyle.copyWith(fontSize: 16.0),
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(height: 8.0),
                          Center(
                            child: StarRating(
                              rating: _rating,
                              onRatingChanged: (rating) =>
                                  setState(() => _rating = rating),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 20.0),

                  // Card for Feedback
                  Card(
                    elevation: 4,
                    color: kContainerColor.withOpacity(0.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'We appreciate your feedback:',
                            style: kSubtitleTextStyle.copyWith(fontSize: 16.0),
                          ),
                          SizedBox(height: 20.0),
                          TextFormField(
                            controller: _feedbackController,
                            decoration: InputDecoration(
                              labelText: 'Feedback',
                              labelStyle:
                                  kSubtitleTextStyle.copyWith(fontSize: 16.0),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: kPrimaryColor),
                              ),
                              prefixIcon: Icon(
                                Icons.feedback,
                                color: kPrimaryColor,
                              ),
                            ),
                            style: kSubtitleTextStyle.copyWith(fontSize: 16.0),
                            maxLines: 5,
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 20.0),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Skip Button
                      TextButton(
                        onPressed: () {
                          if (_rating == 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Please rate us before skipping'),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ThankYouPage(
                                  rating: _rating,
                                  feedback: _feedbackController.text.isNotEmpty
                                      ? _feedbackController.text
                                      : null,
                                ),
                              ),
                            );
                          }
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          backgroundColor: Colors.transparent,
                        ),
                        child: Text('Skip',
                            style: TextStyle(
                                color: kPrimaryColor, fontSize: 16.0)),
                      ),
                      // Submit Button
                      PrimaryFilledButton(
                        text: 'Submit',
                        onPressed: () {
                          if (_rating == 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('Please rate us before submitting'),
                              ),
                            );
                          } else if (_feedbackController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Please provide feedback before submitting'),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ThankYouPage(
                                  rating: _rating,
                                  feedback: _feedbackController.text.isNotEmpty
                                      ? _feedbackController.text
                                      : null,
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),

                  SizedBox(height: 20.0),

                  // Section for displaying previous ratings and feedback
                  Card(
                    elevation: 4,
                    color: kContainerColor.withOpacity(0.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            '💬 What Others Are Saying:',
                            style: kSubtitleTextStyle.copyWith(fontSize: 16.0),
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(height: 10.0),
                          _reviews.isNotEmpty
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: _reviews.length,
                                  itemBuilder: (context, index) {
                                    final review = _reviews[index];
                                    return Card(
                                      color: kContainerColor,
                                      elevation: 2,
                                      margin:
                                          EdgeInsets.symmetric(vertical: 8.0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    review['username'],
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16.0,
                                                    ),
                                                  ),
                                                ),
                                                StarRating(
                                                  rating: review['rating']
                                                      .toDouble(), // Ensure the rating is double
                                                  onRatingChanged: null,
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 8.0),
                                            Text(
                                              review['feedback'],
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                color: kParagraphTextColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : Center(
                                  child: Text(
                                    'No reviews yet!',
                                    style: kSubtitleTextStyle.copyWith(
                                        fontSize: 16.0),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class StarRating extends StatelessWidget {
  final double rating;
  final Function(double)? onRatingChanged;
  final int starCount;

  const StarRating({
    this.rating = 0,
    this.onRatingChanged,
    this.starCount = 5,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(starCount, (index) {
        return IconButton(
          icon: Icon(
            index < rating ? Icons.star : Icons.star_border,
            color: kPrimaryColor,
          ),
          onPressed: onRatingChanged != null
              ? () {
                  if (index + 1 == rating) {
                    onRatingChanged!(rating - 1); // Deselect current rating
                  } else {
                    onRatingChanged!(index + 1.0); // Set new rating
                  }
                }
              : null,
        );
      }),
    );
  }
}

class ThankYouPage extends StatelessWidget {
  final double rating;
  final String? feedback;

  const ThankYouPage({
    required this.rating,
    this.feedback,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BackgroundWidget(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: kTransparentColor.withOpacity(0.2),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              border: Border.all(color: kTransparentColor, width: 1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.thumb_up, size: 100, color: kPrimaryColor),
                SizedBox(height: 10),
                Text(
                  feedback == null
                      ? 'Thank you for Rating us!'
                      : 'Thank you for your feedback!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: kParagraphTextColor,
                  ),
                ),
                SizedBox(height: 20),
                PrimaryFilledButton(
                  text: 'Close',
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

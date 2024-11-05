import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:seyoni/src/widgets/custom_button.dart';
import '../../../../../constants/constants_color.dart';
import '../../../../../constants/constants_font.dart';
import '../../../../../widgets/background_widget.dart';

class AddNewCardBottomSheet extends StatefulWidget {
  const AddNewCardBottomSheet({super.key});

  @override
  State<AddNewCardBottomSheet> createState() => _AddNewCardBottomSheetState();
}

class _AddNewCardBottomSheetState extends State<AddNewCardBottomSheet> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;

  void onCreditCardModelChange(CreditCardModel data) {
    setState(() {
      cardNumber = data.cardNumber;
      expiryDate = data.expiryDate;
      cardHolderName = data.cardHolderName;
      cvvCode = data.cvvCode;
      isCvvFocused = data.isCvvFocused;
    });
  }

  void onCreditCardWidgetChange(CreditCardBrand creditCardBrand) {
    // Handle credit card brand change if needed
  }

  InputDecoration _buildInputDecoration(String labelText, String hintText) {
    return InputDecoration(
      border: OutlineInputBorder(
        borderSide: BorderSide(color: kPrimaryColor), // Set border color
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
        borderSide: BorderSide(color: kPrimaryColor), // Set focused border color
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
        borderSide: BorderSide(color: kPrimaryColor), // Set existing field border color
      ),
      labelText: labelText,
      labelStyle: kBodyTextStyle, 
      hintText: hintText,
      hintStyle: kBodyTextStyle2,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundWidget(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30.0, sigmaY: 30.0),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.8,
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
              children: [
                Text(
                  'Card Details',
                  style: kTitleTextStyle,
                ),
                SizedBox(height: 16),
                CreditCardWidget(
                  cardNumber: cardNumber,
                  expiryDate: expiryDate,
                  cardHolderName: cardHolderName,
                  cvvCode: cvvCode,
                  showBackView: isCvvFocused, // true when you want to show cvv(back) view
                  onCreditCardWidgetChange: onCreditCardWidgetChange, // Callback for anytime credit card brand is changed
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        CreditCardForm(
                          formKey: formKey, // Required
                          cardNumber: cardNumber, // Required
                          expiryDate: expiryDate, // Required
                          cardHolderName: cardHolderName, // Required
                          cvvCode: cvvCode, // Required
                          onCreditCardModelChange: onCreditCardModelChange, // Required
                          obscureCvv: true,
                          obscureNumber: true,
                          isHolderNameVisible: true,
                          isCardNumberVisible: true,
                          isExpiryDateVisible: true,
                          enableCvv: true,
                          cvvValidationMessage: 'Please input a valid CVV',
                          dateValidationMessage: 'Please input a valid date',
                          numberValidationMessage: 'Please input a valid number',
                          cardNumberValidator: (String? cardNumber) {
                            return null;
                          },
                          cardHolderValidator: (String? cardHolderName) {
                            return null;
                          },
                          expiryDateValidator: (String? expiryDate) {
                            return null;
                          },
                          cvvValidator: (String? cvv) {
                            return null;
                          },
                          onFormComplete: () {
                            // callback to execute at the end of filling card data
                          },
                          autovalidateMode: AutovalidateMode.always,
                          disableCardNumberAutoFillHints: false,
                          inputConfiguration: InputConfiguration(
                            cardNumberDecoration: _buildInputDecoration('Card Number', 'XXXX XXXX XXXX XXXX'),
                            cardHolderDecoration: _buildInputDecoration('Name on Card', ''),
                            expiryDateDecoration: _buildInputDecoration('Expiration', 'XX/XX'),
                            cvvCodeDecoration: _buildInputDecoration('CVV', 'XXX'),
                            cardNumberTextStyle: kInputTextStyle,
                            cardHolderTextStyle: kInputTextStyle,
                            expiryDateTextStyle: kInputTextStyle,
                            cvvCodeTextStyle: kInputTextStyle,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PrimaryOutlinedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              text: 'Cancel',
                            ),
                            const SizedBox(width: 20),
                    PrimaryFilledButton(
                      text: 'Save',
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          // Handle card addition logic here
                          Navigator.pop(context); // Close the bottom sheet
                        }
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20), // Space after the button
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:delivery_app/view_model/addorder_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'MyInputDecoration.dart';

class PromoCodeSection extends StatefulWidget {
  const PromoCodeSection({
    Key key,
  }) : super(key: key);

  @override
  _PromoCodeSectionState createState() => _PromoCodeSectionState();
}

class _PromoCodeSectionState extends State<PromoCodeSection> {
  TextEditingController promoCodeController;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    promoCodeController = TextEditingController();
  }

  @override
  void dispose() {
    promoCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<AddOrderViewModel>(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
      child: TextFormField(
        controller: promoCodeController,
        onSaved: (v) {
          model.order.promoCode = v;
        },
        decoration: InputDecoration(
          hintText: 'Promo Code',
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          hintStyle: customInputStyle(),
          suffix: OutlineButton(
            onPressed: (isLoading)
                ? null
                : () async {
                    // bring down the keyboard
                    FocusScope.of(context).unfocus();

                    if (promoCodeController.text.isEmpty) {
                      return;
                    }

                    setState(() {
                      isLoading = true;
                    });

                    await model.checkAndApplyPromoCode(
                        context, model.order.price, promoCodeController.text);

                    setState(() {
                      isLoading = false;
                    });
                  },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            child: Text("Apply"),
          ),
        ),
      ),
    );
  }
}

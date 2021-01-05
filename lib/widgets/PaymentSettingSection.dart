import 'package:flutter/material.dart';

import 'MyInputDecoration.dart';

class PaymentSettingSection extends StatelessWidget {
  //final String pickAddress;
  //final List<String> dropAddress;
  const PaymentSettingSection({
    Key key,
    //@required this.pickAddress,
    //@required this.dropAddress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 18, right: 18),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Row(
              children: <Widget>[
                const Icon(Icons.local_atm),
                const SizedBox(width: 10),
                Text(
                  'Cash',
                  style: customInputStyle(fontSize: 16.5),
                ),
                const Spacer(),
                const Icon(Icons.check),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8.0),
        // if (!dropAddress.contains('') && pickAddress != '') ...[
        //   Padding(
        //     padding: const EdgeInsets.only(top: 8.0, left: 25, right: 18),
        //     child: Text(
        //       'Choose payment address',
        //       style: TextStyle(
        //         fontSize: 14,
        //         color: Colors.grey,
        //       ),
        //     ),
        //   ),
        //   RadioListTile(
        //     activeColor: primaryColor,
        //     title: Text(pickAddress),
        //     dense: true,
        //     value: pickAddress,
        //     groupValue: pickAddress,
        //     onChanged: (_) {},
        //   ),
        //   Column(
        //     children: dropAddress
        //         .map(
        //           (m) => RadioListTile(
        //             activeColor: primaryColor,
        //             title: Text(m),
        //             value: m,
        //             dense: true,
        //             groupValue: '123',
        //             onChanged: (_) {},
        //           ),
        //         )
        //         .toList(),
        //   ),
        // ]
      ],
    );
  }
}

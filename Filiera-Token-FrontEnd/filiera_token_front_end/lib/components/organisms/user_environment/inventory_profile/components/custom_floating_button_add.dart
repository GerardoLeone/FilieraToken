import 'package:filiera_token_front_end/components/organisms/user_environment/inventory_profile/components/form_add_milkbatch.dart';
import 'package:flutter/material.dart';

class CustomAddMilkBatchButton extends StatelessWidget {
  final String wallet;

  const CustomAddMilkBatchButton({required this.wallet, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _buildAddMilkBatchButton(context),
    );
  }

  FloatingActionButton _buildAddMilkBatchButton(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.green,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: const Icon(Icons.add),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.all(16.0),
              child: MilkBatchForm(wallet: wallet),
            );
          },
        );
      },
    );
  }
}

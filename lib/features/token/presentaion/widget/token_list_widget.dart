// features/token/presentation/widgets/token_list.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uten_wallet/features/token/data/model/token_model.dart';
import 'package:uten_wallet/features/token/presentaion/widget/token_details.dart';

import '../../domain/entity/token_entity.dart';
import '../bloc/token_bloc/token_bloc.dart';

class TokenList extends StatelessWidget {
  final List<TokenEntity> tokens;
  final String walletId;
  final int currentChainId;

  const TokenList({
    super.key,
    required this.tokens,
    required this.walletId,
    required this.currentChainId,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tokens.length,
      itemBuilder: (context, index) {
        final token = tokens[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(token.logoURI),
            child: token.logoURI.isEmpty
                ? const Icon(Icons.currency_bitcoin)
                : null,
          ),
          title: Text(token.name),
          subtitle: Text(token.symbol),
          trailing: IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              context.read<TokenBloc>().add(VerifyAndAddToken(
                    walletId: walletId,
                    token: token as TokenModel,
                    currentChainId: currentChainId,
                  ));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${token.symbol} added to wallet')),
              );
              Navigator.pop(context);
            },
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TokenDetailsPage(token: token),
              ),
            );
          },
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entity/token_entity.dart';
import '../bloc/token_bloc.dart';
import '../widget/token_list_widget.dart';

class TokenSearchPage extends StatefulWidget {
  final String walletId;
  final int chainId;

  const TokenSearchPage({
    Key? key,
    required this.walletId,
    required this.chainId,
  }) : super(key: key);

  @override
  _TokenSearchPageState createState() => _TokenSearchPageState();
}

class _TokenSearchPageState extends State<TokenSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  late TokenBloc _tokenBloc;
  List<TokenEntity> _filteredTokens = [];
  List<TokenEntity> _allTokens = [];

  @override
  void initState() {
    super.initState();
    _tokenBloc = context.read<TokenBloc>();
    _tokenBloc.add(FetchTokens(widget.chainId));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterTokens(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredTokens = List.from(_allTokens);
      } else {
        _filteredTokens = _allTokens.where((token) {
          final nameLower = token.name.toLowerCase();
          final symbolLower = token.symbol.toLowerCase();
          final queryLower = query.toLowerCase();
          return nameLower.contains(queryLower) ||
              symbolLower.contains(queryLower);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Search Tokens'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Navigate to manual token add screen
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Search by name or symbol...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
              ),
              onChanged: _filterTokens,
            ),
          ),
          Expanded(
            child: BlocConsumer<TokenBloc, TokenState>(
              listener: (context, state) {
                if (state is TokenLoaded) {
                  _allTokens = state.tokens;
                  _filteredTokens = List.from(_allTokens);
                }
              },
              builder: (context, state) {
                if (state is TokenLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is TokenError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(state.message),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () =>
                              _tokenBloc.add(FetchTokens(widget.chainId)),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                } else if (state is TokenLoaded || _filteredTokens.isNotEmpty) {
                  return _filteredTokens.isEmpty
                      ? const Center(child: Text('No matching tokens found'))
                      : TokenList(
                          currentChainId: widget.chainId,
                          tokens: _filteredTokens,
                          walletId: widget.walletId,
                        );
                }
                return const Center(child: Text('No tokens available'));
              },
            ),
          ),
        ],
      ),
    );
  }
}

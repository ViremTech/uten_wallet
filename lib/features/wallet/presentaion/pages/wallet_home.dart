import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uten_wallet/core/constant/constant.dart';
import 'package:uten_wallet/core/network/presentaion/pages/network_page.dart';
import 'package:uten_wallet/features/onboarding/presentaion/widget/button_widget.dart';
import 'package:uten_wallet/features/wallet/data/model/wallet_model.dart';
import 'package:uten_wallet/features/wallet/presentaion/pages/receieve_page.dart';
import 'package:uten_wallet/features/wallet/presentaion/pages/wallets_page.dart';
import 'package:uten_wallet/features/wallet/presentaion/widget/Icon_text_widget.dart';
import 'package:uten_wallet/features/wallet/presentaion/widget/address_widget.dart';
import '../../../../core/network/presentaion/bloc/evmchain_bloc.dart';
import '../../../../core/util/truncate_address.dart';
import '../../../token/data/model/token_model.dart';
import '../../../token/presentaion/bloc/token_price_bloc/token_price_bloc.dart';
import '../../../token/presentaion/pages/token_page.dart';
import '../bloc/get_active_wallet/get_active_wallet_bloc.dart';

class WalletHome extends StatefulWidget {
  final WalletModel wallet;
  const WalletHome({super.key, required this.wallet});

  @override
  State<WalletHome> createState() => _WalletHomeState();
}

class _WalletHomeState extends State<WalletHome> {
  bool hasNfts = false;
  bool hasDefi = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startPriceUpdates();
    });
  }

  void _startPriceUpdates() {
    final evmState = context.read<EvmChainBloc>().state;
    if (evmState is EvmChainLoadedByIdState) {
      final currentChainId = evmState.chain.chainId;
      final currentNetworkTokens = widget.wallet.tokens
          .where((token) => token.chainId == currentChainId)
          .toList();

      context.read<TokenPriceBloc>().add(
            StartPriceUpdates(currentNetworkTokens),
          );
    }
  }

  Future<void> onRefresh() async {
    context.read<GetActiveWalletBloc>().add(LoadActiveWallet());
    final evmState = context.read<EvmChainBloc>().state;
    if (evmState is EvmChainLoadedByIdState) {
      final currentChainId = evmState.chain.chainId;
      final currentNetworkTokens = widget.wallet.tokens
          .where((token) => token.chainId == currentChainId)
          .toList();

      context.read<TokenPriceBloc>().add(
            UpdateTokenPricesEvent(tokens: currentNetworkTokens),
          );
    }
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetActiveWalletBloc, ActiveWalletState>(
      builder: (context, state) {
        if (state is ActiveWalletLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ActiveWalletError) {
          return Center(child: Text('Error: ${state.message}'));
        }

        if (state is ActiveWalletLoaded) {
          final wallet = state.wallet;
          context.read<EvmChainBloc>().add(
                GetNetworkById(networkId: wallet!.network),
              );
          return BlocBuilder<EvmChainBloc, EvmChainState>(
            builder: (context, chainState) {
              if (chainState is EvmChainLoadingState) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              if (chainState is EvmChainErrorState) {
                return Scaffold(
                  body: Center(
                      child: Text('Network error: ${chainState.message}')),
                );
              }

              if (chainState is EvmChainLoadedByIdState) {
                final currentChainId = chainState.chain.chainId;
                final currentNetworkTokens = wallet.tokens
                    .where((token) => token.chainId == currentChainId)
                    .toList();
                final hasTokens = currentNetworkTokens.isNotEmpty;

                return BlocBuilder<TokenPriceBloc, TokenPriceState>(
                  builder: (context, priceState) {
                    return Scaffold(
                      floatingActionButton: hasTokens
                          ? FloatingActionButton.extended(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TokenSearchPage(
                                      walletId: wallet.id,
                                      chainId: currentChainId,
                                    ),
                                  ),
                                );
                              },
                              label: const Text('Add Token'),
                            )
                          : null,
                      floatingActionButtonLocation:
                          FloatingActionButtonLocation.centerFloat,
                      body: DefaultTabController(
                        length: 3,
                        child: SafeArea(
                          child: RefreshIndicator(
                            onRefresh: onRefresh,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 22.0),
                              child: CustomScrollView(
                                slivers: [
                                  SliverToBoxAdapter(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        WalletsPage(
                                                            model:
                                                                widget.wallet),
                                                  ),
                                                );
                                              },
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: 30,
                                                    height: 30,
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    child: const Icon(
                                                      Icons.person,
                                                      size: 18,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Column(
                                                    children: [
                                                      Text(
                                                        wallet.name,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyMedium,
                                                      ),
                                                      Text(
                                                        wallet.network,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .labelMedium,
                                                      ),
                                                    ],
                                                  ),
                                                  const Icon(
                                                      Icons.arrow_drop_down),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                IconButton(
                                                  icon: const Icon(Icons.copy,
                                                      size: 24),
                                                  onPressed: () {
                                                    receiveAssets(context,
                                                        wallet.address);
                                                  },
                                                ),
                                                IconButton(
                                                  icon: const Icon(
                                                      Icons
                                                          .notifications_outlined,
                                                      size: 24),
                                                  onPressed: () {},
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            const NetworkPage(),
                                                      ),
                                                    );
                                                  },
                                                  child: const Row(
                                                    children: [
                                                      Text('Network'),
                                                      Icon(Icons
                                                          .arrow_drop_down),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          "USD ${wallet.balance}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 24,
                                              ),
                                        ),
                                        const SizedBox(height: 30),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            IconText(
                                              text: 'Buy',
                                              onTap: () {},
                                              icon: Icons.add,
                                            ),
                                            IconText(
                                              text: 'Swap',
                                              onTap: () {},
                                              icon: Icons.swap_horiz,
                                            ),
                                            IconText(
                                              text: 'Bridge',
                                              onTap: () {},
                                              icon: Icons.navigate_next,
                                            ),
                                            IconText(
                                              text: 'Send',
                                              onTap: () {},
                                              icon: Icons.arrow_upward_outlined,
                                            ),
                                            IconText(
                                              text: 'Receive',
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ReceievePage(
                                                            wallet: wallet),
                                                  ),
                                                );
                                              },
                                              icon:
                                                  Icons.arrow_downward_outlined,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 30),
                                        const TabBar(
                                          dividerHeight: 0,
                                          isScrollable: true,
                                          tabAlignment: TabAlignment.start,
                                          tabs: [
                                            Tab(text: 'Crypto'),
                                            Tab(text: 'NFTs'),
                                            Tab(text: 'DeFi'),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SliverFillRemaining(
                                    child: TabBarView(
                                      children: [
                                        hasTokens
                                            ? _buildTokenList(
                                                currentNetworkTokens
                                                    as List<TokenModel>)
                                            : _buildEmptyCryptoState(
                                                wallet as WalletModel,
                                                currentChainId),
                                        _buildEmptyNftState(),
                                        _buildEmptyDefiState(),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      bottomNavigationBar: Container(
                        height: 70,
                        decoration: BoxDecoration(
                          color: const Color(0xFF000000),
                          border: Border(
                            top: BorderSide(
                              color: Colors.grey.shade800,
                              width: 1,
                            ),
                          ),
                        ),
                        child: BottomNavigationBar(
                          iconSize: 24,
                          showUnselectedLabels: true,
                          selectedFontSize: 9,
                          unselectedFontSize: 9,
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          selectedItemColor: primaryColor,
                          unselectedItemColor: Colors.white,
                          items: const [
                            BottomNavigationBarItem(
                              icon: Icon(Icons.pie_chart),
                              label: 'Assets',
                            ),
                            BottomNavigationBarItem(
                              icon: Icon(Icons.list_alt),
                              label: 'Transactions',
                            ),
                            BottomNavigationBarItem(
                              icon: Icon(Icons.language),
                              label: 'Browser',
                            ),
                            BottomNavigationBarItem(
                              icon: Icon(Icons.search),
                              label: 'Explore',
                            ),
                            BottomNavigationBarItem(
                              icon: Icon(Icons.settings),
                              label: 'Settings',
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }

              return const Scaffold(
                body: Center(child: Text('Network information unavailable')),
              );
            },
          );
        }
        return const Center(child: Text('No active wallet found'));
      },
    );
  }

  Widget _buildTokenList(List<TokenModel> tokens) {
    return ListView.builder(
      itemCount: tokens.length,
      itemBuilder: (context, index) {
        return BlocBuilder<TokenPriceBloc, TokenPriceState>(
          buildWhen: (previous, current) =>
              current is TokenPricesUpdated || current is TokenPriceUpdating,
          builder: (context, state) {
            final originalToken = tokens[index];
            TokenModel token = originalToken;

            if (state is TokenPricesUpdated || state is TokenPriceUpdating) {
              final updatedTokens = (state as dynamic).tokens;
              final updatedToken =
                  updatedTokens.whereType<TokenModel>().firstWhere(
                        (t) => t.id == originalToken.id,
                        orElse: () => originalToken,
                      );
              token = updatedToken;
            }

            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(token.logoURI),
              ),
              title: Text(token.name),
              subtitle: Row(
                children: [
                  Text('\$${token.tokenPrice.usdPrice.toStringAsFixed(2)}'),
                  const SizedBox(width: 5),
                  Text(
                    '${token.tokenPrice.precentageChange.toStringAsFixed(2)}%',
                    style: TextStyle(
                      color: token.tokenPrice.precentageChange >= 0
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${token.balance} ${token.symbol}'),
                  const SizedBox(height: 4),
                  Text(
                    '\$${token.tokenPrice.totalUserValueUsd.toStringAsFixed(2)}',
                  ),
                ],
              ),
              onTap: () {
                context.read<TokenPriceBloc>().add(LoadTokenPrice(token));
              },
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyCryptoState(WalletModel wallet, int chainId) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const SizedBox(height: 30),
              Image.asset('assets/images/home1.png'),
              Text(
                'Add crypto to get started',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 10),
              Text(
                'You can add funds with your Uten account or another wallet.',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: ButtonWidget(
              paddng: 0,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TokenSearchPage(
                      walletId: wallet.id,
                      chainId: chainId,
                    ),
                  ),
                );
              },
              color: primaryColor,
              text: 'Add Crypto',
              textColor: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyNftState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const SizedBox(height: 30),
              Image.asset('assets/images/home2.png'),
              Text(
                'Get Started with NFTs',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 10),
              Text(
                "First you'll need to add some ETH to your wallet",
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: ButtonWidget(
              paddng: 0,
              onPressed: () {},
              color: primaryColor,
              text: 'Add Crypto',
              textColor: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyDefiState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const SizedBox(height: 30),
              Image.asset('assets/images/home3.png'),
              Text(
                'Start earning with DeFi',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 10),
              Text(
                'Add crypto to your wallet to get started with decentralized finances',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: ButtonWidget(
              paddng: 0,
              onPressed: () {},
              color: primaryColor,
              text: 'Add Crypto',
              textColor: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  void receiveAssets(BuildContext context, String address) {
    String shortAddress = truncateAddress(address);
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.7,
          child: Container(
            padding: const EdgeInsets.all(26),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Receive assets',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 20),
                AddressWidget(address: address, shortAddress: shortAddress)
              ],
            ),
          ),
        );
      },
    );
  }
}

class NetworkConfig {
  final String name;
  final String rpcUrl;
  final int chainId;
  final String currencySymbol;
  final String explorerUrl;

  const NetworkConfig({
    required this.name,
    required this.rpcUrl,
    required this.chainId,
    required this.currencySymbol,
    required this.explorerUrl,
  });
}

const supportedNetworks = {
  'ethereum': NetworkConfig(
    name: 'Ethereum Mainnet',
    rpcUrl: 'https://mainnet.infura.io/v3/YOUR_INFURA_KEY',
    chainId: 1,
    currencySymbol: 'ETH',
    explorerUrl: 'https://etherscan.io',
  ),
  'bsc': NetworkConfig(
    name: 'Binance Smart Chain',
    rpcUrl: 'https://bsc-dataseed.binance.org/',
    chainId: 56,
    currencySymbol: 'BNB',
    explorerUrl: 'https://bscscan.com',
  ),
  'polygon': NetworkConfig(
    name: 'Polygon Mainnet',
    rpcUrl: 'https://polygon-rpc.com',
    chainId: 137,
    currencySymbol: 'MATIC',
    explorerUrl: 'https://polygonscan.com',
  ),
};

// lib/core/network/presentaion/pages/network_edit_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uten_wallet/core/network/domain/entity/network_entity.dart';
import 'package:uten_wallet/core/network/data/model/network_model.dart';
import 'package:uten_wallet/core/network/presentaion/bloc/evmchain_bloc.dart';

class NetworkEditPage extends StatefulWidget {
  final NetworkEntity? network; // If null, we're adding a new network

  const NetworkEditPage({Key? key, this.network}) : super(key: key);

  @override
  State<NetworkEditPage> createState() => _NetworkEditPageState();
}

class _NetworkEditPageState extends State<NetworkEditPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _shortNameController;
  late TextEditingController _chainIdController;
  late TextEditingController _rpcUrlController;
  late TextEditingController _currencySymbolController;
  late TextEditingController _currencyNameController;
  late TextEditingController _blockExplorerUrlController;
  late TextEditingController _logoUrlController;
  late TextEditingController _decimalsController;

  bool _isTestnet = false;
  bool _isEditMode = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.network != null;

    // Initialize controllers with existing data if editing
    _nameController = TextEditingController(text: widget.network?.name ?? '');
    _shortNameController =
        TextEditingController(text: widget.network?.shortName ?? '');
    _chainIdController =
        TextEditingController(text: widget.network?.chainId.toString() ?? '');
    _rpcUrlController = TextEditingController(
        text: widget.network?.rpc.isNotEmpty == true
            ? widget.network!.rpc.first
            : '');
    _currencySymbolController =
        TextEditingController(text: widget.network?.currencySymbol ?? '');
    _currencyNameController =
        TextEditingController(text: widget.network?.currencyName ?? '');
    _blockExplorerUrlController =
        TextEditingController(text: widget.network?.blockExplorerUrl ?? '');
    _logoUrlController =
        TextEditingController(text: widget.network?.logoUrl ?? '');
    _decimalsController = TextEditingController(
        text: widget.network?.decimals.toString() ?? '18');

    if (widget.network != null) {
      _isTestnet = widget.network!.isTestnet;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _shortNameController.dispose();
    _chainIdController.dispose();
    _rpcUrlController.dispose();
    _currencySymbolController.dispose();
    _currencyNameController.dispose();
    _blockExplorerUrlController.dispose();
    _logoUrlController.dispose();
    _decimalsController.dispose();
    super.dispose();
  }

  void _saveNetwork() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final networkId = _isEditMode
        ? widget.network!.id
        : '${_shortNameController.text.toLowerCase()}-${DateTime.now().millisecondsSinceEpoch}';

    final network = NetworkModel(
      id: networkId,
      name: _nameController.text,
      shortName: _shortNameController.text,
      chainId: int.parse(_chainIdController.text),
      rpc: [_rpcUrlController.text],
      currencySymbol: _currencySymbolController.text,
      currencyName: _currencyNameController.text,
      decimals: int.parse(_decimalsController.text),
      logoUrl: _logoUrlController.text,
      blockExplorerUrl: _blockExplorerUrlController.text,
      isTestnet: _isTestnet,
      isEditable: true,
    );

    if (_isEditMode) {
      context.read<EvmChainBloc>().add(UpdateNetworkEvent(network));
    } else {
      context.read<EvmChainBloc>().add(AddNetworkEvent(network));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Edit Network' : 'Add Network'),
      ),
      body: BlocListener<EvmChainBloc, EvmChainState>(
        listener: (context, state) {
          if (state is NetworkOperationSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            Navigator.of(context).pop();
          } else if (state is EvmChainErrorState) {
            setState(() {
              _isSubmitting = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(state.message), backgroundColor: Colors.red),
            );
          } else if (state is EvmChainLoadingState) {
            setState(() {
              _isSubmitting = true;
            });
          } else {
            setState(() {
              _isSubmitting = false;
            });
          }
        },
        child: _buildForm(),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Network Name*',
              hintText: 'e.g. Ethereum Mainnet',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter network name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _shortNameController,
            decoration: const InputDecoration(
              labelText: 'Short Name*',
              hintText: 'e.g. ETH',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter short name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _chainIdController,
            decoration: const InputDecoration(
              labelText: 'Chain ID*',
              hintText: 'e.g. 1',
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter chain ID';
              }
              if (int.tryParse(value) == null) {
                return 'Chain ID must be a number';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _rpcUrlController,
            decoration: const InputDecoration(
              labelText: 'RPC URL*',
              hintText: 'e.g. https://mainnet.infura.io/v3/your_key',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter RPC URL';
              }
              if (!value.startsWith('http')) {
                return 'Please enter a valid URL';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _currencySymbolController,
            decoration: const InputDecoration(
              labelText: 'Currency Symbol*',
              hintText: 'e.g. ETH',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter currency symbol';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _currencyNameController,
            decoration: const InputDecoration(
              labelText: 'Currency Name*',
              hintText: 'e.g. Ethereum',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter currency name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _decimalsController,
            decoration: const InputDecoration(
              labelText: 'Decimals',
              hintText: 'e.g. 18',
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter decimals';
              }
              if (int.tryParse(value) == null) {
                return 'Decimals must be a number';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _blockExplorerUrlController,
            decoration: const InputDecoration(
              labelText: 'Block Explorer URL*',
              hintText: 'e.g. https://etherscan.io',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter block explorer URL';
              }
              if (!value.startsWith('http')) {
                return 'Please enter a valid URL';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _logoUrlController,
            decoration: const InputDecoration(
              labelText: 'Logo URL',
              hintText: 'e.g. https://example.com/logo.png',
            ),
            // Optional field, so no validator
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Testnet'),
            subtitle: const Text('Is this a test network?'),
            value: _isTestnet,
            onChanged: (value) {
              setState(() {
                _isTestnet = value;
              });
            },
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _isSubmitting ? null : _saveNetwork,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: _isSubmitting
                ? const CircularProgressIndicator()
                : Text(_isEditMode ? 'Update Network' : 'Add Network'),
          ),
        ],
      ),
    );
  }
}

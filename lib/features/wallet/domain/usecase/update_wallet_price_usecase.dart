// import 'package:dartz/dartz.dart';
// import 'package:uten_wallet/core/error/failure.dart';

// import 'package:uten_wallet/features/wallet/domain/entity/wallet_entity.dart';

// import '../../../../core/usecase/usecase.dart';
// import '../repository/wallet_repo.dart';

// class UpdateWalletPriceUsecase
//     implements Usecase<WalletEntity, UpdateWalletPriceParams> {
//   final WalletRepo repository;

//   UpdateWalletPriceUsecase(this.repository);

//   @override
//   Future<Either<Failure, WalletEntity>> call(UpdateWalletPriceParams params) {
//     return repository.updateWalletPrice(params.wallet, chainId: params.chainId);
//   }
// }

// class UpdateWalletPriceParams {
//   final WalletEntity wallet;
//   final int? chainId;

//   UpdateWalletPriceParams({required this.wallet, this.chainId});
// }

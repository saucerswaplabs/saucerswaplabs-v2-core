// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity >=0.6.0;

import {IHederaTokenService} from '../interfaces/IHederaTokenService.sol';

/// @title AssociateHelper
/// @notice Contains helper method for interacting with Hedera tokens that do not consistently return SUCCESS
library AssociateHelper {

    address internal constant precompileAddress = address(0x167);
    error AssociateFail(int respCode);

    /// @notice Associates tokens to account
    /// @dev Calls associate on token contract, errors with AssociateFail if association fails
    /// @param account The target of the association
    /// @param tokens The solidity address of the tokens to associate to target
    function safeAssociateTokens(
        address account,
        address[] memory tokens
    ) internal {

        (bool success, bytes memory result) = precompileAddress.call(
            abi.encodeWithSelector(IHederaTokenService.associateTokens.selector,
            account, tokens));
        int32 responseCode = success ? abi.decode(result, (int32)) : int32(21); // 21 = unknown
        
        if (responseCode != 22) {
            revert AssociateFail(responseCode);
        }
    }
}
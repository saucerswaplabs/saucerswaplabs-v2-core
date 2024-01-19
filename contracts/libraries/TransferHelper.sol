// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity >=0.6.0;

import {IHederaTokenService} from '../interfaces/IHederaTokenService.sol';
import {SafeCast} from './SafeCast.sol';

/// @title TransferHelper
/// @notice Contains helper methods for interacting with Hedera tokens that do not consistently return SUCCESS
library TransferHelper {

    address internal constant precompileAddress = address(0x167);

    event Transfer(address indexed from, address indexed to, uint256 value, address indexed token);
    error TransferFail(int respCode);

    /// @notice Transfers tokens from msg.sender to a recipient
    /// @dev Calls transfer on token contract, errors with TransferFail if transfer fails
    /// @param token The solidity address of the token which will be transferred
    /// @param sender The sender of the transfer
    /// @param receiver The recipient of the transfer
    /// @param amount The value of the transfer
    function safeTransfer(
        address token,
        address sender,
        address receiver,
        uint256 amount
    ) internal {

        (bool success, bytes memory result) = precompileAddress.call(
            abi.encodeWithSelector(IHederaTokenService.transferToken.selector,
            token, sender, receiver, SafeCast.toInt64(amount)));
        int32 responseCode = success ? abi.decode(result, (int32)) : int32(21); // 21 = unknown
        
        if (responseCode != 22) {
            revert TransferFail(responseCode);
        }

        emit Transfer(sender, receiver, amount, token);
    }
}
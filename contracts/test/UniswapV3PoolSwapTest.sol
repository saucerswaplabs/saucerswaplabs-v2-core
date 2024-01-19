// SPDX-License-Identifier: UNLICENSED
pragma solidity =0.8.12;

import {IERC20} from '../interfaces/IERC20.sol';

import {IUniswapV3SwapCallback} from '../interfaces/callback/IUniswapV3SwapCallback.sol';
import {IUniswapV3Pool} from '../interfaces/IUniswapV3Pool.sol';

import {TransferHelper} from '../libraries/TransferHelper.sol';

contract UniswapV3PoolSwapTest is IUniswapV3SwapCallback {
    int256 private _amount0Delta;
    int256 private _amount1Delta;

    function getSwapResult(
        address pool,
        bool zeroForOne,
        int256 amountSpecified,
        uint160 sqrtPriceLimitX96
    )
        external
        returns (
            int256 amount0Delta,
            int256 amount1Delta,
            uint160 nextSqrtRatio
        )
    {
        (amount0Delta, amount1Delta) = IUniswapV3Pool(pool).swap(
            msg.sender,
            zeroForOne,
            amountSpecified,
            sqrtPriceLimitX96,
            abi.encode(msg.sender)
        );

        (nextSqrtRatio, , , , , , ) = IUniswapV3Pool(pool).slot0();
    }

    function uniswapV3SwapCallback(
        int256 amount0Delta,
        int256 amount1Delta,
        bytes calldata data
    ) external override {
        address sender = abi.decode(data, (address));

        if (amount0Delta > 0) {
            // IERC20(IUniswapV3Pool(msg.sender).token0()).transferFrom(sender, msg.sender, uint256(amount0Delta));
            TransferHelper.safeTransfer(IUniswapV3Pool(msg.sender).token0(), sender, msg.sender, uint256(amount0Delta));
        } else if (amount1Delta > 0) {
            // IERC20(IUniswapV3Pool(msg.sender).token1()).transferFrom(sender, msg.sender, uint256(amount1Delta));
            TransferHelper.safeTransfer(IUniswapV3Pool(msg.sender).token1(), sender, msg.sender, uint256(amount1Delta));
        }
    }
}

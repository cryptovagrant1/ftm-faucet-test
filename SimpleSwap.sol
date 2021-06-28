// SPDX-License-Identifier: MIT
pragma solidity 0.7.1;

import "https://github.com/Uniswap/uniswap-v2-periphery/blob/master/contracts/interfaces/IUniswapV2Router02.sol";

contract UniswapExample {
  address internal constant FLOWERSWAP_ROUTER_ADDRESS = 0x57F077E307Ab57C5448F2DF1D7B59ce07a097cAb ;

  IUniswapV2Router02 public flowerswapRouter;
  address private Btc = 0x2647aB2f1F5d90eeA784eeB2C4EcECcea3bB0BaF;

  constructor() {
    flowerswapRouter = IUniswapV2Router02(FLOWERSWAP_ROUTER_ADDRESS);
  }

  function convertFtmToBtc(uint btcAmount) public payable {
    uint deadline = block.timestamp + 15; // using 'now' for convenience, for mainnet pass deadline from frontend!
    flowerswapRouter.swapETHForExactTokens{ value: msg.value }(btcAmount, getPathForFTMtoBTC(), address(this), deadline);
    
    // refund leftover ETH to user
    (bool success,) = msg.sender.call{ value: address(this).balance }("");
    require(success, "refund failed");
  }
  
  function getEstimatedFTMforBTC(uint btcAmount) public view returns (uint[] memory) {
    return flowerswapRouter.getAmountsIn(btcAmount, getPathForFTMtoBTC());
  }

  function getPathForFTMtoBTC() private view returns (address[] memory) {
    address[] memory path = new address[](2);
    path[0] = flowerswapRouter.WETH();
    path[1] = Btc;
    
    return path;
  }
  
  // important to receive FTM
  receive() payable external {}
}
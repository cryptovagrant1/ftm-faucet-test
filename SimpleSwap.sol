pragma solidity 0.7.1;

import "https://github.com/Uniswap/uniswap-v2-periphery/blob/master/contracts/interfaces/IUniswapV2Router02.sol";

contract UniswapExample {
  address internal constant FLOWERSWAP_ROUTER_ADDRESS = 0x57f077e307ab57c5448f2df1d7b59ce07a097cab ;

  IUniswapV2Router02 public flowerswapRouter;
  address private multiDaiKovan = 0x4F96Fe3b7A6Cf9725f59d353F723c1bDb64CA6Aa;
  address private Btc = 0x2647ab2f1f5d90eea784eeb2c4ececcea3bb0baf;

  constructor() {
    flowerswapRouter = IUniswapV2Router02(FLOWERSWAP_ROUTER_ADDRESS);
  }

  function convertEthToBtc(uint btcAmount) public payable {
    uint deadline = block.timestamp + 15; // using 'now' for convenience, for mainnet pass deadline from frontend!
    flowerswapRouter.swapETHForExactTokens{ value: msg.value }(btcAmount, getPathForETHtoBTC(), address(this), deadline);
    
    // refund leftover ETH to user
    (bool success,) = msg.sender.call{ value: address(this).balance }("");
    require(success, "refund failed");
  }
  
  function getEstimatedETHforBTC(uint btcAmount) public view returns (uint[] memory) {
    return flowerswapRouter.getAmountsIn(btcAmount, getPathForETHtoBTC());
  }

  function getPathForETHtoBTC() private view returns (address[] memory) {
    address[] memory path = new address[](2);
    path[0] = flowerswapRouter.WETH();
    path[1] = Btc;
    
    return path;
  }
  
  // important to receive ETH
  receive() payable external {}
}
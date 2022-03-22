pragma solidity ^0.8.4;

import {ChildERC20} from "./ChildERC20.sol";

contract MaticWETH is ChildERC20 {
    constructor(address childChainManager) public ChildERC20("Wrapped Ether", "WETH", 18, childChainManager) {}
}

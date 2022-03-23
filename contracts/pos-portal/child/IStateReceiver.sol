pragma solidity ^0.8.4;

interface IStateReceiver {
    function onStateReceive(uint256 id, bytes calldata data) external;
}

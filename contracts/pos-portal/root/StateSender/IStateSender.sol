pragma solidity ^0.8.4;

interface IStateSender {
    function syncState(address receiver, bytes calldata data) external;
}

pragma solidity ^0.8.4;

import {SafeMath} from "@openzeppelin/contracts/utils/math/SafeMath.sol";
import {ICheckpointManager} from "./ICheckpointManager.sol";

/**
* @notice Mock Checkpoint Manager contract to simulate plasma checkpoints while testing
*/
contract MockCheckpointManager is ICheckpointManager {
    using SafeMath for uint256;

    uint256 public currentCheckpointNumber = 0;

    function setCheckpoint(bytes32 rootHash, uint256 start, uint256 end) public {
        HeaderBlock memory headerBlock = HeaderBlock({
            root: rootHash,
            start: start,
            end: end,
            createdAt: block.timestamp,
            proposer: msg.sender
        });

        currentCheckpointNumber = currentCheckpointNumber.add(1);
        headerBlocks[currentCheckpointNumber] = headerBlock;
    }
}

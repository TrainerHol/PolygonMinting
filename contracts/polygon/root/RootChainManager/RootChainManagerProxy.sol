pragma solidity ^0.8.4;

import {UpgradableProxy} from "../../common/Proxy/UpgradableProxy.sol";

contract RootChainManagerProxy is UpgradableProxy {
    constructor(address _proxyTo)
        public
        UpgradableProxy(_proxyTo)
    {}
}

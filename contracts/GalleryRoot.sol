// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@maticnetwork/pos-portal/contracts/common/AccessControlMixin.sol";
import "@maticnetwork/pos-portal/contracts/common/NativeMetaTransaction.sol";
import "@maticnetwork/pos-portal/contracts/common/ContextMixin.sol";
import "@maticnetwork/pos-portal/contracts/root/RootToken/IMintableERC721.sol";

contract DummyMintableERC721 is
    ERC721,
    ERC721Storage,
    AccessControlMixin,
    NativeMetaTransaction,
    IMintableERC721,
    ContextMixin
{
    bytes32 public constant PREDICATE_ROLE = keccak256("PREDICATE_ROLE");

    constructor(string memory name_, string memory symbol_)
        public
        ERC721(name_, symbol_)
    {
        _setupContractId("DummyMintableERC721");
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _setupRole(PREDICATE_ROLE, _msgSender());
        _initializeEIP712(name_);
    }

    function _msgSender()
        internal
        view
        override
        returns (address payable sender)
    {
        return ContextMixin.msgSender();
    }

    /**
     * @dev See {IMintableERC721-mint}.
     */
    function mint(address user, uint256 tokenId)
        external
        override
        only(PREDICATE_ROLE)
    {
        _mint(user, tokenId);
    }

    /**
     * If you're attempting to bring metadata associated with token
     * from L2 to L1, you must implement this method, to be invoked
     * when minting token back on L1, during exit
     */
    function setTokenMetadata(uint256 tokenId, bytes memory data)
        internal
        virtual
    {
        // This function should decode metadata obtained from L2
        // and attempt to set it for this `tokenId`
        //
        // Following is just a default implementation, feel
        // free to define your own encoding/ decoding scheme
        // for L2 -> L1 token metadata transfer
        string memory uri = abi.decode(data, (string));

        _setTokenURI(tokenId, uri);
    }

    /**
     * @dev See {IMintableERC721-mint}.
     *
     * If you're attempting to bring metadata associated with token
     * from L2 to L1, you must implement this method
     */
    function mint(
        address user,
        uint256 tokenId,
        bytes calldata metaData
    ) external override only(PREDICATE_ROLE) {
        _mint(user, tokenId);

        setTokenMetadata(tokenId, metaData);
    }

    function updateTokenURI(uint56 tokenId, string memory tokenURI)
    external only(DEFAULT_ADMIN_ROLE)
    {
        _setTokenURI(tokenId, tokenURI);
    }

    }

    /**
     * @dev See {IMintableERC721-exists}.
     */
    function exists(uint256 tokenId) external view override returns (bool) {
        return _exists(tokenId);
    }
}

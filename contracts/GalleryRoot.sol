// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "./pos-portal/common/AccessControlMixin.sol";
import "./pos-portal/common/NativeMetaTransaction.sol";
import "./pos-portal/common/ContextMixin.sol";
import "./pos-portal/root/RootToken/IMintableERC721.sol";

contract GalleryRoot is
    ERC721,
    AccessControlMixin,
    NativeMetaTransaction,
    IMintableERC721,
    ContextMixin
{
    using Strings for uint256;
    bytes32 public constant PREDICATE_ROLE = keccak256("PREDICATE_ROLE");
    string uri;

    constructor(string memory name_, string memory symbol_)
        ERC721(name_, symbol_)
    {
        _setupContractId("Hol");
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _setupRole(PREDICATE_ROLE, _msgSender());
        _initializeEIP712(name_);
    }

    function _msgSender() internal view override returns (address sender) {
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
    }

    function updateTokenURI(string memory _uri)
        external
        only(DEFAULT_ADMIN_ROLE)
    {
        uri = _uri;
    }

    /**
     * @dev See {IMintableERC721-exists}.
     */
    function exists(uint256 tokenId) external view override returns (bool) {
        return _exists(tokenId);
    }

    function _burn(uint256 tokenId) internal override(ERC721) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721)
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );

        string memory metadata = uri;
        metadata = string(abi.encodePacked(metadata, tokenId.toString()));
        metadata = string(abi.encodePacked(metadata, ".json"));

        return metadata;
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, AccessControl, IERC165)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts-upgradeable/token/ERC1155/IERC1155Upgradeable.sol";

interface IToken is IERC1155Upgradeable {
    function getAddressTokens(
        address account
    ) external view returns (uint256[] memory);

    function getAddressTokens2hand(
        address account
    ) external view returns (uint256[] memory);

    function getUri(uint256 tokenId) external view returns (string memory);

    function addAddressToken(address account, uint256 tokenId) external;

    function addAddressToken2hand(address account, uint256 tokenId) external;

    function removeAddressToken(address account, uint256 tokenId) external;

    function removeAddressToken2hand(address account, uint256 tokenId) external;
}

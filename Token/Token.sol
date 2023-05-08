// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts@4.7.3/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts@4.7.3/access/Ownable.sol";
import "@openzeppelin/contracts@4.7.3/utils/Counters.sol";
import "@openzeppelin/contracts@4.7.3/token/ERC1155/IERC1155.sol";

import "./IToken.sol";

contract Token is ERC1155, Ownable, IToken {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    /* ========== STATE VARIABLES ========== */
    mapping(address => uint256[]) private addressTokens;
    mapping(address => uint256[]) private addressTokens2hand;
    mapping(uint256 => string) private uris;

    /* ========== CONSTRUCTOR ========== */
    constructor() ERC1155("") {}

    /* ========== VIEWS ========== */
    function currentTokenId() public view returns (uint256) {
        return _tokenIds.current();
    }

    function getAddressTokens(address account)
        public
        view
        override
        returns (uint256[] memory)
    {
        return addressTokens[account];
    }

    function getAddressTokens2hand(address account)
        public
        view
        override
        returns (uint256[] memory)
    {
        return addressTokens2hand[account];
    }

    function getUri(uint256 tokenId)
        public
        view
        override
        returns (string memory)
    {
        return uris[tokenId];
    }

    /* ========== MUTATIVE FUNCTIONS ========== */
    function mint(uint256 amount, string memory newuri)
        public
        returns (uint256)
    {
        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();

        uris[newItemId] = newuri;

        _mint(msg.sender, newItemId, amount, "");

        addressTokens[msg.sender].push(newItemId);

        return newItemId;
    }

    function addAddressToken(address account, uint256 tokenId) public override {
        if (!checkTokenExisted(account, tokenId))
            addressTokens[account].push(tokenId);
    }

    function addAddressToken2hand(address account, uint256 tokenId)
        public
        override
    {
        if (!checkToken2handExisted(account, tokenId))
            addressTokens2hand[account].push(tokenId);
    }

    function removeAddressToken(address account, uint256 tokenId)
        public
        override
    {
        if (checkTokenExisted(account, tokenId)) {
            uint256[] memory tokens = addressTokens[account];

            for (uint256 index = 0; index < tokens.length; index++) {
                if (tokenId == tokens[index]) {
                    addressTokens[account][index] = addressTokens[account][
                        addressTokens[account].length - 1
                    ];
                    addressTokens[account].pop();
                    break;
                }
            }
        }
    }

    function removeAddressToken2hand(address account, uint256 tokenId)
        public
        override
    {
        if (checkToken2handExisted(account, tokenId)) {
            uint256[] memory tokens = addressTokens2hand[account];

            for (uint256 index = 0; index < tokens.length; index++) {
                if (tokenId == tokens[index]) {
                    addressTokens2hand[account][index] = addressTokens2hand[
                        account
                    ][addressTokens2hand[account].length - 1];
                    addressTokens2hand[account].pop();
                    break;
                }
            }
        }
    }

    function checkTokenExisted(address account, uint256 tokenId)
        private
        returns (bool)
    {
        uint256[] memory tokens = addressTokens[account];

        for (uint256 index = 0; index < tokens.length; index++) {
            if (tokenId == tokens[index]) return true;
        }

        return false;
    }

    function checkToken2handExisted(address account, uint256 tokenId)
        private
        returns (bool)
    {
        uint256[] memory tokens = addressTokens2hand[account];

        for (uint256 index = 0; index < tokens.length; index++) {
            if (tokenId == tokens[index]) return true;
        }

        return false;
    }
}

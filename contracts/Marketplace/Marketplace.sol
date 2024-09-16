// SPDX-License-Identifier: MIT

// File: contracts/NFT/Marketplace.sol
pragma solidity ^0.8.4;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC1155/utils/ERC1155HolderUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";

import "../Token/IToken.sol";


struct NFTListing {
    uint256 unitPrice;
    address seller;
    uint256 amount;
    uint256 unlistingAmount;
    uint256 id;
}

contract Marketplace is OwnableUpgradeable, ERC1155HolderUpgradeable, ReentrancyGuardUpgradeable {
    /* ========== STATE VARIABLES ========== */
    mapping(bytes => NFTListing) private _listings;
    mapping(bytes => NFTListing) private _listings2hand;

    bytes[] public listingHashes;
    bytes[] public listingHashes2hand;
    bytes private zeroHash;

    IToken private tokenContract;
    IERC20Upgradeable private talContract;

    address constant TalentIDOAddress =
        0x5899e2a82bF0789a1953cD1268c5dFB4fA213aF9;
    uint8 private feePercent = 10;
    uint8 private feePercent2Hand = 2;

    /* ========== CONSTRUCTOR ========== */
    constructor(address tokenContractAddress, address talContractAddress) {
        tokenContract = IToken(tokenContractAddress);
        talContract = IERC20Upgradeable(talContractAddress);
    }

    /* ========== VIEWS ========== */
    function listingTokens(
        uint256 offset,
        uint256 size
    ) public view returns (NFTListing[] memory) {
        require(size > 0, "NFTMarket: invalid size");

        require(offset <= listingHashes.length, "NFTMarket: over the database");

        NFTListing[] memory nfts;

        if (size > listingHashes.length)
            nfts = new NFTListing[](listingHashes.length);
        else nfts = new NFTListing[](size);

        for (uint256 index = offset; index < size; index++) {
            if (listingHashes.length == 0 || index > listingHashes.length - 1)
                break;

            nfts[index] = _listings[listingHashes[index]];
        }

        return nfts;
    }

    function getOneToken(
        uint256 tokenID,
        address seller
    ) public view returns (NFTListing memory) {
        bytes memory hash = combineToBytes(seller, tokenID);

        NFTListing memory nft = _listings[hash];

        return nft;
    }

    function listingTokens2hand(
        uint256 offset,
        uint256 size
    ) public view returns (NFTListing[] memory) {
        require(size > 0, "NFTMarket: invalid size");

        require(
            offset <= listingHashes2hand.length,
            "NFTMarket: over the database"
        );

        NFTListing[] memory nfts;

        if (size > listingHashes2hand.length)
            nfts = new NFTListing[](listingHashes2hand.length);
        else nfts = new NFTListing[](size);

        for (uint256 index = offset; index < size; index++) {
            if (
                listingHashes2hand.length == 0 ||
                index > listingHashes2hand.length - 1
            ) break;

            nfts[index] = _listings2hand[listingHashes2hand[index]];
        }

        return nfts;
    }

    function getOneToken2hand(
        uint256 tokenID,
        address seller
    ) public view returns (NFTListing memory) {
        bytes memory hash = combineToBytes(seller, tokenID);

        NFTListing memory nft = _listings2hand[hash];

        return nft;
    }

    function accountListingTokens(
        address account
    ) public view returns (NFTListing[] memory) {
        require(account != address(0), "NFTMarket: invalid account");

        uint256[] memory ids = tokenContract.getAddressTokens(account);
        NFTListing[] memory nfts = new NFTListing[](ids.length);

        for (uint256 index = 0; index < ids.length; index++) {
            bytes memory hash = combineToBytes(account, ids[index]);
            if (_listings[hash].seller != account) continue;

            nfts[index] = _listings[hash];
        }

        return nfts;
    }

    function accountListingTokens2hand(
        address account
    ) public view returns (NFTListing[] memory) {
        require(account != address(0), "NFTMarket: invalid account");

        uint256[] memory ids = tokenContract.getAddressTokens2hand(account);
        NFTListing[] memory nfts = new NFTListing[](ids.length);

        for (uint256 index = 0; index < ids.length; index++) {
            bytes memory hash = combineToBytes(account, ids[index]);
            if (_listings2hand[hash].seller != account) continue;

            nfts[index] = _listings2hand[hash];
        }

        return nfts;
    }

    /* ========== MUTATIVE FUNCTIONS ========== */
    function setFeePercents(
        uint8 _feePercent,
        uint8 _feePercent2Hand
    ) public onlyTalentIDO(msg.sender) {
        feePercent = _feePercent;
        feePercent2Hand = _feePercent2Hand;
    }

    function listNFT(
        uint256 tokenID,
        uint256 unitPrice,
        uint256 amount
    ) public nonReentrant {
        require(unitPrice > 0, "NFTMarket: Unit price must be greater than 0");

        uint256 totalAmount = tokenContract.balanceOf(msg.sender, tokenID);

        require(totalAmount >= amount, "NFTMarket: over token total amount");

        bytes memory hash = combineToBytes(msg.sender, tokenID);

        require(
            _listings[hash].unitPrice == 0 ||
                _listings[hash].unitPrice == unitPrice,
            "NFTMarket: token is listing with a price"
        );

        listingHashes.push(hash);

        _listings[hash] = NFTListing(
            unitPrice,
            msg.sender,
            _listings[hash].amount + amount,
            totalAmount - amount,
            tokenID
        );

        tokenContract.safeTransferFrom(
            msg.sender,
            address(this),
            tokenID,
            amount,
            ""
        );

        emit NFTTransfer(
            tokenID,
            msg.sender,
            address(this),
            unitPrice,
            amount,
            0,
            0,
            0,
            0,
            "list"
        );
    }

    function listNFT2hand(
        uint256 tokenID,
        uint256 unitPrice,
        uint256 amount
    ) public nonReentrant {
        require(unitPrice > 0, "NFTMarket: Unit price must be greater than 0");

        uint256 totalAmount = tokenContract.balanceOf(msg.sender, tokenID);

        require(totalAmount >= amount, "NFTMarket: over token total amount");

        bytes memory hash = combineToBytes(msg.sender, tokenID);

        require(
            _listings2hand[hash].unitPrice == 0 ||
                _listings2hand[hash].unitPrice == unitPrice,
            "NFTMarket: token is listing with a price"
        );

        listingHashes2hand.push(hash);

        _listings2hand[hash] = NFTListing(
            unitPrice,
            msg.sender,
            _listings2hand[hash].amount + amount,
            totalAmount - amount,
            tokenID
        );

        tokenContract.safeTransferFrom(
            msg.sender,
            address(this),
            tokenID,
            amount,
            ""
        );

        emit NFTTransfer(
            tokenID,
            msg.sender,
            address(this),
            unitPrice,
            amount,
            0,
            0,
            0,
            0,
            "list"
        );
    }

    function buyNFT(
        uint256 tokenID,
        uint256 amount,
        address seller
    ) public nonReentrant {
        bytes memory hash = combineToBytes(seller, tokenID);

        NFTListing memory listing = _listings[hash];

        require(listing.unitPrice > 0, "NFTMarket: nft not listed for sale");

        uint256 currentTalSupply = talContract.balanceOf(msg.sender);

        require(
            currentTalSupply >= listing.unitPrice * amount,
            "NFTMarket: no enough tal tokens"
        );
        require(amount <= listing.amount, "NFTMarket: over available resource");

        if (listing.amount == amount) {
            removeHashFromHashes(hash);

            if (listing.unlistingAmount == 0)
                tokenContract.removeAddressToken(listing.seller, tokenID);
        }

        tokenContract.addAddressToken2hand(msg.sender, tokenID);

        clearListing(hash, amount);

        tokenContract.safeTransferFrom(
            address(this),
            msg.sender,
            tokenID,
            amount,
            ""
        );

        uint256 feeTALAmount = (listing.unitPrice *
            amount *
            10 ** 18 *
            feePercent) / 100;
        uint256 sellerTALAmount = (listing.unitPrice * amount * 10 ** 18) -
            feeTALAmount;

        talContract.transferFrom(msg.sender, listing.seller, sellerTALAmount);

        talContract.transferFrom(msg.sender, TalentIDOAddress, feeTALAmount);

        emit NFTTransfer(
            tokenID,
            address(this),
            msg.sender,
            listing.unitPrice,
            amount,
            sellerTALAmount,
            feeTALAmount,
            feePercent,
            0,
            "buy"
        );
    }

    function buyNFT2hand(
        uint256 tokenID,
        uint256 amount,
        address seller
    ) public nonReentrant {
        bytes memory hash = combineToBytes(seller, tokenID);

        NFTListing memory listing = _listings2hand[hash];

        require(listing.unitPrice > 0, "NFTMarket: nft not listed for sale");

        uint256 currentTalSupply = talContract.balanceOf(msg.sender);

        require(
            currentTalSupply >= listing.unitPrice * amount,
            "NFTMarket: no enough tal tokens"
        );
        require(amount <= listing.amount, "NFTMarket: over available resource");

        if (listing.amount == amount) {
            removeHashFromHashes2hand(hash);

            if (listing.unlistingAmount == 0)
                tokenContract.removeAddressToken2hand(listing.seller, tokenID);
        }

        tokenContract.addAddressToken2hand(msg.sender, tokenID);

        clearListing2hand(hash, amount);

        tokenContract.safeTransferFrom(
            address(this),
            msg.sender,
            tokenID,
            amount,
            ""
        );

        uint256 feeTALAmount = (listing.unitPrice *
            amount *
            10 ** 18 *
            feePercent2Hand) / 100;
        uint256 sellerTALAmount = (listing.unitPrice * amount * 10 ** 18) -
            feeTALAmount;

        talContract.transferFrom(msg.sender, listing.seller, sellerTALAmount);

        talContract.transferFrom(msg.sender, TalentIDOAddress, feeTALAmount);

        emit NFTTransfer(
            tokenID,
            address(this),
            msg.sender,
            listing.unitPrice,
            amount,
            sellerTALAmount,
            feeTALAmount,
            0,
            feePercent2Hand,
            "buy"
        );
    }

    function cancelListing(
        uint256 tokenID,
        uint256 amount
    ) public nonReentrant {
        bytes memory hash = combineToBytes(msg.sender, tokenID);

        NFTListing memory listing = _listings[hash];
        require(listing.amount > 0, "NFTMarket: nft not listed for sale");
        require(
            listing.seller == msg.sender,
            "NFTMarket: you're not the seller"
        );

        if (listing.amount == amount) removeHashFromHashes(hash);

        clearListing(hash, amount);

        tokenContract.safeTransferFrom(
            address(this),
            msg.sender,
            tokenID,
            amount,
            ""
        );

        emit NFTTransfer(
            tokenID,
            address(this),
            msg.sender,
            listing.unitPrice,
            amount,
            0,
            0,
            0,
            0,
            "cancel"
        );
    }

    function cancelListing2hand(
        uint256 tokenID,
        uint256 amount
    ) public nonReentrant {
        bytes memory hash = combineToBytes(msg.sender, tokenID);

        NFTListing memory listing = _listings2hand[hash];
        require(listing.amount > 0, "NFTMarket: nft not listed for sale");
        require(
            listing.seller == msg.sender,
            "NFTMarket: you're not the seller"
        );

        if (listing.amount == amount) removeHashFromHashes2hand(hash);

        clearListing2hand(hash, amount);

        tokenContract.safeTransferFrom(
            address(this),
            msg.sender,
            tokenID,
            amount,
            ""
        );

        emit NFTTransfer(
            tokenID,
            address(this),
            msg.sender,
            listing.unitPrice,
            amount,
            0,
            0,
            0,
            0,
            "cancel"
        );
    }

    /* ========== EVENTS ========== */
    function clearListing(bytes memory hash, uint256 soldAmount) private {
        if (_listings[hash].amount == soldAmount) {
            _listings[hash].unitPrice = 0;
            _listings[hash].seller = address(0);
            _listings[hash].amount = 0;
            _listings[hash].unlistingAmount = 0;
            _listings[hash].id = 0;
        } else {
            _listings[hash].amount = _listings[hash].amount - soldAmount;
        }
    }

    function clearListing2hand(bytes memory hash, uint256 soldAmount) private {
        if (_listings2hand[hash].amount == soldAmount) {
            _listings2hand[hash].unitPrice = 0;
            _listings2hand[hash].seller = address(0);
            _listings2hand[hash].amount = 0;
            _listings2hand[hash].unlistingAmount = 0;
            _listings2hand[hash].id = 0;
        } else {
            _listings2hand[hash].amount =
                _listings2hand[hash].amount -
                soldAmount;
        }
    }

    function combineToBytes(
        address account,
        uint256 tokenID
    ) private pure returns (bytes memory) {
        return abi.encodePacked(account, tokenID);
    }

    function bytesEquals(
        bytes memory b1,
        bytes memory b2
    ) private pure returns (bool) {
        uint256 l1 = b1.length;
        if (l1 != b2.length) return false;
        for (uint256 i = 0; i < l1; i++) {
            if (b1[i] != b2[i]) return false;
        }
        return true;
    }

    function removeHashFromHashes(bytes memory hash) private {
        for (uint256 index = 0; index < listingHashes.length; index++) {
            if (bytesEquals(hash, listingHashes[index])) {
                listingHashes[index] = listingHashes[listingHashes.length - 1];
                listingHashes.pop();
                break;
            }
        }
    }

    function removeHashFromHashes2hand(bytes memory hash) private {
        for (uint256 index = 0; index < listingHashes2hand.length; index++) {
            if (bytesEquals(hash, listingHashes2hand[index])) {
                listingHashes2hand[index] = listingHashes2hand[
                    listingHashes2hand.length - 1
                ];
                listingHashes2hand.pop();
                break;
            }
        }
    }

    /* ========== MODIFIERS ========== */
    modifier onlyTalentIDO(address caller) {
        require(caller == TalentIDOAddress, "Only TalentIDO");
        _;
    }

    /* ========== EVENTS ========== */
    event NFTTransfer(
        uint256 tokenID,
        address from,
        address to,
        uint256 unitPrice,
        uint256 amount,
        uint256 sellerTALAmount,
        uint256 feeTALAmount,
        uint8 feePercent,
        uint8 feePercent2Hand,
        string transferType
    );
}

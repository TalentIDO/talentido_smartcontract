// SPDX-License-Identifier: MIT

// File: @openzeppelin/contracts@4.7.3/security/ReentrancyGuard.sol


// OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)

pragma solidity ^0.8.0;

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 */
abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and making it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        // On the first call to nonReentrant, _notEntered will be true
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;

        _;

        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }
}

// File: @openzeppelin/contracts@4.7.3/token/ERC20/IERC20.sol


// OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}

// File: @openzeppelin/contracts@4.7.3/utils/introspection/IERC165.sol


// OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC165 standard, as defined in the
 * https://eips.ethereum.org/EIPS/eip-165[EIP].
 *
 * Implementers can declare support of contract interfaces, which can then be
 * queried by others ({ERC165Checker}).
 *
 * For an implementation, see {ERC165}.
 */
interface IERC165 {
    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

// File: @openzeppelin/contracts@4.7.3/token/ERC1155/IERC1155.sol


// OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/IERC1155.sol)

pragma solidity ^0.8.0;


/**
 * @dev Required interface of an ERC1155 compliant contract, as defined in the
 * https://eips.ethereum.org/EIPS/eip-1155[EIP].
 *
 * _Available since v3.1._
 */
interface IERC1155 is IERC165 {
    /**
     * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
     */
    event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);

    /**
     * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
     * transfers.
     */
    event TransferBatch(
        address indexed operator,
        address indexed from,
        address indexed to,
        uint256[] ids,
        uint256[] values
    );

    /**
     * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
     * `approved`.
     */
    event ApprovalForAll(address indexed account, address indexed operator, bool approved);

    /**
     * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
     *
     * If an {URI} event was emitted for `id`, the standard
     * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
     * returned by {IERC1155MetadataURI-uri}.
     */
    event URI(string value, uint256 indexed id);

    /**
     * @dev Returns the amount of tokens of token type `id` owned by `account`.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     */
    function balanceOf(address account, uint256 id) external view returns (uint256);

    /**
     * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
     *
     * Requirements:
     *
     * - `accounts` and `ids` must have the same length.
     */
    function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
        external
        view
        returns (uint256[] memory);

    /**
     * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
     *
     * Emits an {ApprovalForAll} event.
     *
     * Requirements:
     *
     * - `operator` cannot be the caller.
     */
    function setApprovalForAll(address operator, bool approved) external;

    /**
     * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
     *
     * See {setApprovalForAll}.
     */
    function isApprovedForAll(address account, address operator) external view returns (bool);

    /**
     * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
     *
     * Emits a {TransferSingle} event.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - If the caller is not `from`, it must have been approved to spend ``from``'s tokens via {setApprovalForAll}.
     * - `from` must have a balance of tokens of type `id` of at least `amount`.
     * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
     * acceptance magic value.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 amount,
        bytes calldata data
    ) external;

    /**
     * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
     *
     * Emits a {TransferBatch} event.
     *
     * Requirements:
     *
     * - `ids` and `amounts` must have the same length.
     * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
     * acceptance magic value.
     */
    function safeBatchTransferFrom(
        address from,
        address to,
        uint256[] calldata ids,
        uint256[] calldata amounts,
        bytes calldata data
    ) external;
}

// File: contracts/NFT/IToken.sol


pragma solidity ^0.8.4;


interface IToken is IERC1155 {
    function getAddressTokens(address account)
        external
        view
        returns (uint256[] memory);

    function getAddressTokens2hand(address account)
        external
        view
        returns (uint256[] memory);

    function getUri(uint256 tokenId) external view returns (string memory);

    function addAddressToken(address account, uint256 tokenId) external;

    function addAddressToken2hand(address account, uint256 tokenId) external;

    function removeAddressToken(address account, uint256 tokenId) external;
    
    function removeAddressToken2hand(address account, uint256 tokenId) external;
}

// File: @openzeppelin/contracts@4.7.3/utils/introspection/ERC165.sol


// OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)

pragma solidity ^0.8.0;


/**
 * @dev Implementation of the {IERC165} interface.
 *
 * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
 * for the additional interface id that will be supported. For example:
 *
 * ```solidity
 * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
 *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
 * }
 * ```
 *
 * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
 */
abstract contract ERC165 is IERC165 {
    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IERC165).interfaceId;
    }
}

// File: @openzeppelin/contracts@4.7.3/token/ERC1155/IERC1155Receiver.sol


// OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/IERC1155Receiver.sol)

pragma solidity ^0.8.0;


/**
 * @dev _Available since v3.1._
 */
interface IERC1155Receiver is IERC165 {
    /**
     * @dev Handles the receipt of a single ERC1155 token type. This function is
     * called at the end of a `safeTransferFrom` after the balance has been updated.
     *
     * NOTE: To accept the transfer, this must return
     * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
     * (i.e. 0xf23a6e61, or its own function selector).
     *
     * @param operator The address which initiated the transfer (i.e. msg.sender)
     * @param from The address which previously owned the token
     * @param id The ID of the token being transferred
     * @param value The amount of tokens being transferred
     * @param data Additional data with no specified format
     * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
     */
    function onERC1155Received(
        address operator,
        address from,
        uint256 id,
        uint256 value,
        bytes calldata data
    ) external returns (bytes4);

    /**
     * @dev Handles the receipt of a multiple ERC1155 token types. This function
     * is called at the end of a `safeBatchTransferFrom` after the balances have
     * been updated.
     *
     * NOTE: To accept the transfer(s), this must return
     * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
     * (i.e. 0xbc197c81, or its own function selector).
     *
     * @param operator The address which initiated the batch transfer (i.e. msg.sender)
     * @param from The address which previously owned the token
     * @param ids An array containing ids of each token being transferred (order and length must match values array)
     * @param values An array containing amounts of each token being transferred (order and length must match ids array)
     * @param data Additional data with no specified format
     * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
     */
    function onERC1155BatchReceived(
        address operator,
        address from,
        uint256[] calldata ids,
        uint256[] calldata values,
        bytes calldata data
    ) external returns (bytes4);
}

// File: @openzeppelin/contracts@4.7.3/token/ERC1155/utils/ERC1155Receiver.sol


// OpenZeppelin Contracts v4.4.1 (token/ERC1155/utils/ERC1155Receiver.sol)

pragma solidity ^0.8.0;



/**
 * @dev _Available since v3.1._
 */
abstract contract ERC1155Receiver is ERC165, IERC1155Receiver {
    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
        return interfaceId == type(IERC1155Receiver).interfaceId || super.supportsInterface(interfaceId);
    }
}

// File: @openzeppelin/contracts@4.7.3/token/ERC1155/utils/ERC1155Holder.sol


// OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/utils/ERC1155Holder.sol)

pragma solidity ^0.8.0;


/**
 * Simple implementation of `ERC1155Receiver` that will allow a contract to hold ERC1155 tokens.
 *
 * IMPORTANT: When inheriting this contract, you must include a way to use the received tokens, otherwise they will be
 * stuck.
 *
 * @dev _Available since v3.1._
 */
contract ERC1155Holder is ERC1155Receiver {
    function onERC1155Received(
        address,
        address,
        uint256,
        uint256,
        bytes memory
    ) public virtual override returns (bytes4) {
        return this.onERC1155Received.selector;
    }

    function onERC1155BatchReceived(
        address,
        address,
        uint256[] memory,
        uint256[] memory,
        bytes memory
    ) public virtual override returns (bytes4) {
        return this.onERC1155BatchReceived.selector;
    }
}

// File: @openzeppelin/contracts@4.7.3/utils/Context.sol


// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)

pragma solidity ^0.8.0;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

// File: @openzeppelin/contracts@4.7.3/access/Ownable.sol


// OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)

pragma solidity ^0.8.0;


/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

// File: contracts/NFT/Marketplace.sol


pragma solidity ^0.8.4;

struct NFTListing {
    uint256 unitPrice;
    address seller;
    uint256 amount;
    uint256 unlistingAmount;
    uint256 id;
}

contract Marketplace is Ownable, ERC1155Holder, ReentrancyGuard {
    /* ========== STATE VARIABLES ========== */
    mapping(bytes => NFTListing) private _listings;
    mapping(bytes => NFTListing) private _listings2hand;

    bytes[] public listingHashes;
    bytes[] public listingHashes2hand;
    bytes private zeroHash;

    IToken private tokenContract;
    IERC20 private talContract;

    address constant TalentIDOAddress = 0x5899e2a82bF0789a1953cD1268c5dFB4fA213aF9;
    uint8 private feePercent = 10;
    uint8 private feePercent2Hand = 2;

    /* ========== CONSTRUCTOR ========== */
    constructor(address tokenContractAddress, address talContractAddress) {
        tokenContract = IToken(tokenContractAddress);
        talContract = IERC20(talContractAddress);
    }

    /* ========== VIEWS ========== */
    function listingTokens(uint256 offset, uint256 size)
        public
        view
        returns (NFTListing[] memory)
    {
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

    function getOneToken(uint256 tokenID, address seller)
        public
        view
        returns (NFTListing memory)
    {
        bytes memory hash = combineToBytes(seller, tokenID);

        NFTListing memory nft = _listings[hash];

        return nft;
    }

    function listingTokens2hand(uint256 offset, uint256 size)
        public
        view
        returns (NFTListing[] memory)
    {
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

    function getOneToken2hand(uint256 tokenID, address seller)
        public
        view
        returns (NFTListing memory)
    {
        bytes memory hash = combineToBytes(seller, tokenID);

        NFTListing memory nft = _listings2hand[hash];

        return nft;
    }

    function accountListingTokens(address account)
        public
        view
        returns (NFTListing[] memory)
    {
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

    function accountListingTokens2hand(address account)
        public
        view
        returns (NFTListing[] memory)
    {
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
            0,0,0,0,
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
            0,0,0,0,
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

        uint256 feeTALAmount = (listing.unitPrice * amount * 10**18 * feePercent) / 100;
        uint256 sellerTALAmount = (listing.unitPrice * amount * 10**18) - feeTALAmount;

        talContract.transferFrom(
            msg.sender,
            listing.seller,
            sellerTALAmount
        );

        talContract.transferFrom(
            msg.sender,
            TalentIDOAddress,
            feeTALAmount
        );

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

        uint256 feeTALAmount = (listing.unitPrice * amount * 10**18 * feePercent2Hand) / 100;
        uint256 sellerTALAmount = (listing.unitPrice * amount * 10**18) - feeTALAmount;

        talContract.transferFrom(
            msg.sender,
            listing.seller,
            sellerTALAmount
        );

        talContract.transferFrom(
            msg.sender,
            TalentIDOAddress,
            feeTALAmount
        );

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

    function cancelListing(uint256 tokenID, uint256 amount)
        public
        nonReentrant
    {
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
            0,0,0,0,
            "cancel"
        );
    }

    function cancelListing2hand(uint256 tokenID, uint256 amount)
        public
        nonReentrant
    {
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
            0,0,0,0,
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

    function combineToBytes(address account, uint256 tokenID)
        private
        pure
        returns (bytes memory)
    {
        return abi.encodePacked(account, tokenID);
    }

    function bytesEquals(bytes memory b1, bytes memory b2)
        private
        pure
        returns (bool)
    {
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
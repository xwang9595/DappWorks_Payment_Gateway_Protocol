// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

interface IDIDRegistry {
    function registerDid(string memory did, string memory pubkey) external;
    function updateDid(string memory did, string memory pubkey) external;
    function getPublicKeyJwk(string memory did) view external returns(string memory pubkey);
}

// OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)

// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)

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

contract DIDRegistry is IDIDRegistry, Ownable {
    mapping(string => string) private dids;
    string private keyType;

    constructor() {
        keyType = "EcdsaSecp256k1VerificationKey2019";
    }
    function registerDid(string memory did, string memory pubkey) external override onlyOwner {
        require(bytes(dids[did]).length == 0, "DID already registered");
        require(bytes(pubkey).length > 0, "Invalid public key");
        dids[did] = pubkey;
    }
    function updateDid(string memory did, string memory  pubkey) external override onlyOwner {
        require(bytes(dids[did]).length > 0, "DID not registered");
        require(bytes(pubkey).length > 0, "Invalid public key");
        dids[did] = pubkey;
    }
    function getPublicKeyJwk(string memory did) view external override returns(string memory  pubKeyJwk) {
        require(bytes(dids[did]).length > 0, "DID not registered");
        pubKeyJwk = dids[did];
    }

    function getType() view external returns(string memory) {
        return keyType;
    }

    function setType(string memory type_) external onlyOwner {
        keyType = type_;
    }

}
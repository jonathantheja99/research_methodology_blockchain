// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title TransparencyRegistry — System B (blockchain-based transparency system)
/// @notice Decentralized counterpart to the centralized Flask API (System A).
///         Records of aid recipients are written immutably to the blockchain.
///         There is deliberately NO function to modify or delete a record:
///         once written, data cannot be tampered with, and every write emits an
///         event that is permanently verifiable on a public explorer (Etherscan).
///
/// Designed to be compiled and deployed in Remix IDE, signed with MetaMask, and
/// run on the Ethereum Sepolia Testnet (no real funds involved).
contract TransparencyRegistry {

    struct Recipient {
        address wallet;   // recipient's wallet address
        uint256 amount;   // amount allocated to the recipient
        bool registered;  // guards against overwriting an existing record
    }

    // wallet address => recipient record
    mapping(address => Recipient) private recipients;

    /// @notice Emitted on every successful registration. This is the public,
    ///         tamper-proof audit trail — each event is tied to a transaction
    ///         hash that anyone can verify on Etherscan.
    event RecipientRegistered(
        address indexed wallet,
        uint256 amount,
        address indexed registeredBy
    );

    /// @notice Register a new aid recipient on-chain (the legitimate data entry).
    /// @dev Reverts if the wallet is already registered — this is what makes the
    ///      system immutable and demonstrates that records cannot be manipulated,
    ///      unlike System A's PUT /manipulate/<id> endpoint.
    function registerRecipient(address _wallet, uint256 _amount) public {
        require(!recipients[_wallet].registered, "Record already exists and cannot be modified");
        recipients[_wallet] = Recipient(_wallet, _amount, true);
        emit RecipientRegistered(_wallet, _amount, msg.sender);
    }

    /// @notice Retrieve the stored details of a recipient (the read operation).
    function getRecipientInfo(address _wallet)
        public
        view
        returns (address wallet, uint256 amount, bool registered)
    {
        Recipient memory r = recipients[_wallet];
        return (r.wallet, r.amount, r.registered);
    }
}

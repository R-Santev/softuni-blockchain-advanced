// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import "forge-std/console.sol";

contract Vault {
    address public immutable owner;
    uint256 public balance;

    constructor() payable {
        owner = msg.sender;
        balance = msg.value;
    }

    function withdawBalance(
        uint256 amount,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) public {
        bytes memory data = abi.encodePacked(msg.sender, amount);
        console.logBytes(data);

        require(_verifySignature(data, v, r, s) == owner, "no approval");

        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success == true, "no transfer");
    }

    function _verifySignature(
        bytes memory data,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) internal pure returns (address) {
        bytes32 hash = keccak256(data);
        console.logBytes32(hash);

        // Recover the signer's address
        address signer = ecrecover(hash, v, r, s);
        require(signer != address(0), "Invalid signature");
        return signer;
    }

    function verifySignature(
        bytes memory data,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) public pure returns (address) {
        bytes32 hash = keccak256(
            abi.encodePacked(
                data // Data to sign
            )
        );

        // Recover the signer's address
        address signer = ecrecover(hash, v, r, s);
        require(signer != address(0), "Invalid signature");
        return signer;
    }
}

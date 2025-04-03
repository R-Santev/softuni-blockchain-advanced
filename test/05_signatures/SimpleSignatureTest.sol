// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import "forge-std/Test.sol";
import {Vault} from "./../../src/05_signatures/SimpleSignature.sol";

contract SimpleSignatureTest is Test {
    Vault simpleSignatureContract;
    uint256 privateKeySigner;
    address signer;

    function setUp() public {
        privateKeySigner = 0x11;
        signer = vm.addr(privateKeySigner);

        vm.deal(signer, 2 ether);
        vm.prank(signer);
        simpleSignatureContract = new Vault{value: 1 ether}();
    }

    function testSignatureVerification() public view {
        // Prepare data to sign
        bytes memory data = abi.encode("secret value");
        bytes32 hash = keccak256(data);
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(privateKeySigner, hash);
        address recovered = simpleSignatureContract.verifySignature(
            data,
            v,
            r,
            s
        );

        assertEq(recovered, signer, "Signature verification failed");
    }

    function testSignatureVerificationFalse() public view {
        // Prepare data to sign
        bytes memory data = abi.encode("secret value");
        bytes32 hash = keccak256(data);
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(privateKeySigner, hash);

        bytes memory dataTwo = abi.encode("secret value 2");
        address recovered = simpleSignatureContract.verifySignature(
            dataTwo,
            v,
            r,
            s
        );

        assertNotEq(recovered, signer, "Signature verification is successful");
    }

    function testVault() public {
        uint256 value = 0.5 ether;
        // Prepare data to sign

        bytes memory data = abi.encodePacked(address(this), value);
        bytes32 hash = keccak256(data);

        (uint8 v, bytes32 r, bytes32 s) = vm.sign(privateKeySigner, hash);

        uint256 balanceBefore = address(this).balance;
        simpleSignatureContract.withdawBalance(value, v, r, s);
        uint256 balanceAfter = address(this).balance;

        assertEq(
            balanceAfter,
            balanceBefore + value,
            "Signature verification failed"
        );
    }

    receive() external payable {}
}

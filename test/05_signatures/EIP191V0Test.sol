// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import "forge-std/Test.sol";
import {VaultEIP191} from "./../../src/05_signatures/EIP191V0.sol";

contract SimpleSignatureTest is Test {
    VaultEIP191 simpleSignatureContract;
    uint256 privateKeySigner;
    address signer;

    function setUp() public {
        privateKeySigner = 0x11;
        signer = vm.addr(privateKeySigner);

        vm.deal(signer, 2 ether);
        vm.prank(signer);
        simpleSignatureContract = new VaultEIP191{value: 1 ether}();
    }

    function testVault() public {
        uint256 value = 0.5 ether;
        // Prepare data to sign

        bytes memory data = abi.encodePacked(
            bytes1(0x19),
            bytes1(0x00),
            address(simpleSignatureContract),
            address(this),
            value
        );
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

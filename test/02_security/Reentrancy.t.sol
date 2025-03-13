// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Reentrance} from "../../src/02_security/Reentrancy.sol";
import {ReentrancyAttack} from "../../src/02_security/Reentrancy.sol";

contract ReentrancyTest is Test {
    Reentrance donation;
    address userAttacker;
    address normalUser;

    function setUp() public {
        donation = new Reentrance();

        userAttacker = makeAddr("userAttacker");
        normalUser = makeAddr("normalUser");

        vm.deal(userAttacker, 1 ether);
        vm.deal(normalUser, 1 ether);
    }

    function test_Reentrancy() public {
        int256 attackAmount = 1 ether;

        vm.prank(normalUser);
        donation.donate{value: 1 ether}(normalUser);

        vm.prank(userAttacker);
        ReentrancyAttack attackContract = new ReentrancyAttack(
            payable(address(donation)),
            attackAmount
        );

        vm.prank(userAttacker);
        donation.donate{value: 1 ether}(address(attackContract));

        console.log(
            "Attack contract balance: ",
            address(attackContract).balance
        );

        console.log("donation contract balance: ", address(donation).balance);
        console.log("normal user balance: ", donation.balanceOf(normalUser));
        console.log(
            "attacker contract user balance: ",
            donation.balanceOf(address(attackContract))
        );

        vm.prank(userAttacker);
        attackContract.attack();

        console.log(
            "Attack contract balance: ",
            address(attackContract).balance
        );

        console.log("donation contract balance: ", address(donation).balance);

        console.log("normal user balance: ", donation.balanceOf(normalUser));
        console.log(
            "attacker contract user balance: ",
            donation.balanceOf(address(attackContract))
        );
    }
}

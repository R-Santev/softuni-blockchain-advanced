// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Denial, DoSAttack} from "../../src/02_security/DoS.sol";

contract DoSTest is Test {
    Denial denial;
    address userAttacker;
    address owner;

    function setUp() public {
        owner = makeAddr("owner");
        userAttacker = makeAddr("userAttacker");

        vm.deal(userAttacker, 1 ether);
        vm.deal(owner, 1 ether);

        denial = new Denial(owner);
    }

    function test_DenialOfService() public {
        vm.prank(userAttacker);
        DoSAttack attackerContract = new DoSAttack(address(denial));

        vm.prank(owner);
        denial.setWithdrawPartner(address(attackerContract));

        vm.prank(userAttacker);
        attackerContract.withdraw();

        vm.prank(owner);
        denial.withdraw();
    }
}

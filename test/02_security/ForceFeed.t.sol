// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {ForceFeed, Attacker} from "../../src/02_security/ForceFeed.sol";

contract ForceFeedTest is Test {
    ForceFeed forceFeed;
    address userAttacker;

    function setUp() public {
        userAttacker = makeAddr("userAttacker");

        vm.deal(userAttacker, 10 ether);

        forceFeed = new ForceFeed();
    }

    function test_ForceFeed() public {
        vm.prank(userAttacker);
        Attacker attackerContract = new Attacker();

        console.log("not started method: ", forceFeed.isNotStarted());
        console.log(
            "isNotStartedRobust method: ",
            forceFeed.isNotStartedRobust()
        );

        vm.startPrank(userAttacker);
        payable(attackerContract).transfer(5 ether);
        attackerContract.attack(payable(address(forceFeed)));
        vm.stopPrank();

        console.log("not started method: ", forceFeed.isNotStarted());
        console.log(
            "isNotStartedRobust method: ",
            forceFeed.isNotStartedRobust()
        );
    }
}

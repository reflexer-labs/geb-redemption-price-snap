pragma solidity ^0.6.7;

import "ds-test/test.sol";

import "./GebRedemptionPriceSnap.sol";

contract GebRedemptionPriceSnapTest is DSTest {
    GebRedemptionPriceSnap snap;

    function setUp() public {
        snap = new GebRedemptionPriceSnap();
    }

    function testFail_basic_sanity() public {
        assertTrue(false);
    }

    function test_basic_sanity() public {
        assertTrue(true);
    }
}

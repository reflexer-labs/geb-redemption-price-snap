pragma solidity ^0.6.7;

import "ds-test/test.sol";

import "./RedemptionPriceSnap.sol";

contract RedemptionPriceSnapTest is DSTest {
    RedemptionPriceSnap snap;

    function setUp() public {
        snap = new RedemptionPriceSnap();
    }

    function testFail_basic_sanity() public {
        assertTrue(false);
    }

    function test_basic_sanity() public {
        assertTrue(true);
    }
}
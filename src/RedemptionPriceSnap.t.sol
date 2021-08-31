pragma solidity ^0.6.7;

import "ds-test/test.sol";

import "geb/single/SAFEEngine.sol";
import "geb/single/OracleRelayer.sol";

import "./RedemptionPriceSnap.sol";

abstract contract Hevm {
    function warp(uint256) virtual public;
}

contract RedemptionPriceSnapTest is DSTest {
    Hevm hevm;

    SAFEEngine safeEngine;
    OracleRelayer oracleRelayer;

    RedemptionPriceSnap snap;

    uint256 redemptionPrice = 5 * RAY;

    uint256 constant RAY = 10 ** 27;

    function setUp() public {
        hevm = Hevm(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);
        hevm.warp(604411200);

        safeEngine = new SAFEEngine();

        oracleRelayer = new OracleRelayer(address(safeEngine));
        oracleRelayer.modifyParameters("redemptionPrice", redemptionPrice);

        safeEngine.addAuthorization(address(oracleRelayer));

        snap = new RedemptionPriceSnap(address(oracleRelayer));
    }

    function test_setup() public {
        assertEq(snap.authorizedAccounts(address(this)), 1);
        assertEq(address(snap.oracleRelayer()), address(oracleRelayer));
    }
    function test_modify_parameters() public {
        OracleRelayer newOracleRelayer = new OracleRelayer(address(safeEngine));
        newOracleRelayer.modifyParameters("redemptionPrice", redemptionPrice * 101 / 100);

        snap.modifyParameters("oracleRelayer", address(newOracleRelayer));
        assertEq(address(snap.oracleRelayer()), address(newOracleRelayer));
    }
    function test_update_snapped_price() public {
        oracleRelayer.modifyParameters("redemptionRate", 10 ** 27 + 10 ** 27 / 2);
        oracleRelayer.redemptionPrice();

        hevm.warp(now + 5 seconds);
        snap.updateSnappedPrice();

        assertTrue(oracleRelayer.redemptionPrice() > redemptionPrice);
    }
    function testFail_update_snapped_price_overflow() public {
        oracleRelayer.redemptionPrice();

        oracleRelayer.modifyParameters("redemptionPrice", uint(-1) - 1);
        oracleRelayer.modifyParameters("redemptionRate", 10 ** 27 + 10 ** 27 / 2);

        hevm.warp(now + 5 seconds);
        snap.updateSnappedPrice();

        assertEq(oracleRelayer.redemptionPrice(), uint(-1) - 1);
    }
    function test_update_and_get_snapped_price() public {
        oracleRelayer.modifyParameters("redemptionRate", 10 ** 27 + 10 ** 27 / 2);
        oracleRelayer.redemptionPrice();

        hevm.warp(now + 5 seconds);

        uint256 newRedemptionPrice = snap.updateAndGetSnappedPrice();
        assertTrue(oracleRelayer.redemptionPrice() > redemptionPrice);
    }
}

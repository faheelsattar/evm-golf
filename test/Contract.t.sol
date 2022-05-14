// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";

contract TestContract is Test {
    address contractAddress;
    address user;
    address sUSD;

    uint256 timestamp;
    uint256 totalSupply;

    bytes totalSupplySelector;
    bytes constant bytecode =
        hex"423d55336001556318160ddd3d5260143d60043d7357ab1ec28d129707052df4df418d58a2d46d5f515afa3d5160035560143df3";

    function createHelperAddress() public {
        address predictedAddress;
        bytes memory copyBytecode = bytecode;

        assembly {
            predictedAddress := create(0, copyBytecode, 0)
        }

        contractAddress = predictedAddress;
    }

    function setUp() public {
        createHelperAddress();
        sUSD = address(0x57Ab1ec28D129707052df4dF418D58a2D46d5f51);
        user = address(0x1233);
        timestamp = 0x6ea;
        vm.etch(contractAddress, abi.encodePacked(bytecode));
    }

    function testGolf2() public {
        vm.prank(user);
        vm.warp(timestamp);

        (bool success, ) = contractAddress.call("");

        bytes32 slot0 = vm.load(contractAddress, 0x0);
        bytes32 slot1 = vm.load(contractAddress, bytes32(uint256(1)));

        assertEq(uint256(slot0), timestamp);
        assertEq(address(uint160(uint256(slot1))), user);
    }
}

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

contract SafeMathTest {
    uint8 public bigNumber = 255;

    function addOne() public {
        // unchecked keyword makes your contract more gas efficient
        unchecked {
            bigNumber += 1;
        }
        // bigNumber += 1; // this would fail since we are using a ^0.8.0 compiler.
    }
}

// SPDX-License-Identifier: MIT
pragma solidity 0.8.8;

contract SimpleStorage {
 
    uint256 public favoriteNumber;

    function store (uint256 _favoritenumber) public {
        favoriteNumber = _favoritenumber;
        favoriteNumber = favoriteNumber + 1;
        favoriteNumber = favoriteNumber + 1;
        favoriteNumber = favoriteNumber + 1;
        favoriteNumber = favoriteNumber + 1;
    }

    // visibility specifiers - public - private - external - (internal)

}
    // 0xd2a5bC10698FD955D1Fe6cb468a17809A08fd005
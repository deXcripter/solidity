// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract SimpleStorage {
 
    uint256 public myFavoriteNumber;

    uint256[] listOfFavouredNumbers;

    struct Person {
        uint256 favouriteNumber;
        string name;
        bool adult;
    }

    Person public John = Person(30, "Johnpaul", true);
}
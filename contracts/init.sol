// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26; 

contract SimpleStorage {
       uint256 favoriteNumber;

       struct Person {
        uint256 personFavoriteNumber;
        string name;
       }

       Person public john = Person(23, "Johnpaul");

       function store(uint256 _favoriteNumber) public {
            favoriteNumber = _favoriteNumber;
         }

        function retrieve() public view returns (uint256) {
          return favoriteNumber;
        }
}
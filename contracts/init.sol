// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26; 

contract SimpleStorage {
       uint256 favoriteNumber;

       struct Person {
        uint256 personFavoriteNumber;
        string name;
       }

      // this is a dynamic array
       Person[] public listOfPeople;

       // this is a static array but capped at size 3
      //  Person[3] public listOfPeople;

       function addPerson(string memory _name, uint256 _favoriteNumber) public {
            Person memory newPerson = Person(_favoriteNumber, _name);
            listOfPeople.push(newPerson);
       }
}
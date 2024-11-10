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

       mapping(string => uint256) public nameToFavoriteNumber;

       function addPerson(string memory _name, uint256 _favoriteNumber) public {
            Person memory newPerson = Person(_favoriteNumber, _name);
            listOfPeople.push(newPerson);
            nameToFavoriteNumber[_name] = _favoriteNumber
       }
}
// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract SimpleStorage {
 
    uint256 public myFavoriteNumber;

    struct Person {
        uint256 favouriteNumber;
        string name;
        bool adult;
    }

    // this is stressful
   // Person public John = Person(30, "Johnpaul", true);
   // Person public Paul = Person(30, "Paul", true);
   // Person public Favour = Person(30, "Favour", true);

    // dynamic array
    Person[] public listOfPeople;

    // this is a static array but capped at size 3
    Person[3] public listOfThreePeople;

    function addPerson (string memory name, uint256 _favouriteNumber) public  {
        Person memory newPerson = Person({name: name, favouriteNumber: _favouriteNumber, adult: true});
        listOfPeople.push(newPerson);
    }
}
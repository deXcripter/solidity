// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract SimpleStorage {
    
    struct Person {
        string name;
        int256 age; 
        bool male;
    }

    Person[] public listOfregisteredPeople;

    mapping(string => Person) public people;


    function addPerson (string memory name, int number, bool male) public {
        Person memory newPerson = Person({name: name, age: number, male: male});
        listOfregisteredPeople.push(newPerson);   
        people[name] = newPerson;     
    }
}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "./SimpleStorage.sol";

contract StorageFactory {

      SimpleStorage public mySimpleStorage;

    function createSimpleStorageContract () public {
         mySimpleStorage = new SimpleStorage();
        // type - visibility - variable
    }

}

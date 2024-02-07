// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract RetailerInventoryStorage {

    // Address of Organization che gestisce gli utenti
    address private  RetailerOrg;

    constructor(){
        RetailerOrg = msg.sender;
    }
}
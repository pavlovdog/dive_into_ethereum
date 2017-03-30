pragma solidity ^0.4.0;

import "structures.sol";

contract EthereumCV is Structures{
    mapping (bytes32 => bytes32) basic_data;
    address owner;

    Project[] projects;
    Education[] educations;
    Quote[] quotes;

    // =====================
    // ==== CONSTRUCTOR ====
    // =====================
    function EthereumCV(
        bytes32 name,
        bytes32 age,
        bytes32 email,
        bytes32 country,
        bytes32 city
    ){
        basic_data["name"] = name;
        basic_data["age"] = age;
        basic_data["email"] = email;
        basic_data["country"] = country;
        basic_data["city"] = city;

        owner = msg.sender;
    }
}

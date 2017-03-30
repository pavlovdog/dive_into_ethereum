pragma solidity ^0.4.0;

contract Structures {
    struct Project {
        bytes32 name;
        bytes32 description;
        int32 year_start;
        int32 year_finish;
    }

    struct Education {
        bytes32 name;
        bytes32 speciality;
        int32 year_start;
        int32 year_finish;
    }

    struct Quote {
        bytes32 author;
        bytes32 quote;
    }
}

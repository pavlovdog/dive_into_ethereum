pragma solidity ^0.4.0;

contract Structures {
    struct Project {
        string name;
        string description;
        int32 year_start;
        int32 year_finish;
    }

    struct Education {
        string name;
        string speciality;
        int32 year_start;
        int32 year_finish;
    }

    struct Quote {
        string author;
        string quote;
    }

    struct Skill {
        string name;
        int32 level;
    }
}

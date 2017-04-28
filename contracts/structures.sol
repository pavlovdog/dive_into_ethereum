pragma solidity ^0.4.0;

library Structures {
    struct Project {
        string name;
        string link;
        string description;
    }

    struct Education {
        string name;
        string speciality;
        int32 year_start;
        int32 year_finish;
    }

    struct Publication {
        string name;
        string link;
        string language;
    }

    struct Skill {
        string name;
        int32 level;
    }
}

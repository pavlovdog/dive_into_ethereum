pragma solidity ^0.4.0;

import "./structures.sol";

contract EthereumCV {
    mapping (string => string) basic_data;
    address owner;

    Structures.Project[] public projects;
    Structures.Education[] public educations;
    Structures.Skill[] public skills;
    Structures.Publication[] public publications;

    // =====================
    // ==== CONSTRUCTOR ====
    // =====================
    function EthereumCV() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
    	if (msg.sender != owner) { throw; }
    	_; // Will be replaced with function's body
    }

    // =====================
    // ====== ADD NEW ======
    // =====================

    function setBasicData (string key, string value) onlyOwner() {
        basic_data[key] = value;
    }

    function editProject (
        bool operation,
        string name,
        string link,
        string description
    ) onlyOwner() {
        if (operation) {
            projects.push(Structures.Project(name, description, link));
        } else {
            delete projects[projects.length - 1];
        }
    }

    function editEducation (
        bool operation,
        string name,
        string speciality,
        int32 year_start,
        int32 year_finish
    ) onlyOwner() {
        if (operation) {
            educations.push(Structures.Education(name, speciality, year_start, year_finish));
        } else {
            delete educations[educations.length - 1];
        }
    }

    function editSkill(bool operation, string name, int32 level) onlyOwner() {
        if (operation) {
            skills.push(Structures.Skill(name, level));
        } else {
            delete skills[skills.length - 1];
        }
    }

    function editPublication (bool operation, string name, string link, string language) onlyOwner() {
        if (operation) {
            publications.push(Structures.Publication(name, link, language));
        } else {
            delete publications[publications.length - 1];
        }
    }

    // =====================
    // ======= USAGE =======
    // =====================
    function getBasicData (string arg) constant returns (string) {
        return basic_data[arg];
    }

    function getSize(string arg) constant returns (uint) {
        if (sha3(arg) == sha3("projects")) { return projects.length; }
        if (sha3(arg) == sha3("educations")) { return educations.length; }
        if (sha3(arg) == sha3("publications")) { return publications.length; }
        if (sha3(arg) == sha3("skills")) { return skills.length; }
        throw;
    }
}

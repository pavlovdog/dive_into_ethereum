pragma solidity ^0.4.0;

import "./structures.sol";

contract EthereumCV is Structures {
    mapping (string => string) basic_data;
    address owner;

    Project[] public projects;
    Education[] public educations;
    Skill[] public skills;
    Quote[] public quotes;

    // =====================
    // ==== CONSTRUCTOR ====
    // =====================
    function EthereumCV() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
    	if (msg.sender != owner) { throw; }
    	_; // Will be replaced with function body
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
        string description,
        int32 year_start,
        int32 year_finish
    ) onlyOwner() {
        if (operation) {
            projects.push(Project(name, description, link, year_start, year_finish));
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
            educations.push(Education(name, speciality, year_start, year_finish));
        } else {
            delete educations[educations.length - 1];
        }
    }

    function editSkill(bool operation, string name, int32 level) onlyOwner() {
        if (operation) {
            skills.push(Skill(name, level));
        } else {
            delete skills[skills.length - 1];
        }
    }

    function editQuote (bool operation, string author, string quote) onlyOwner() {
        if (operation) {
            quotes.push(Quote(author, quote));
        } else {
            delete quotes[quotes.length - 1];
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
        if (sha3(arg) == sha3("quotes")) { return quotes.length; }
        if (sha3(arg) == sha3("skills")) { return skills.length; }
        throw;
    }
}

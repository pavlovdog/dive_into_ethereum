pragma solidity ^0.4.0;

import "./structures.sol";

contract EthereumCV is Structures {
    mapping (string => string) basic_data;
    address owner;

    Project[] public projects;
    Education[] public educations;
    Skill[] public skills;
    Quote[] public quotes;
    Contact[] public contacts;

    // =====================
    // ==== CONSTRUCTOR ====
    // =====================
    function EthereumCV() {
        owner = msg.sender;
    }

    // =====================
    // ====== ADD NEW ======
    // =====================

    function setBasicData (string key, string value) {
        if (msg.sender != owner) { throw; }
        basic_data[key] = value;
    }

    function editProject (
        bool operation,
        string name,
        string link,
        string description,
        int32 year_start,
        int32 year_finish
    ){
        if (msg.sender != owner) { throw; }
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
    ){
        if (msg.sender != owner) { throw; }
        if (operation) {
            educations.push(Education(name, speciality, year_start, year_finish));
        } else {
            delete educations[educations.length - 1];
        }
    }

    function editSkill(bool operation, string name, int32 level) {
        if (msg.sender != owner) { throw; }
        if (operation) {
            skills.push(Skill(name, level));
        } else {
            delete skills[skills.length - 1];
        }
    }

    function editQuote (bool operation, string author, string quote) {
        if (msg.sender != owner) { throw; }
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
        if (sha3(arg) == sha3("contacts")) { return contacts.length; }
        throw;
    }

    function contactForm(string email, string name, string message) {
        contacts.push(Contact(email, name, message));
    }
}

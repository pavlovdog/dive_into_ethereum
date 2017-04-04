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
    function EthereumCV(
        string name,
        string age,
        string email,
        string country,
        string city
    ){
        basic_data["name"] = name;
        basic_data["age"] = age;
        basic_data["email"] = email;
        basic_data["country"] = country;
        basic_data["city"] = city;

        owner = msg.sender;
    }

    // =====================
    // ====== ADD NEW ======
    // =====================

    function newProject (
        string name,
        string description,
        int32 year_start,
        int32 year_finish
    ){
        if (msg.sender != owner) { throw; }
        projects.push(Project(name, description, year_start, year_finish));
    }

    function newEducation (
        string name,
        string speciality,
        int32 year_start,
        int32 year_finish
    ){
        if (msg.sender != owner) { throw; }
        educations.push(Education(name, speciality, year_start, year_finish));
    }

    function newQuote (string author, string quote) {
        if (msg.sender != owner) { throw; }
        quotes.push(Quote(author, quote));
    }

    // =====================
    // ======= USAGE =======
    // =====================
    function getBasicData (string arg) returns (string) {
        return basic_data[arg];
    }

    function getSize(string arg) returns (uint) {
        if (sha3(arg) == sha3("projects")) { return projects.length; }
        if (sha3(arg) == sha3("educations")) { return educations.length; }
        if (sha3(arg) == sha3("quotes")) { return quotes.length; }
        if (sha3(arg) == sha3("skills")) { return skills.length; }
    }

    function contactForm(string email, string name, string message) {
        contacts.push(Contact(email, name, message));
    }
}

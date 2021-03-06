//SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;
import "hardhat/console.sol";

// written for Solidity version 0.7.0 and above that doesn't break functionality

contract Voting {
// an event that is called whenever a Candidate is added so the frontend could
// appropriately display the candidate with the right element id (it is used
// to vote for the candidate, since it is one of arguments for the function
// "vote")

    address owner;
    constructor () {
        owner=msg.sender;
    }
modifier onlyOwner {
require(msg.sender == owner);
_; }

struct Voter {
uint candidateIDVote; 
bool hasVoted;
bool isAuthorized;
bool doesExist;
}

// this flag will help authorization of voter
// this flag will help to keep track of 1 voter - 1 vote
// describe a candidate

struct Candidate {
    string name;
    string party;
    uint noOFVotes;
    bool doesExist;
}

// "bool doesExist" is to check if this Struct exists
// This is so we can keep track of the candidates

// These state variables are used to keep track of the number of candidates/voters 
// and used to as a way to index them

uint numCandidates; // declares a state variable - number of candidates
uint numVoters;
uint numOfVotes;
uint numofAuthVoters;

// Think of these as a hash table with the key as a uint and a value of the struct candidate/voter
// these mappings will be used in majority of transactions/calls
// these mappings will hold all the candidates and voters respectively

mapping (uint => Candidate) candidates;
mapping (address => Voter) voters;

// following functions perform transaction, editing the mappings

function addCandidate (string memory name, string memory party) onlyOwner
public {
    // candidateID is the return variable
    uint candidateID = numCandidates++;

    // create new candidate Struct with name and saves it to storage
    candidates[candidateID] = Candidate(name, party, 0, true);  
}

// This function is used to register voters

function registerVoter() public {
    require(!voters[msg.sender].doesExist); // To avoid double registration
    voters[msg.sender] = Voter(0, false, false, true);
    numVoters++;
}

// this function is used to Authorize voter to cast the vote

function Authorize(address voterAddr) onlyOwner public {
    require(voters[voterAddr].doesExist);
    require(!voters[voterAddr].isAuthorized);
        voters[voterAddr].isAuthorized = true;
        numofAuthVoters++;
}

function getNumofAuthrizedVoters () public view returns (uint){
    return numofAuthVoters;
}

// Public Function "vote" as a transaction

function vote(uint candidateID)
public {
    // checks if the struct exists for the candidate
    require (!voters[msg.sender].hasVoted);
    // this statement is to check this voter has not already voted
    if (candidates[candidateID].doesExist == true)
    {
        voters[msg.sender] = Voter(candidateID, true, true, true);
        candidates[candidateID].noOFVotes++;
        numOfVotes++;
        numVoters++;
    }
}

// Getter functions, marked by keyword view
//find total number of vites for a specific candidates by looping through votes

function totalVotes(uint candidateID) view public returns (uint){
    return candidates[candidateID].noOFVotes;
}

function getNumOfCandidates() public view returns (uint) {
    return numCandidates;
}

function getNumOfVotes() public view returns (uint) {
    return numVoters;
}

// returns candidate information including its ID , name and party

function getCandidate(uint candidateID) public view returns (uint, string memory, string memory, uint) 
    {
    return (candidateID, candidates[candidateID].name, candidates[candidateID].party, candidates[candidateID].noOFVotes);    
    }
}

// First Solidity Program worked fine lets test

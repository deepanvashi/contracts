pragma solidity >=0.7.0 <0.8.15; 


import "hardhat/console.sol";    // print logging messages and contract variables


contract collectEther {

    //this is a fallback function
    //it must be marked as "external"
    //the payable keyword allows the contract to receive Ether
    fallback() external payable {
        //note that no function code is needed here
    }

}

// inherting the functions of base contract collectEther through inheritence
contract sendEther is collectEther {
    
    collectEther cE;

    constructor() {
        cE = new collectEther();  // creating a contract instance
        console.log("Contract deployed at Address %s", address(cE));  	// will enter a log message displaying the address
    }

    function sendEtherTocE() public payable returns(bool) {

        address(cE).transfer(msg.value);
        console.log("The updated balance of the collectEther contract is"); 
        return true;

    }

    function getBalancecE() public view returns(uint256) {
        console.log("The balance is %s", address(cE).balance);
        return address(cE).balance;
    }
}
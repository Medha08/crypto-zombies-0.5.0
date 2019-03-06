pragma solidity ^0.5.0;

import "browser/ownable.sol";

contract ZombieFactory is Ownable{
    
    event NewZombie(uint id , string name, uint dna);
    
    uint dnaDigits = 16; // Zombie's DNA
    uint dnaModulus = 10 ** dnaDigits; // Zombie's DNA  can later use the modulus operator % to shorten an integer to 16 digits
    uint coolDownTime = 1 days;
    
    struct Zombie {
        string name;
        uint dna;
        uint32 level;
        uint32 readyTime;
    }
    
    Zombie[] public zombies; // store Zombie structs ie acts as database for state variables
    
    mapping(uint => address) public  zombieToOwner; // id of zombie mapped to an zombieToOwner
    mapping(address => uint) ownerZombieCount; // how many zombie an owner has

    function _createZombie(string memory _name,uint _dna) internal{ // first private only functions within the contract can call this ; internal cause ZombieFeeding calls this functions
        uint id = zombies.push(Zombie(_name,_dna,1,uint32(now + coolDownTime)))-1;
        
        zombieToOwner[id] = msg.sender;
        ownerZombieCount[msg.sender]++;
        
        emit NewZombie(id,_name,_dna);
    }
    
    function _generateRandomDna(string memory  _str) private view returns(uint){
        uint rand = uint ( keccak256(abi.encodePacked( _str )));
        return rand % dnaModulus;
    }
    
    function createRandomZombie(string memory  _name)public{  //function to create a Zombie with random dna
        require(ownerZombieCount[msg.sender] == 0); // zombie owner can create only one zombie 
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name,randDna);
        
    }
}


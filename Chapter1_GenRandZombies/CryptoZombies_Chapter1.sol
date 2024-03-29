pragma solidity ^0.5.0;

contract ZombieFactory{
    
    event NewZombie(uint id , string name, uint dna);
    
    uint dnaDigits = 16; // Zombie's DNA
    uint dnaModulus = 10 ** dnaDigits; // Zombie's DNA  can later use the modulus operator % to shorten an integer to 16 digits
    
    struct Zombie {
        string name;
        uint dna;
    }
    
    Zombie[] public zombies; // store Zombie structs ie acts as database for state variables

    function _createZombie(string memory _name,uint _dna) private{ // only functions within the contract can call this
        uint id = zombies.push(Zombie(_name,_dna))-1;
        emit NewZombie(id,_name,_dna);
    }
    
    function _generateRandomDna(string memory  _str) private view returns(uint){
        uint rand = uint ( keccak256(abi.encodePacked( _str )));
        return rand % dnaModulus;
    }
    
    function createRandomZombie(string memory  _name)public{  //function to create a Zombie with random dna
        
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name,randDna);
        
    }
}
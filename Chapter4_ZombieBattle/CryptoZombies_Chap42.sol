pragma solidity ^0.5.0;

import "./CrytpZombies_Chap41.sol";

contract ZombieHelper is ZombieFeeding{
    
    uint levelUpFee = 0.01 ether;
    
    modifier aboveLevel(uint _level,uint _zombieId){
        require(zombies[_zombieId].level >= _level);
        _;
    }
    
    function levelUp(uint _zombieId)external payable{
        require(msg.value == levelUpFee);
        zombies[_zombieId].level++;
    }
    
   function changeName(uint _zombieId , string calldata _newName) external aboveLevel(2,_zombieId) ownerOf(_zombieId) {
        zombies[_zombieId].name = _newName;
    }
    
    function changeDna(uint _zombieId , uint _newDna) external aboveLevel(20,_zombieId) ownerOf(_zombieId) {
        zombies[_zombieId].dna = _newDna;
    }
    
    
    function withdraw() external onlyOwner {
        address payable _owner = address(uint160(owner)); // converting non payable addr to payable
         _owner.transfer(address(this).balance);
    }
    function setLevelUpfee(uint _fee) external onlyOwner{
        levelUpFee = _fee;
    } 
    
  function getZombiesByOwner(address _owner) external view returns(uint[] memory) {
    uint[] memory result = new uint[](ownerZombieCount[_owner]);
    uint counter = 0;
    for(uint i = 0; i < zombies.length;i++){
      if(zombieToOwner[i] == _owner)
        {
          result[counter] = i;
          counter++;
        }
      }
    return result;
  }
 
}

/*Note: memory arrays must be created with a length argument (in this example, 3). They currently cannot be resized like storage arrays can with array.push(), although this may be changed in a future version of Solidity
*/
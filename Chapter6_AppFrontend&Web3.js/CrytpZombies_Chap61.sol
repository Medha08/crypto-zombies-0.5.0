pragma solidity ^0.5.0;

import "./CryptoZombies_Chap6.sol";
contract KittyInterface{
  function getKitty(uint256 _id) external view returns (
    bool isGestating,
    bool isReady,
    uint256 cooldownIndex,
    uint256 nextActionAt,
    uint256 siringWithId,
    uint256 birthTime,
    uint256 matronId,
    uint256 sireId,
    uint256 generation,
    uint256 genes
  );
}

contract ZombieFeeding is ZombieFactory{
    
   
    KittyInterface kittyContract;
    
     modifier onlyOwnerOf(uint _zombieId){
        require(zombieToOwner[_zombieId] == msg.sender);
        _;
    }
    
    function setKittyContractAddress(address _address) external onlyOwner {
        kittyContract = KittyInterface(_address);
    }
    
    function feedAndMultiply(uint _zombieId, uint _targetDna, string memory _species) internal onlyOwnerOf( _zombieId) {
        
        Zombie storage myZombie = zombies[_zombieId];
        require(_isReady(myZombie));
        
        _targetDna = _targetDna % dnaModulus;
         uint newDna = (myZombie.dna + _targetDna) / 2;
         if(keccak256(abi.encodePacked(_species)) == keccak256(abi.encodePacked("kitty"))){
             newDna = newDna - newDna % 100 + 99; //Assume newDna is 334455. Then newDna % 100 is 55, so newDna - newDna % 100 is 334400. Finally add 99 to get 334499.
         }
         
         _createZombie("NoName",newDna);
         _triggerCooldown(myZombie);
         
          
        
    }
    
    function _triggerCooldown(Zombie storage _zombie) internal  {
        _zombie.readyTime = uint32(now + coolDownTime);
    }
    
    function _isReady(Zombie storage _zombie) internal view returns(bool){
        return (_zombie.readyTime <= now);
         
    }
    
    function feedOnKitty(uint _kittyId,uint _zombieId)public{
        uint kittyDna;
        ( , , , , , , , , , kittyDna) = kittyContract.getKitty(_kittyId);
        
        feedAndMultiply(_zombieId,kittyDna,"kitty");
        
    }
/* This is how you do multiple assignment:
            (a, b, c) = multipleReturns();
             // We can just leave the other fields blank:
            (,,c) = multipleReturns();
            */
    
}

pragma solidity ^0.4.17;

contract Person{
    
    
    address owner;
    
    function Person() public{
        owner = msg.sender;
    }
    
    function kill(){
        if(msg.sender == owner) selfdestruct(owner);
    }
    
}

contract Greeter is Person{
    
    string greeting;
    
    function Greeter(string _greeting) public{
      greeting = _greeting;  
    }
    
    function greet() constant returns(string){
        return greeting;
    }
}
pragma solidity ^0.4.17;

contract Inbox{ //class
    
    string public message;
    
    function Inbox(string InitialMessage) public{
        
        message = InitialMessage;
        
    }
    
    function setMessage(string newMessage) public{ //setter 
        
        message = newMessage;
        
    }
    
    function getMessage() public view returns(string){  //read only, no expense for viewing
        return message;
    }
    
    function doMath(int a, int b){
        a+b;
        b-a;
        a*b;
        a=0;
    }
    
}
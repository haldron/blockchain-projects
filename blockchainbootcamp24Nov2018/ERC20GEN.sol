//Credits to the bitfwd community for providing this tutorial 
//https://github.com/bitfwdcommunity/Issue-your-own-ERC20-token/blob/master/contracts/erc20_tutorial.sol 

pragma solidity ^0.4.24;

// ----------------------------------------------------------------------------
// 'AdelBlock' token contract
//
// Deployed to : 0xF1Eca3e3A663A51c4C1f6D18595eFB0959a98d0F
// Symbol      : ADLBLK
// Name        : Adelaide Blockchain Token
// Total supply: 1000
// Decimals    : 18
// ----------------------------------------------------------------------------


// ----------------------------------------------------------------------------
// Safe maths
// ----------------------------------------------------------------------------
contract SafeMath {
    function safeAdd(uint a, uint b) public pure returns (uint c) {
        c = a + b;
        require(c >= a);
    }
    function safeSub(uint a, uint b) public pure returns (uint c) {
        require(b <= a);
        c = a - b;
    }
    function safeMul(uint a, uint b) public pure returns (uint c) {
        c = a * b;
        require(a == 0 || c / a == b);
    }
    function safeDiv(uint a, uint b) public pure returns (uint c) {
        require(b > 0);
        c = a / b;
    }
}


// ----------------------------------------------------------------------------
// ERC20Interface
// ----------------------------------------------------------------------------
contract ERC20Interface {

    function totalSupply() public constant returns (uint);
    function balanceOf(address tokenOwner) public constant returns (uint balance);
    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
    function transfer(address to, uint tokens) public returns (bool success);
    function approve(address spender, uint tokens) public returns (bool success);
    function transferFrom(address from, address to, uint tokens) public returns (bool success);
    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}



// ----------------------------------------------------------------------------
// ApproveAndCallFallBack
// ----------------------------------------------------------------------------
contract ApproveAndCallFallBack {
    function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
}



// ----------------------------------------------------------------------------
// Owned
// ----------------------------------------------------------------------------
contract Owned {
    address public owner;
    address public newOwner;

    event OwnershipTransferred(address indexed _from, address indexed _to);

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function transferOwnership(address _newOwner) public onlyOwner {
        newOwner = _newOwner;
    }
    function acceptOwnership() public {
        require(msg.sender == newOwner);
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
        newOwner = address(0);
    }
}


// ----------------------------------------------------------------------------
// Your Token contract
// ----------------------------------------------------------------------------
contract KARToken is ERC20Interface, Owned, SafeMath {    //Replace contract name with your own!
    string public symbol;
    string public  name;
    uint8 public decimals;
    uint public _totalSupply;

    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;



// ----------------------------------------------------------------------------
// constructor
// ----------------------------------------------------------------------------
    constructor() public {
        symbol = "KARBLK";                       //Replace with your Symbol!
        name = "Karan's Testing Token";      //Replace with your Token name!
        decimals = 18;                           //Replace with how many decimals you want your token to have!
        _totalSupply = 1000000000000000000000;   //Total supply, follow by decimal number of 0's (i.e. this one is for 1000 tokens)
        balances[0xF1Eca3e3A663A51c4C1f6D18595eFB0959a98d0F] = _totalSupply;    //Change to your ETH wallet address
        emit Transfer(address(0), 0xF1Eca3e3A663A51c4C1f6D18595eFB0959a98d0F, _totalSupply);   //Change to your ETH wallet address
    }



    function totalSupply() public constant returns (uint) {
        return _totalSupply  - balances[address(0)];
    }




    function balanceOf(address tokenOwner) public constant returns (uint balance) {
        return balances[tokenOwner];
    }



    function transfer(address to, uint tokens) public returns (bool success) {
        balances[msg.sender] = safeSub(balances[msg.sender], tokens);
        balances[to] = safeAdd(balances[to], tokens);
        emit Transfer(msg.sender, to, tokens);
        return true;
    }




    function approve(address spender, uint tokens) public returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }




    function transferFrom(address from, address to, uint tokens) public returns (bool success) {
        balances[from] = safeSub(balances[from], tokens);
        allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
        balances[to] = safeAdd(balances[to], tokens);
        emit Transfer(from, to, tokens);
        return true;
    }



    function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
        return allowed[tokenOwner][spender];
    }



    function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
        return true;
    }



    function () public payable {
        revert();
    }


  
    function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
        return ERC20Interface(tokenAddress).transfer(owner, tokens);
    }
}
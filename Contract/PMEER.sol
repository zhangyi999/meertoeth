pragma solidity ^0.5.16;

import './SafeMath.sol';

contract Owned {

    address public owner;

    modifier only(address _allowed) {
        require(msg.sender == _allowed);
        _;
    }

    function transferOwnership(address _newOwner) only(owner) public {
        owner = _newOwner;
    }

    event OwnershipTransferred(address indexed _from, address indexed _to);

}

interface EIP20Interface {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);
    event PToE(address indexed user, bytes20 indexed meerPubKey, uint value);
    event EToP(address indexed user, bytes20 indexed meerPubKey, uint value);

    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);
    function pToE(address to, uint amount, bytes20 meerPubKey) external returns(bool);
    function eToP(bytes20 meerPubKey, uint amount ) external returns(bool);
}

contract PMEER is Owned, EIP20Interface {
    using SafeMath for uint;

    mapping (address => uint) balances;
    mapping (address => mapping (address => uint)) allowed;
    string public constant name = "PMEER";
    string public constant symbol="PMEER";
    uint8 public constant decimals= 8;
    uint public totalSupply=0;

    event Transfer(address indexed _from, address indexed _to, uint _value);
    event Approval(address indexed _owner, address indexed _spender, uint _value);
    event PToE(address indexed user, bytes20 indexed meerPubKey, uint value);
    event EToP(address indexed user, bytes20 indexed meerPubKey, uint value);
    
    constructor (address _owner) public {
        owner = _owner;
    }


    function transfer(address _to, uint _value) public returns (bool success) {
        require(_to != address(0));
        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
        emit Transfer(msg.sender, _to, _value);
        return true;
    }
    
    function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
        require(_to != address(0));
        balances[_from] = balances[_from].sub(_value);
        balances[_to] = balances[_to].add(_value);
        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
        emit Transfer(_from, _to, _value);
        return true;
    }

    function balanceOf(address _owner) public view returns (uint balance) {
        return balances[_owner];
    }
    
    function approve(address _spender, uint _value) public returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) public view returns (uint remaining) {
        return allowed[_owner][_spender];
    }

    function pToE(address _to, uint _amount, bytes20 _meerPubKey) public only(owner) returns(bool) {
        require(_amount > 0);
        require(_to != address(0));
        totalSupply = totalSupply.add(_amount);
        balances[_to] = balances[_to].add(_amount);
        emit PToE(_to, _meerPubKey, _amount);
        emit Transfer(address(this), _to, _amount);
        return true;
    }
    
    function eToP(bytes20 _meerPubKey, uint _amount ) public returns(bool) {
        require(_amount > 0);
        balances[msg.sender] = balances[msg.sender].sub(_amount);
        totalSupply = totalSupply.sub(_amount);
        emit EToP(msg.sender, _meerPubKey, _amount);
        emit Transfer(msg.sender, address(0), _amount);
        return true;
    }
}

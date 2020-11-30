pragma solidity ^0.6.10;

import './SafeMath.sol';

contract Owned {

    address public owner;

    modifier only(address _allowed) {
        require(msg.sender == _allowed);
        _;
    }

    constructor () public {
        owner = msg.sender;
    }

    function transferOwnership(address _newOwner) only(owner) public {
        owner = _newOwner;
    }

    event OwnershipTransferred(address indexed _from, address indexed _to);

}

contract Token is Owned {
    using SafeMath for uint;

    mapping (address => uint) balances;
    mapping (address => mapping (address => uint)) allowed;
    string public name = "tQitmeer";
    string public symbol="tPMEER";
    uint8 public decimals= 8;
    uint public totalSupply=0;

    event Transfer(address indexed _from, address indexed _to, uint _value);
    event Approval(address indexed _owner, address indexed _spender, uint _value);
    event PToE(address indexed user, bytes20 indexed meerPubKey, uint value);
    event EToP(address indexed user, bytes20 indexed meerPubKey, uint value);

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

    function approve_fixed(address _spender, uint _currentValue, uint _value) public returns (bool success) {
        if(allowed[msg.sender][_spender] == _currentValue){
            allowed[msg.sender][_spender] = _value;
            emit Approval(msg.sender, _spender, _value);
            return true;
        } else {
            return false;
        }
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
        totalSupply = totalSupply.add(_amount);
        balances[_to] = balances[_to].add(_amount);
        emit PToE(_to, _meerPubKey, _amount);
        return true;
    }
    
    function eToP(bytes20 _meerPubKey, uint _amount ) public returns(bool) {
        totalSupply = totalSupply.sub(_amount);
        balances[msg.sender] = balances[msg.sender].sub(_amount);
        emit EToP(msg.sender, _meerPubKey, _amount);
        return true;
    }
}

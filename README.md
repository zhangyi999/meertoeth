# PMEER 兑换 EMEER 合约

合约有标准的 `ERC20` 接口，可以正常转账。

## 创建

创建合约时修改 `name` 和 `symbol` 

```js
string public name = "eQitmeer";
string public symbol="ePMEER";
```

## 合约地址

Ropsten 网络：0x9c247a044Cb4973588931c3fBE80C66067E9A2b2

## PMEER 兑换 EMEER 方法

```js
/**
 * _to: 兑换者 emeer 接收地址
 * _meerPubKey: 兑换者 pmeer checkBaes58
 * _amount: 数量
 */
pToE(address _to, uint _amount, bytes20 memory _meerPubKey) only(owner)

// 兑换成功后事件通知
emit PToE(address indexed user, bytes20 indexed meerAddress, uint value);
```

## EMEER 兑换 PMEER 方法

```js
/**
 * _to: 兑换者 emeer 接收地址
 * _meerPubKey: 兑换者 pmeer checkBaes58
 * _amount: 数量
 */
eToP(bytes20 memory _meerPubKey, uint _amount )

// 兑换成功后事件通知
emit EToP(address indexed user, bytes20 indexed meerAddress, uint value);
```

## 兑换总量

```js
totalSupply() returns(uint256)
```

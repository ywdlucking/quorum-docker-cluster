# 使用quorum完成一个小只能合约例子

标签（空格分隔）： quorum

---

准备
--

 1. 智能合约

    pragma solidity ^0.4.17;
    
    contract Migrations {
      address public owner;
      uint public last_completed_migration;
    
      modifier restricted() {
        if (msg.sender == owner) _;
      }
    
      function Migrations() public {
        owner = msg.sender;
      }
    
      function setCompleted(uint completed) public restricted {
        last_completed_migration = completed;
      }
    
      function upgrade(address new_address) public restricted {
        Migrations upgraded = Migrations(new_address);
        upgraded.setCompleted(last_completed_migration);
      }
    }

假设有三个节点node1, node2, node3
node1: 
pubkey:BULeR8JyUWhiuuCMU/HLA0Q5pzkYT+cHII3ZKBey3Bo=

node2:
pubkey:QfeDAys9MPDs2XHExtc84jKGHxZg/aj52DTh0vtA3Xc=

node3:
pubkey:1iTZde/ndBHvzhcl7V68x44Vx7pl8nwx9LqnM/AfJUg=

操作
--

 1. Truffle 部署智能合约,部署一个私有合约：
   
        var SimpleStorage = artifacts.require("./SimpleStorage.sol");
    
        module.exports = function(deployer) {
          deployer.deploy(SimpleStorage,  42, {privateFor:["BULeR8JyUWhiuuCMU/HLA0Q5pzkYT+cHII3ZKBey3Bo="]});
        };
    只有node2可以看见
    获取部署的地址： 0x9d13c6d3afe1721beef56b55d303b09e021e27ab
    执行测试数据
    private.set(14,{from:eth.coinbase,privateFor:["QfeDAys9MPDs2XHExtc84jKGHxZg/aj52DTh0vtA3Xc="]});

 2. 在节点打开控制台`geth attach ipc:/etc/quorum/geth.ipc`
 3. 在node1,node2，node3执行

     var abi = [{"constant":true,"inputs":[],"name":"storedData","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"x","type":"uint256"}],"name":"set","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"get","outputs":[{"name":"retVal","type":"uint256"}],"payable":false,"type":"function"},{"inputs":[{"name":"initVal","type":"uint256"}],"payable":false,"type":"constructor"}];
    var private = eth.contract(abi).at("0x9d13c6d3afe1721beef56b55d303b09e021e27ab");
    private.get();


node1 result: 14
node2 result: 14
node3 result: 0

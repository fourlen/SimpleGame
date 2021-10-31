

pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import "GameObject.sol";

contract BaseStation is GameObject {

    uint private hp = 100;
    uint private ap;
    GameObject[] public units;
    // mapping(address => GameObject) public units;
    // address[] public unitsAddresses;

    constructor() public {
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
    }


    function takeArmour(uint armour) override virtual public Accept {
        if (ap + armour > 100) {
            ap = 100;
        } 
        else {
            ap += armour;
        }
    }


    function takeDamage(uint damage) external override Accept {
        if (damage > ap) {
            hp -= damage - ap;
        }
        else {
            ap -= damage;
        }
        if (!checkIsAlive()) {
            sendAllMoneyAndDestroy(msg.sender);
        }
    }


    function addUnit(GameObject unit) public Accept {
        units.push(unit);
    }


    function delUnit(address unit) public Accept {
        for (uint k = 0; k + 1 < units.length; ++k) {
            units[k] = units[k + 1];
        }
        units.pop();
    }


    function sendAllMoneyAndDestroy(address killer) public override Accept {
        for (uint i = 0; i < units.length; i++) {
            units[i].sendAllMoneyAndDestroy(killer);
        }
        killer.transfer(1, true, 160);
    }


    function checkIsAlive() virtual override public view Accept returns(bool) {
        if (hp <= 0) {
            return false;
        }
        else {
            return true;
        }
    }
}
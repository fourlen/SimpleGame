

pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import "GameObject.sol";
import "BaseStation.sol";

abstract contract Unit is GameObject{

    uint private damage;
    uint private hp = 100;
    uint private ap;

    BaseStation private base;
    address private baseAddress = address(base);

    


    function attack(GameObjectInterface enemy) virtual public Accept {
        require(enemy != base, 101);
        enemy.takeDamage(damage);
    }


    function getAttackPower(uint attackPower) virtual public Accept {
        damage += attackPower;
    }


    function sendAllMoneyAndDestroy(address killer) virtual public Accept override {
        base.delUnit(msg.sender);
        killer.transfer(1, true, 160);
    }


    function takeArmour(uint armour) virtual override public Accept {
        if (ap + armour > 100) {
            ap = 100;
        } 
        else {
            ap += armour;
        }
    }


    function takeDamage(uint _damage) virtual external override Accept {
        if (_damage > ap) {
            hp -= damage - ap;
        }
        else {
            ap -= _damage;
        }
        if (!checkIsAlive()) {
            sendAllMoneyAndDestroy(msg.sender);
        }
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
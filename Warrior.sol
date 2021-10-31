

pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import "Unit.sol";


contract Warrior is Unit {
    
    uint private damage = 5;
    uint private hp = 10;
    uint private ap;

    BaseStation private base;
    address private baseAddress = address(base);

    constructor(BaseStation _base) public {
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
        base = _base;
        base.addUnit(this);
    }


    function attack(GameObjectInterface enemy) override virtual public Accept {
        require(enemy != base, 101);
        enemy.takeDamage(damage);
    }


    function getAttackPower(uint attackPower) override virtual public Accept {
        damage += attackPower;
    }


    function sendAllMoneyAndDestroy(address killer) override virtual public Accept {
        base.delUnit(msg.sender);
        killer.transfer(1, true, 160);
    }


    function takeArmour(uint armour) virtual override public Accept {
        if (ap + armour > 10) {
            ap = 10;
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
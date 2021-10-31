
pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import "GameObjectInterface.sol";

abstract contract GameObject is GameObjectInterface{

    uint private hp;
    uint private ap;

    constructor() public {
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
    }


    modifier Accept {
		tvm.accept();
		_;
	}


    function takeArmour(uint armour) virtual public Accept {
        if (ap + armour > 100) {
            ap = 100;
        } 
        else {
            ap += armour;
        }
    }


    function takeDamage(uint damage) virtual external override Accept {
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


    function checkIsAlive() virtual public view Accept returns(bool) {
        if (hp <= 0) {
            return false;
        }
        else {
            return true;
        }
    }


    function sendAllMoneyAndDestroy(address killer) virtual public Accept {
        killer.transfer(1, true, 160);
    }
}
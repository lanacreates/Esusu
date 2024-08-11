// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DecentralizedSavings {
    struct Savings {
        uint id;
        string name;
        uint startDate;
        uint endDate;
        string description;
        string savingsType; // Weekly, Monthly, etc.
        address[] members;
        mapping(address => uint[]) deductionHistory; // Keeps track of all deductions made from each member
    }

    struct SavingsInfo {
        uint id;
        string name;
        uint startDate;
        uint endDate;
        string description;
        string savingsType; // Weekly, Monthly, etc.
        address[] members;
    }

    mapping(uint => Savings) public savings;
    mapping(address => uint[]) public userSavings; // Tracks savings IDs for each user
    uint public savingsCount;
    
    event SavingsCreated(uint id, string name, string savingsType, address creator);
    event SavingsJoined(uint id, address member);
    event SavingsLeft(uint id, address member);
    event DeductionMade(uint id, address member, uint amount, uint timestamp);

    function createSavings(
        string memory _name, 
        uint _startDate, 
        uint _endDate, 
        string memory _description, 
        string memory _savingsType
    ) public {
        require(_startDate < _endDate, "Start date must be before end date");

        savingsCount++;
        Savings storage newSavings = savings[savingsCount];
        newSavings.id = savingsCount;
        newSavings.name = _name;
        newSavings.startDate = _startDate;
        newSavings.endDate = _endDate;
        newSavings.description = _description;
        newSavings.savingsType = _savingsType;
        newSavings.members.push(msg.sender);
        userSavings[msg.sender].push(savingsCount);

        emit SavingsCreated(savingsCount, _name, _savingsType, msg.sender);
    }

    function getAllSavings() public view returns (SavingsInfo[] memory) {
        SavingsInfo[] memory allSavings = new SavingsInfo[](savingsCount);
        for (uint i = 1; i <= savingsCount; i++) {
            Savings storage s = savings[i];
            allSavings[i - 1] = SavingsInfo(s.id, s.name, s.startDate, s.endDate, s.description, s.savingsType, s.members);
        }
        return allSavings;
    }

    function joinSavings(uint _savingsId) public {
        require(_savingsId > 0 && _savingsId <= savingsCount, "Invalid savings ID");
        Savings storage s = savings[_savingsId];
        s.members.push(msg.sender);
        userSavings[msg.sender].push(_savingsId);

        emit SavingsJoined(_savingsId, msg.sender);
    }

    function leaveSavings(uint _savingsId) public {
        require(_savingsId > 0 && _savingsId <= savingsCount, "Invalid savings ID");
        Savings storage s = savings[_savingsId];
        require(isMember(_savingsId, msg.sender), "You are not a member of this savings");

        // Remove user from members array
        for (uint i = 0; i < s.members.length; i++) {
            if (s.members[i] == msg.sender) {
                s.members[i] = s.members[s.members.length - 1];
                s.members.pop();
                break;
            }
        }

        // Remove savings from user's list
        uint[] storage userSavingsList = userSavings[msg.sender];
        for (uint i = 0; i < userSavingsList.length; i++) {
            if (userSavingsList[i] == _savingsId) {
                userSavingsList[i] = userSavingsList[userSavingsList.length - 1];
                userSavingsList.pop();
                break;
            }
        }

        emit SavingsLeft(_savingsId, msg.sender);
    }

    function getUserSavings(address _user) public view returns (SavingsInfo[] memory) {
        uint[] memory userSavingsIds = userSavings[_user];
        SavingsInfo[] memory userSavingsList = new SavingsInfo[](userSavingsIds.length);
        for (uint i = 0; i < userSavingsIds.length; i++) {
            Savings storage s = savings[userSavingsIds[i]];
            userSavingsList[i] = SavingsInfo(s.id, s.name, s.startDate, s.endDate, s.description, s.savingsType, s.members);
        }
        return userSavingsList;
    }

    function isMember(uint _savingsId, address _user) internal view returns (bool) {
        Savings storage s = savings[_savingsId];
        for (uint i = 0; i < s.members.length; i++) {
            if (s.members[i] == _user) {
                return true;
            }
        }
        return false;
    }

    function makeDeduction(uint _savingsId, uint _amount) public {
        require(isMember(_savingsId, msg.sender), "You are not a member of this savings");
        // Deduct the specified amount from the user's MiniPay wallet (this requires integration with MiniPay API)
        // MiniPay deduction code here

        savings[_savingsId].deductionHistory[msg.sender].push(block.timestamp);
        emit DeductionMade(_savingsId, msg.sender, _amount, block.timestamp);
    }

    function getDeductionHistory(uint _savingsId, address _user) public view returns (uint[] memory) {
        require(isMember(_savingsId, _user), "User is not a member of this savings");
        return savings[_savingsId].deductionHistory[_user];
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Chat {
    struct Message {
        address sender;
        uint256 content;
    }

    address private immutable user1;
    address private immutable user2;
    Message[] private chatRecord;

    constructor(address _address) {
        user1 = msg.sender;
        user2 = _address;
    }

    function sendMessage(uint256 _content) public {
        require(checkUser(), "Unauthorized access attempt, request denied");
        chatRecord.push(Message(msg.sender, _content));
    }

    function getMessage() public view returns (Message[] memory) {
        require(checkUser(), "Unauthorized access attempt, request denied");
        return chatRecord;
    }

    function checkUser() public view returns (bool) {
        if (msg.sender == user1 || msg.sender == user2) {
            return true;
        }
        return false;
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "./UserCollection.sol";
import "./Post.sol";
import "./Chat.sol";

contract User {
    // Master User Collection Address
    address public masterCollectionAddress =
        0xd9145CCE52D386f254917e481eB44e9943F39138;

    // Basic User Data
    uint256 public immutable userName;
    address public immutable userAddress;
    address private immutable contractOwner;

    // User Following Data
    uint256[] private followingNameArray;
    address[] private followingAddressArray;

    // User Follower Data
    uint256[] private followerNameArray;
    address[] private followerAddressArray;

    // User Posts
    address[] public postList;

    // User Chats
    address[] public chatList;

    // Initializing the Username and Address
    constructor(uint256 _username) {
        userName = _username;
        userAddress = msg.sender;
        contractOwner = address(this);

        UserCollection masterCollection = UserCollection(
            0x5FD6eB55D12E759a21C09eF703fe0CBa1DC9d88D
        );
        masterCollection.addUser(userAddress);
    }

    // Post content
    function post(uint256 _content) public {
        Post posted = new Post(_content, userAddress, userName);
        postList.push(address(posted));
    }

    // Start Chat
    function chat(address _address) public {
        Chat dm = new Chat(_address);
        chatList.push(address(dm));
    }

    // Helper Function to Send Username (Optimization Feature)
    function sendUsername() external view returns (uint256) {
        return userName;
    }

    // Helper Function to Get Followed (Security Feature)
    function getFollowed(uint256 _username) external {
        followerNameArray.push(_username);
        followerAddressArray.push(msg.sender);
    }

    // Follow Another User
    function follow(address _address) public {
        require(
            msg.sender == userAddress,
            "Unauthorized access attempt, request denied"
        ); // Only the account owner can follow (Security Feature)
        require(
            !isAlreadyFollowed(_address),
            "Sorry, you are already following this user"
        ); // Followig status check (Optimization Feature)
        User toBeFollowed = User(_address); // The user to be followed
        toBeFollowed.getFollowed(userName);

        followingNameArray.push(toBeFollowed.sendUsername());
        followingAddressArray.push(_address);
    }

    // Check if Alreaedy Followed
    function isAlreadyFollowed(address _address) private view returns (bool) {
        bool status = false;
        for (uint256 i = 0; i < followingAddressArray.length; i++) {
            if (followingAddressArray[i] == _address) {
                status = true;
                break;
            }
        }
        return status;
    }

    // Check User Following
    function getFollowing()
        public
        view
        returns (uint256[] memory, address[] memory)
    {
        return (followingNameArray, followingAddressArray);
    }

    // Check User Followers
    function getFollowers()
        public
        view
        returns (uint256[] memory, address[] memory)
    {
        return (followerNameArray, followerAddressArray);
    }

    // Get Follower Count
    function getFollowerCount() public view returns (uint256) {
        return followerAddressArray.length;
    }

    // Get Following Count
    function getFollowingCount() public view returns (uint256) {
        return followingAddressArray.length;
    }
}

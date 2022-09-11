// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "./User.sol";

contract Post {
    uint256 public immutable content;
    uint256 public immutable userName;
    address public immutable userAddress;
    uint256 public likes;
    address[] private likesAddressList;
    mapping(address => uint256) public addressToLikeStatus;

    constructor(
        uint256 _content,
        address _address,
        uint256 _userName
    ) {
        content = _content;
        userName = _userName;
        userAddress = _address;
    }

    // Like and Unlike Posts
    function likeUnlike(address _address) public {
        if (likeUnlikeCheck(_address)) {
            if (addressToLikeStatus[_address] == 0) {
                addressToLikeStatus[_address] = 1;
                likes += 1;
            } else {
                addressToLikeStatus[_address] = 0;
                likes -= 1;
            }
        } else {
            likesAddressList.push(_address);
            addressToLikeStatus[_address] = 1;
            likes += 1;
        }
    }

    // Check if the User has Liked the post before
    function likeUnlikeCheck(address _address) private view returns (bool) {
        bool status = false;
        for (uint256 i = 0; i < likesAddressList.length; i++) {
            if (likesAddressList[i] == _address) {
                status = true;
                break;
            }
        }
        return status;
    }

    function getArray() public view returns (address[] memory) {
        return likesAddressList;
    }
}

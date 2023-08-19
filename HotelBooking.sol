// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract HotelBooking {
    string public hotelName = "Maurya Hotel";
    uint public totalRooms = 5;
    address payable owner;
    uint public roomAvailable = 5;

    struct Room {
        uint256 roomNo;
        string category;
        uint256 price;
        string guestName;
        bool available;
    }
    Room[] public rooms;

    constructor() {
        owner = payable(msg.sender);

        rooms.push(Room(0, "Single", 2, "None", true));
        rooms.push(Room(1, "Single", 2, "None", true));
        rooms.push(Room(2, "Single", 2, "None", true));
        rooms.push(Room(3, "Deluxe", 5, "None", true));
        rooms.push(Room(4, "Deluxe", 5, "None", true));
    }

    function bookRoom(uint256 roomNo, string memory _guestName) public payable {
        require(rooms[roomNo].available, "Room is not available");
        
        rooms[roomNo].available = false;
        uint price = rooms[roomNo].price;
        rooms[roomNo].guestName = _guestName;

        require(msg.value == price * 10**18, "Ether is not enough");
        roomAvailable -= 1;
    }


    function checkOut(uint256 roomNo) public {
        require(rooms[roomNo].available == false, "Room is already checked out");
        rooms[roomNo].available = true;
        rooms[roomNo].guestName = "None";
        roomAvailable += 1;
    }

    // function for withdrawing money from smartcontract
    // only owner can run this function
    function transferMoney(uint amount) public {
        require(msg.sender == owner, "You are not allowed");
        uint balance = address(this).balance;
        require(amount * 10**18 <= balance, "This much amount is not present in contract");

        owner.transfer(amount * 10**18);
    }

}
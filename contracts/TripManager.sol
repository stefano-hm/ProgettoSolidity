// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./TripLibrary.sol";

contract TripManager {
    using TripLibrary for TripLibrary.Trip[];

    TripLibrary.Trip[] private trips;

    mapping(address => uint256) public clientBalances;
    mapping(address => uint256) public providerBalances;
    mapping(uint256 => address) public tripToClient;
    mapping(uint256 => bool) public tripCompleted;

    event TripAdded(
        uint256 indexed tripId,
        string name,
        string location,
        uint256 startDate,
        uint256 endDate,
        uint256 price,
        address indexed provider
    );

    event TripBooked(address indexed client, uint256 indexed tripId);
    event TripCancelled(uint256 indexed tripId, address indexed client, uint256 amount);
    event TripCompleted(uint256 indexed tripId, address indexed client, address indexed provider, uint256 amount);
    event FundsWithdrawn(address indexed provider, uint256 amount);

    function addTrip(
        string memory name,
        string memory location,
        uint256 startDate,
        uint256 endDate,
        uint256 price
    ) public {
        trips.addNewTrip(name, location, startDate, endDate, price, payable(msg.sender));
        uint256 tripId = trips.length - 1;

        emit TripAdded(tripId, name, location, startDate, endDate, price, msg.sender);
    }

    function bookTrip(uint256 tripId) public payable {
        require(tripId < trips.length, "Invalid trip");
        TripLibrary.Trip storage trip = trips[tripId];

        require(block.timestamp < trip.startDate, "Trip already started");
        require(msg.value == trip.price, "Incorrect ETH amount");
        require(tripToClient[tripId] == address(0), "Already booked");

        tripToClient[tripId] = msg.sender;
        clientBalances[msg.sender] += msg.value;

        emit TripBooked(msg.sender, tripId);
    }

    function completeTrip(uint256 tripId) public {
        require(tripId < trips.length, "Invalid trip");
        TripLibrary.Trip storage trip = trips[tripId];
        require(msg.sender == trip.provider, "Only provider can complete");
        address client = tripToClient[tripId];
        require(client != address(0), "Not booked");
        require(!tripCompleted[tripId], "Already completed");

        uint256 price = trip.price;
        require(clientBalances[client] >= price, "Insufficient balance");

        clientBalances[client] -= price;
        providerBalances[msg.sender] += price;
        tripCompleted[tripId] = true;

        emit TripCompleted(tripId, client, msg.sender, price);
    }

    function cancelTrip(uint256 tripId) public {
        require(tripId < trips.length, "Invalid trip");
        require(tripToClient[tripId] == msg.sender, "Only client can cancel");
        TripLibrary.Trip storage trip = trips[tripId];
        require(block.timestamp < trip.startDate, "Trip already started");

        uint256 amount = trip.price;

        payable(msg.sender).transfer(amount);

        clientBalances[msg.sender] -= amount;
        tripToClient[tripId] = address(0);

        emit TripCancelled(tripId, msg.sender, amount);
    }

    function withdraw() public {
        uint256 amount = providerBalances[msg.sender];
        require(amount > 0, "No funds available");

        providerBalances[msg.sender] = 0;
        payable(msg.sender).transfer(amount);

        emit FundsWithdrawn(msg.sender, amount);
    }

    function getAllTrips() public view returns (TripLibrary.Trip[] memory) {
        return trips.getAllTrips();
    }
}

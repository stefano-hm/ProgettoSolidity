// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

library TripLibrary {
    struct Trip {
        string name;
        string location;
        uint256 startDate;
        uint256 endDate;
        uint256 price;
        address payable provider;
    }

    function addNewTrip(
        Trip[] storage trips,
        string memory name,
        string memory location,
        uint256 startDate,
        uint256 endDate,
        uint256 price,
        address payable provider
    ) public {
        require(msg.sender == provider, "Only provider can add");
        require(endDate > startDate, "Invalid dates");
        require(price > 0, "Price must be > 0");

        trips.push(Trip(name, location, startDate, endDate, price, provider));
    }

    function getAllTrips(Trip[] storage trips) public pure returns (Trip[] memory) {
        return trips;
    }
}

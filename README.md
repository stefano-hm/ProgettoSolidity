# TripManager Smart Contract

This project contains a smart contract system for managing decentralized and sustainable travel bookings. It was developed for **Orizon**, a travel agency aiming to eliminate middlemen, reduce platform fees, and enable direct interaction between travelers and service providers.

## 🧠 Project Overview

The platform allows providers to register trips and clients to book them directly on-chain. Funds are securely held in the smart contract until the trip is completed, with cancellation and withdrawal functionalities included.

## 📁 Project Structure

contracts/
├── TripManager.sol # Main smart contract handling trips and payments
└── TripLibrary.sol # External library defining trip structure and logic


## ⚙️ Features

- Add and list travel offers (name, location, dates, price, provider)
- Book trips directly by sending ETH
- Lock client payments until trip completion
- Cancel bookings (if done before start date) with full refund
- Transfer funds to provider upon trip completion
- Withdraw available provider funds
- Transparent client and provider balances

## 🔐 Security Notes

- Funds are held within the contract and only released under strict conditions
- Only the trip provider can finalize a trip to receive funds
- Only the client who booked can cancel their trip before it begins

## 🧪 How to Use

### 1. Deploy the Contracts

- Use [Remix IDE](https://remix.ethereum.org/)
- Compile `TripLibrary.sol` first
- Then compile and deploy `TripManager.sol`

### 2. Add a Trip (as provider)

```solidity
addTrip("Eco Tour", "Iceland", 1735689600, 1736112000, 2 ether);

### 3. Book a Trip (as client)

bookTrip(tripId)  // send exactly the amount of ETH as the trip price

### 4. Complete Trip (as provider)

completeTrip(tripId);

### 5. Cancel a Trip (as client, before start date)

### 6. Withdraw Funds (as provider)

withdraw();

## 📜 Requirements
Solidity ^0.8.17

Tested on Remix IDE (no external dependencies)

Deployed on any compatible EVM network (e.g. Remix VM, testnet)

## 📣 Events
TripAdded(tripId, name, location, startDate, endDate, price, provider)

TripBooked(client, tripId)

TripCancelled(tripId, client, amount)

FundsWithdrawn(provider, amount)

## ✍️ Author
Developed by [Your Name]
For educational and portfolio purposes.

Feel free to fork, contribute, or get inspired for your own decentralized travel projects.


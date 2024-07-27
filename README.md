#  Lending Protocol

This document outlines the functionality and design of the Simple Lending Protocol smart contract. The contract is implemented in Solidity and provides basic features for a lending protocol, allowing users to deposit Ether, take loans, and repay loans.

# Architecture Design 
![image](https://github.com/user-attachments/assets/b830ddfc-eb60-4cba-829c-af8b62c61a4b)


## Features

### 1. Deposit Ether

- **Function**: `deposit()`
- **Description**: Allows users to deposit Ether into the contract. The deposited amount is tracked in the user's balance and the total deposits.
- **Events**: 
  - `Deposit(address indexed user, uint256 amount)`

### 2. Take Loan

- **Function**: `takeLoan(uint256 amount)`
- **Description**: Allows users to take a loan up to 50% of their deposited amount. The loan amount is subtracted from the contract's balance and added to the user's loan balance.
- **Requirements**:
  - The loan amount must be greater than 0.
  - The loan amount must not exceed 50% of the user's deposited amount.
  - The contract must have enough balance to issue the loan.
- **Events**:
  - `LoanTaken(address indexed user, uint256 amount)`

### 3. Repay Loan

- **Function**: `repayLoan()`
- **Description**: Allows users to repay their loans with interest. The repayment amount is calculated based on a fixed interest rate.
- **Requirements**:
  - The user must have an outstanding loan.
  - The repayment amount must be at least equal to the owed amount including interest.
- **Events**:
  - `LoanRepaid(address indexed user, uint256 amount)`

### 4. Withdraw Deposits

- **Function**: `withdraw(uint256 amount)`
- **Description**: Allows users to withdraw their deposited Ether. Withdrawals are only allowed if the user has no outstanding loans.
- **Requirements**:
  - The withdrawal amount must be greater than 0.
  - The user must have sufficient deposit balance.
  - The user must not have any outstanding loans.

### 5. Check Invariant

- **Function**: `checkInvariant()`
- **Description**: Verifies that the total deposits are always greater than or equal to the total loans. This function is used to ensure the contract's integrity.
- **Checks**:
  - `assert(totalDeposits >= totalLoans)`

### 6. Receive Ether

- **Function**: `receive()`
- **Description**: Special function to handle incoming Ether when no data is sent with the transaction. It calls the `deposit()` function to handle the Ether.
- **Requirements**:
  - The incoming Ether is handled as a deposit.

### 7. Fallback Function

- **Function**: `fallback()`
- **Description**: Handles unexpected calls to the contract. If Ether is sent without calling a specific function, this function reverts the transaction.
- **Requirements**:
  - The transaction is reverted with an error message: "Please use the deposit function to send Ether."

## Events

- **Deposit**: Emitted when a user deposits Ether into the contract.
  - Parameters:
    - `address indexed user`: The address of the user making the deposit.
    - `uint256 amount`: The amount of Ether deposited.

- **LoanTaken**: Emitted when a user takes a loan.
  - Parameters:
    - `address indexed user`: The address of the user taking the loan.
    - `uint256 amount`: The amount of the loan.

- **LoanRepaid**: Emitted when a user repays a loan.
  - Parameters:
    - `address indexed user`: The address of the user repaying the loan.
    - `uint256 amount`: The amount repaid.

## Usage

1. **Deposit Ether**:
   - Call the `deposit()` function and send Ether along with the transaction.
   - Example: `contract.deposit({value: ethers.utils.parseEther("1.0")})`

2. **Take a Loan**:
   - Call the `takeLoan(uint256 amount)` function with the desired loan amount.
   - Example: `contract.takeLoan(ethers.utils.parseEther("0.5"))`

3. **Repay a Loan**:
   - Call the `repayLoan()` function and send the required Ether for repayment.
   - Example: `contract.repayLoan({value: ethers.utils.parseEther("0.525")})`

4. **Withdraw Deposits**:
   - Call the `withdraw(uint256 amount)` function with the desired withdrawal amount.
   - Example: `contract.withdraw(ethers.utils.parseEther("0.5"))`

5. **Check Invariant**:
   - Call the `checkInvariant()` function to verify the contract's state.

6. **Fallback and Receive Ether**:
   - Ether sent to the contract without calling a specific function will trigger the `receive()` function if no data is sent, or the `fallback()` function otherwise.

## Security Considerations

- The contract uses `require()`, `revert()`, and `assert()` statements to ensure proper operations and security.
- Users must ensure they have no outstanding loans before withdrawing their deposits.
- The contract should have sufficient balance to handle loan requests.

## Author 
- Laxman
  

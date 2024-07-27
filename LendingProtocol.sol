// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LendingProtocol {
    mapping(address => uint256) public deposits;
    mapping(address => uint256) public loans;
    uint256 public totalDeposits;
    uint256 public totalLoans;
    uint256 public constant interestRate = 5; 


    event Deposit(address indexed user, uint256 amount);

    
    event LoanTaken(address indexed user, uint256 amount);

    event LoanRepaid(address indexed user, uint256 amount);

    
    function deposit() external payable {
        require(msg.value > 0, "Deposit amount must be greater than 0");
        
        deposits[msg.sender] += msg.value;
        totalDeposits += msg.value;
        
        emit Deposit(msg.sender, msg.value);
    }

    
    function takeLoan(uint256 amount) external {
        uint256 maxLoan = deposits[msg.sender] / 2;
        require(amount > 0, "Loan amount must be greater than 0");
        require(amount <= maxLoan, "Loan amount exceeds 50% of your deposit");

        loans[msg.sender] += amount;
        totalLoans += amount;
        
        require(address(this).balance >= amount, "Insufficient contract balance");

        payable(msg.sender).transfer(amount);
        
        emit LoanTaken(msg.sender, amount);
    }

  
    function repayLoan() external payable {
        uint256 loan = loans[msg.sender];
        require(loan > 0, "No loan to repay");

        uint256 repaymentAmount = loan + (loan * interestRate / 100);
        require(msg.value >= repaymentAmount, "Repayment amount is less than the owed amount");
        
        loans[msg.sender] = 0;
        totalLoans -= loan;
        
        // Refund excess amount if any
        if (msg.value > repaymentAmount) {
            payable(msg.sender).transfer(msg.value - repaymentAmount);
        }
        
        emit LoanRepaid(msg.sender, repaymentAmount);
    }

  
    function withdraw(uint256 amount) external {
        require(amount > 0, "Withdrawal amount must be greater than 0");
        require(deposits[msg.sender] >= amount, "Insufficient deposit balance");
        require(loans[msg.sender] == 0, "Outstanding loan must be repaid first");
        
        deposits[msg.sender] -= amount;
        totalDeposits -= amount;

        payable(msg.sender).transfer(amount);
    }

   
    function checkInvariant() external view {
        assert(totalDeposits >= totalLoans);
    }

    receive() external payable {
       revert("Please use the deposit function to send Ether");
    }

    fallback() external payable {
        revert("Please use the deposit function to send Ether");
    }
}

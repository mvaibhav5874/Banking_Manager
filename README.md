# Banking Manager

## 📌 Project Overview
The **Banking Manager** project is a backend system built using **MySQL** that simulates core banking operations. It is designed to handle account creation, transaction management, and customer details with **100% data accuracy** while supporting **real-time transaction processing**.

The system leverages **PL/SQL features such as triggers** to automate workflows (e.g., updating balances after transactions, auto-creating bank and account holder records once KYC is approved).

---

## 🛠 Tech Stack
- **Database**: MySQL  
- **Features Used**: PL/SQL, Triggers, Constraints, Auto-Increment Keys  

---

## 📂 Database Schema
The project consists of the following core tables:

### 1. `tb_account_form`
Stores initial customer application details (name, DOB, Aadhar, balance, etc.).  
- Enforces **KYC validation**  
- Requires **minimum opening balance of 1000**  
- Prevents duplicate Aadhar and mobile numbers  

### 2. `tb_bank`
Created automatically once an account is approved.  
- Holds **account type**, **opening date**, and **current balance**  

### 3. `tb_account_holder_details`
Stores approved customer personal details.  
- Name, DOB, Aadhar, and Mobile automatically inserted from `tb_account_form` after approval  

### 4. `tb_transaction_details`
Manages **debit/credit transactions** with timestamps.  
- Prevents overdrafts  
- Automatically updates account balances  

---

## ⚙️ Key Features
- **Automated KYC Approval Workflow**  
  - Once `KYC_Status = Approved`, triggers insert records into `tb_bank` and `tb_account_holder_details`.  

- **Transaction Handling**  
  - Debit/Credit transactions update balances in real time.  
  - Overdrafts are blocked with validation checks.  

- **Data Validation & Constraints**  
  - Unique Aadhar and Mobile numbers  
  - Minimum opening balance enforced  
  - Allowed account types: `Savings`, `Current`  

---

## 🚀 How to Run
1. Clone this repository:
   ```bash
   git clone https://github.com/your-username/Banking_Manager.git

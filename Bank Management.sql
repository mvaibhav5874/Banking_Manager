/*

		-----------BACKEND BANKING SYSTEM PROJECT (DATA ANALYST)--------------

		TABLES:		
			1. Account_opening_form
			   (
			   ID : PK (TO TRACK RECORDS) 

			   DATE: BY DEFAULT IT SHOULD BE THE CURRENT DATE OF ACC OPENING 

			   ACCOUNT_TYPE: (SAVINGS - DEFAULT, CURRENT) 

			   ACCOUNT_HOLDER_NAME: NAME OF ACCOUNT HOLDER 

			   DOB: DATE OF BIRTH 

			   AADHAR_NUMBER: (CANNOT BE REPEATED) - CAN HOLD MAX 12 NUMBERS 

			   MOBILE_NUMBER: CAN HOLD MAX 15 NUMBERS 

			   ACCOUNT_OPENING_BALANCE: DECIMAL DATA TYPE SHOULD BE ALLOWED ONLY - MINIMUM AMOUNT SHOULD BE 1000

			   ADDRESS: ADDRESS OF ACCOUNT HOLDER 

			   KYC_STATUS: APPROVED, PENDING (BY DEFAULT), REJECTED
			   )


			
			2. BANK
			   (
			   ACCOUNT_NUMBER: GENERATED AUTOMATICALLY AFTER KYC_STATUS IN Account_opening_form TABLE IS SET TO 'APPROVED'

			   ACCOUNT_TYPE: AUTOMATICALLY INSERTED AFTER ONLY KYC_STATUS IS APPROVED

			   ACCOUNT_OPENING_DATE: AUTOMATICALLY INSERTED AFTER ONLY KYC_STATUS IS APPROVED

			   CURRENT_BALANCE: AUTOMATICALLY INSERTED AFTER ONLY KYC_STATUS IS APPROVED + IT WILL BE UPDATED BASED UPON THE 
								TRANSACTION_DETAILS TABLE.
			   )



			3. ACCOUNT_HOLDER_DETAILS
			   (
			   ACCOUNT_NUMBER: GENERATED AUTOMATICALLY AFTER KYC_STATUS IN Account_opening_form TABLE IS 'APPROVED'

			   ACCOUNT_HOLDER_NAME: AUTOMATICALLY INSERTED FROM Account_opening_form TABLE AFTER ONLY KYC_STATUS IS APPROVED

			   DOB: AUTOMATICALLY INSERTED FROM Account_opening_form TABLE AFTER ONLY KYC_STATUS IS APPROVED 

			   AADHAR_NUMBER: AUTOMATICALLY INSERTED FROM Account_opening_form TABLE AFTER ONLY KYC_STATUS IS APPROVED 

			   MOBILE_NUMBER: AUTOMATICALLY INSERTED FROM Account_opening_form TABLE AFTER ONLY KYC_STATUS IS APPROVED
			   )

			4. TRANSACTION_DETAILS
			   (
			   ACCOUNT_NUMBER:
			   
			   PAYMENT_TYPE, 

			   TRANSACTION_AMOUNT,
			   
			   DATE_OF_TRANSACTION
			   )
*/

create database db_Bank_Management;
Use db_Bank_Management;

create table tb_account_form (
ID int auto_increment primary key,
date_ timestamp default current_timestamp(),
Account_Type char(10) default "Savings",
Account_Holder_Name varchar(30) not null,
DOB date,
Aadhar_Number char(12) Unique Not Null,
Mobile_Number char(10) Unique Not null,
Account_Opening_Balance decimal,
Address_of_Account_holder varchar(50),
KYC_status varchar(10) default "Pending",
constraint check (Account_Opening_Balance >= 1000),
constraint check (KYC_Status in ("Pending", "Approved", "Rejected")),
constraint check (Account_Type in ("Savings", "Current"))
);
alter table tb_account_form auto_increment=1000001;
drop table tb_account_form;

create table tb_bank (
Account_Number int primary key,
Account_Type varchar(10),
Account_Opening_Date timestamp,
Current_Balance decimal
);

create table tb_account_holder_details (
Account_Number int primary key,
Account_Holder_Name varchar(30),
DOB timestamp,
Aadhar_Number char(12),
Mobile_Number char(10)
);
drop table tb_account_holder_details;

create table tb_transaction_details (
Account_Number int primary key,
Payment_Type enum("Debit", "Credit") not null,
Transaction_Amount decimal,
Date_of_Transaction timestamp default current_timestamp()
);
drop table tb_transaction_details;

desc tb_account_form;
desc tb_bank;
desc tb_account_holder_details;
desc tb_transaction_details;

delimiter //
create trigger tr_open_account_update after update
on tb_account_form
for each row
begin
if NEW.KYC_Status = "Approved" then
insert into tb_bank value (NEW.ID, NEW.Account_Type, curdate(), NEW.Account_Opening_Balance);
insert into tb_account_holder_details value (NEW.id, NEW.Account_Holder_Name, NEW.DOB, NEW.Aadhar_Number, NEW.Mobile_Number);
end if;
end;
// delimiter ;
drop trigger tr_open_account_update;

delimiter //
create trigger tr_open_account_insert after insert
on tb_account_form
for each row
begin
if NEW.KYC_Status = "Approved" then
insert into tb_bank value (NEW.ID, NEW.Account_Type, curdate(), NEW.Account_Opening_Balance);
insert into tb_account_holder_details value (NEW.id, NEW.Account_Holder_Name, NEW.DOB, NEW.Aadhar_Number, NEW.Mobile_Number);
end if;
end;
// delimiter ;
drop trigger tr_open_account_insert;

delimiter //
create trigger tr_Update_Transaction before insert
on tb_transaction_details
for each row
begin
select Current_Balance into Current_Balance from tb_bank where New.Account_Number = Account_Number;
if NEW.Payment_Type = "Debit" and (Current_Balance - NEW.Transaction_Amount) < 0 then
signal sqlstate '45000';
else
update tb_bank set tb_bank.Current_Balance = Current_Balance - NEW.Transaction_Amount where tb_bank.Account_Number = NEW.account_number;
end if;
end;
// delimiter ;
drop trigger tr_Update_Transaction;

INSERT INTO tb_account_form 
(Account_Holder_Name, DOB, Aadhar_Number, Mobile_Number, Account_Opening_Balance, Address_of_account_holder)
VALUE ('John Doe', '1990-01-01', '123456789012', '9876543210', 1500, '123 Main Street');

INSERT INTO tb_TRANSACTION_DETAILS
	VALUE (1, "Debit", 1000.00, current_date());

select * from tb_account_form;
select * from tb_bank;
select * from tb_account_holder_details;
select * from tb_transaction_details;

update tb_account_form set KYC_status = "Approved" where ID = 1;
truncate tb_account_form;
package study;

import java.sql.*;
import java.util.*;

public class bank {
	public static void main(String[] args) {
     
	try 
	{
	  Class.forName("oracle.jdbc.OracleDriver");
			
	  Connection con = DriverManager.getConnection
	  ("jdbc:oracle:thin:@edgar1.cse.lehigh.edu:1521:cse241","sak518","P806706523");
	 	
	 	System.out.println("*** WELCOME TO THE BANK MANAGEMENT SYSTEM ***");
	 	System.out.println();
	 	System.out.println("## The avaliable banks for transaction are ##");
		System.out.println("1: SBI");
		System.out.println("2: PNB");
		System.out.println("3: ICICI");
		System.out.println("4: HDFC");
		System.out.println();
	 	while(true)
	 	{
	 	  System.out.println("-----------------------------------------------");
	 	  System.out.println("press 1 :to create a new account");
	 	  System.out.println("press 2 :to see account details");
	 	  System.out.println("press 3 :to deposit amount into your account");	
	 	  System.out.println("press 4 :to transfer fund");
	 	  System.out.println("press 5 :to read new banking policies");
	 	  System.out.println("press 6 :to quit");
	 	  System.out.println("-----------------------------------------------");
	 	  Scanner s=new Scanner(System.in);
	 	  //take the choice and proceed accordingly
	 	  int choice1=s.nextInt();
	 	  System.out.println("____________________________________________");
	 	  if(choice1==1)//to create new account
	 	  {
	 		  //take the details and add into the particular bank(table)
	 		  System.out.println("enter the account number");
	 		  String account=s.next();
	 		  System.out.println("enter the open date (e.g 2018-08-22)");
	 		  String date=s.next();
	 		  System.out.println("enter the customer id");
	 		  String customer=s.next();
	 		  System.out.println("enter the transaction id");
	 		  String transaction=s.next();
	 		  if(account.length()>10)
	 		  {
	 			  System.out.println("## invalid account number ##");
	 			  break;
	 		  }
	 		  //now store this data into database (in a particular bank table)
	 		  String sql="insert into account values(?,?,?,?,?)";
	 		  PreparedStatement stmt=con.prepareStatement(sql);
	 		  stmt.setString(1, account);
	 		  stmt.setString(2, date);
	 		  stmt.setString(4, customer);
	 		  stmt.setString(5, transaction);
	 		  stmt.executeUpdate();
	 	      System.out.println();
	 	      System.out.println("** account created successfully **");
	 	      System.out.println("_______________________________");
	 	  }//end of 1st if
	 	  
	 	   if(choice1==2)//to see existing account details
	 	   {
	 		 System.out.println("enter your account number");
	 		 String account=s.next();
	 		 String query="select *from account where account_number=?";
	 		 PreparedStatement stmt=con.prepareStatement(query);
	 		 stmt.setString(1, account);
	 		 //create an object of result set to fetch the data
	 		 ResultSet rs=stmt.executeQuery();
	 		 System.out.println("your account details are:");
	 		 while(rs.next())
	 		 {
	 			 System.out.println("account number=>"+rs.getString(1));
	 			 System.out.println("open date=>"+rs.getString(2));
	 			 System.out.println("close date=>"+rs.getString(3));
	 			System.out.println("customer id=>"+rs.getDouble(4));
	 			 System.out.println("transaction id=>"+rs.getDouble(5));
	 		 }
	 		  System.out.println("___________________________");
	 	   }//end of 2nd if
	 	   
	 	   if(choice1==3)//to deposit amount into self account by a user
	 	   {
	 		  System.out.println("enter your bank name");
	 		  String bank=s.next();
	 		  System.out.println("enter your account number");
	 		  String account=s.next();
	 		  //now apply the OTP logic here
	 		  //make an object of class to call the otp generation method
	 		  presentation p=new presentation();
	 		  String ans=p.otpgeneration();
	 		  System.out.println("your OTP is :"+ans);
	 		  System.out.println("------------");
	 		  System.out.println("enter the OTP");
	 		  String otp=s.next();
	 		  if(otp.equals(ans))
	 		  {
	 			 System.out.println("enter the amount to deposit");
	 			 double new_amount=s.nextDouble();
	 			 //to fetch initial amount from database
	 			 String query1="select amount from "+bank+" where account_number=?";
	 			 PreparedStatement stmt1=con.prepareStatement(query1);
	 			 stmt1.setString(1, account);
	 			 ResultSet rs=stmt1.executeQuery();
	 			 double initial_amount=0.0;
	 			 while(rs.next())
	 			 {
	 				 initial_amount=rs.getDouble(1);	
	 			 }
	 			 double amount=initial_amount+new_amount;
	 			 //now update the amount column
	 			 String query2="update "+bank+" set amount=? where account_number=?";
	 			 PreparedStatement stmt2=con.prepareStatement(query2);
	 			 stmt2.setDouble(1, amount);
	 			 stmt2.setString(2, account);
	 			 stmt2.executeUpdate();
	 			 System.out.println("dear "+bank+" user"+" your account is debited ₹"+new_amount);
	 			 System.out.println("your new account balance is ₹"+amount);
	 		  }
	 		  else
	 		  {
	 			 System.out.println("## incorrect OTP ##");
	 			 break; 
	 		  }
	 		    System.out.println("______________________________");
	 	   }//end of 3rd if
	 	   
	 	   if(choice1==4)//to transfer fund into different existing account
	 	   {
	 		  System.out.println("enter your bank name");
	 		  String bank1=s.next();
	 		  System.out.println("enter your account number");
	 		  String account1=s.next();
	 		  System.out.println("enter the bank in which you want to transfer fund");
	 		  String bank2=s.next();
	 		  System.out.println("enter the account number in which you want to transfer fund");
	 		  String account2=s.next();
	 		  //fetch the initial data of the user who is transferring fund
	 		  String query1="select amount from "+bank1+" where account_number=?";
	 		  PreparedStatement stmt1=con.prepareStatement(query1);
	 		  stmt1.setString(1, account1);
	 		  ResultSet rs1=stmt1.executeQuery();
			  double initial_amount1=0.0;
			  while(rs1.next())
			  {
				 initial_amount1=rs1.getDouble(1);	
			  }
			  String query2="select amount from "+bank2+" where account_number=?";
	 		  PreparedStatement stmt2=con.prepareStatement(query2);
	 		  stmt2.setString(1, account2);
	 		  ResultSet rs2=stmt2.executeQuery();
			  double initial_amount2=0.0;
			  while(rs2.next())
			  {
				 initial_amount2=rs2.getDouble(1);	
			  }
	 		  System.out.println("enter the amount you want to transfer");
	 		  double new_amount=s.nextDouble();
	 		  if(initial_amount1 < new_amount)
	 		  {
	 			  System.out.println("## you do not have sufficient amount");
	 			  break;
	 		  }
	 		  else
	 		  {
	 			 double amount1=initial_amount1 - new_amount; //amount for transferring user
	 			 double amount2=initial_amount2 + new_amount; //amount for receiving user
	 			 //to update 1st account
	 			 String query3="update "+bank1+" set amount=? where account_number=?";
	 			 PreparedStatement stmt3=con.prepareStatement(query3);
	 			 stmt3.setDouble(1, amount1);
	 			 stmt3.setString(2, account1);
	 			 stmt3.executeUpdate();
	 			 System.out.println("your account is debited ₹"+new_amount);
	 			 System.out.println("your new account balance is ₹"+amount1);
	 			 //to update 2nd account
	 			 String query4="update "+bank2+" set amount=? where account_number=?";
	 			 PreparedStatement stmt4=con.prepareStatement(query4);
	 			 stmt4.setDouble(1, amount2);
	 			 stmt4.setString(2, account2);
	 			 stmt4.executeUpdate();
	 		  }
	 		  System.out.println("_________________________");
	 	   }//end of 4th if
	 	   
	 	   if(choice1==5)
	 	   {
	 		  System.out.println("** the different bank policies are:");
	 		  System.out.println("car loan rate=> 5%");
	 		  System.out.println("home loan rate=> 14%");
	 		  System.out.println("education loan rate=> 4%");
	 		  System.out.println("LIC insurance=> 0.5%");
	 		  System.out.println("gold loan=> 25%");
	 		  System.out.println("_________________________");
	 	   }//end of 5th if
	 	   
	 	   if(choice1==6)
	 	   {
	 		 break;  
	 	   }//end of last if
	 			
	 	}//end of main while loop
	 	
	 	System.out.println("\n");
	 	System.out.println("**** Thanks For Using the Application ****");
	 	//close the connection
 		con.close();	
	  }//end of try block
		
	    //catch block
		catch (Exception e) 
		{
			e.printStackTrace();
		}
	
	}//end of main method

}//end of class

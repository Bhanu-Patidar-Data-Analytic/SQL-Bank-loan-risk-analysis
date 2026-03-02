### BANK LOAN - DATA ANALYSIS PROJECT ###
# <------------------------------------------------------------------------------------>
select * from financial_loan;


# <------------------------------------------------------------------------------------>
# A. BANK LOAN REPORT | SUMMARY

-- 1. KPI’s:

	-- 1) Number of Applications
		-- a) Total Loan Applications
        
			SELECT count(id) as Total_Loan_Applications
			FROM financial_loan;
        
		-- b) MTD Loan Applications(Month-To-Date i.e. Current Month)
		
			with max_date as (
						select max(issue_date) as max_issue_date
                        from financial_loan)
            SELECT count(id) as MTD_Loan_applications  
			FROM financial_loan, max_date
			where year(issue_date) = year(max_issue_date) 
			  and month(issue_date) = month(max_issue_date)
			;
        
        -- c) PMTD Loan Applications(Previous Month)
            
            with max_date as (
						select max(issue_date) as max_issue_date
                        from financial_loan)
            select count(id) as PMTD_loan_applications
            from financial_loan, max_date
            where year(issue_date) = year(date_sub(max_issue_date, INTERVAL 1 MONTH))
             and month(issue_date) = month(date_sub(max_issue_date, INTERVAL 1 MONTH))
            ;
	-- 2) Funded Amount (Total Loan Amount approved)
		-- a) Total Funded Amount
			
            SELECT sum(loan_amount) as total_loan_amount 
			FROM financial_loan
            ;
            
		-- b) MTD Total Funded Amount
			
            with max_date as (
						select max(issue_date) as max_issue_date
                        from financial_loan)
            select sum(loan_amount) as MTD_total_loan_amount
            from financial_loan, max_date
            where year(issue_date) = year(max_issue_date)
             and  month(issue_date) = month(max_issue_date)
            ;
            
		-- c) PMTD Total Funded Amount
			
            with max_date as (
						select max(issue_date) as max_issue_date
                        from financial_loan)
            select sum(loan_amount) as PMTD_total_loan_amount
            from financial_loan,max_date
            where year(issue_date) = year(date_sub(max_issue_date, INTERVAL 1 MONTH ))
             and month(issue_date) = month(date_sub(max_issue_date, INTERVAL 1 MONTH ))
            ;
            
	-- 3) Amount Received(Loan Amount paid)
		-- a) Total Amount Received
			
            select sum(total_payment) as total_amount_received
            from financial_loan;
            
		-- b) MTD Total Amount Received
			
            with max_date as (
						select max(issue_date) as max_issue_date
                        from financial_loan)
            select sum(total_payment) as MTD_total_amount_received
            from financial_loan,max_date
            where year(issue_date) = year(max_issue_date)
             and month(issue_date) = month(max_issue_date)
            ;
            
		-- c) PMTD Total Amount Received
			
            with max_date as (
						select max(issue_date) as max_issue_date
                        from financial_loan)
            select sum(total_payment) as PMTD_total_amount_received
            from financial_loan,max_date
            where year(issue_date) = year(date_sub(max_issue_date, INTERVAL 1 MONTH ))
             and month(issue_date) = month(date_sub(max_issue_date, INTERVAL 1 MONTH ))
            ;
            
	-- 4) Interest Rate
		-- a) Average Interest Rate
			
            select round(avg(int_rate)*100,2) as average_interest_rate_percent
            from financial_loan;
            
		-- b) MTD Average Interest
			
            with max_date as (
						select max(issue_date) as max_issue_date
                        from financial_loan)
            select round(avg(int_rate)*100,2) as MTD_average_interest_rate
            from financial_loan, max_date
            where year(issue_date) = year(max_issue_date)
             and month(issue_date) = month(max_issue_date)
            ;
            
		-- c) PMTD Average Interest
			
            with max_date as (
						select max(issue_date) as max_issue_date
                        from financial_loan)
            select round(avg(int_rate)*100,2) as PMTD_average_interest_rate
            from financial_loan, max_date
            where year(issue_date) = year(date_sub(max_issue_date, INTERVAL 1 MONTH ))
             and month(issue_date) = month(date_sub(max_issue_date, INTERVAL 1 MONTH ))
            ;
            
	-- 5) DTI (Debt to Income ratio)
		-- a) Avg DTI
			
            select round(avg(dti)*100,2) as average_DTI
            from financial_loan;
            
		-- b) MTD Avg DTI
			
            with max_date as (
						select max(issue_date) as max_issue_date
                        from financial_loan)
            select round(avg(dti)*100,2) as MTD_average_DTI
            from financial_loan,max_date
            where year(issue_date) = year(max_issue_date)
             and month(issue_date) = month(max_issue_date)
            ;
            
		-- c) PMTD Avg DTI
			
            with max_date as (
						select max(issue_date) as max_issue_date
                        from financial_loan)
            select round(avg(dti)*100,2) as PMTD_average_DTI
            from financial_loan, max_date
            where year(issue_date) = year(date_sub(max_issue_date, INTERVAL 1 MONTH ))
             and month(issue_date) = month(date_sub(max_issue_date, INTERVAL 1 MONTH ))
            ;

-- 2. GOOD LOAN ISSUED
	-- 1. Good Loan Percentage
        
        select round(count(case 
						   when loan_status in ("Fully Paid","Current") then id
					       end) *100.0 / count(id),2) as Good_loan_percentage
        from financial_loan;
        
	-- 2. Good Loan Applications
		
		select count(id) as Good_loan_applications
        from financial_loan
        where loan_status in ("Fully Paid","Current")
        ;
        
	-- 3. Good Loan Funded Amount
		
        select sum(loan_amount) as Good_loan_funded_amount
        from financial_loan
        where loan_status in ("Fully Paid","Current")
        ;
        
	-- 4. Good Loan Amount Received
		
        select sum(total_payment) as Good_loan_amount_received
        from financial_loan
        where loan_status in ("Fully Paid","Current")
        ;
        
-- 3. BAD LOAN ISSUED
	-- 1. Bad Loan Percentage
		
        select round(count(case 
						   when loan_status = "Charged Off" then id
					       end) *100.0 / count(id),2) as Bad_loan_percentage 
        from financial_loan;
		
	-- 2. Bad Loan Applications
		
        select count(id) as Bad_loan_applications
        from financial_loan
        where loan_status = "Charged Off"
        ;
        
	-- 3. Bad Loan Funded Amount
		
        select sum(loan_amount) as Bad_loan_funded_amount
        from financial_loan
        where loan_status = "Charged Off"
        ;
        
	-- 4. Bad Loan Amount Received
		
        select sum(total_payment) as Bad_amount_received
        from financial_loan
        where loan_status = "Charged Off"
        ;
		
-- 4. LOAN STATUS
	-- 1. Complete Loan Status Summary
		
        select loan_status, count(*) as Complete_loan_status
        from financial_loan
        group by loan_status
        ;
        
	-- 2. MTD Loan Status Summary
        
        with max_date as (
						  select max(issue_date) as max_issue_date
                          from financial_loan)
        select loan_status, count(*) as Complete_loan_status
        from financial_loan,
			 max_date
        where year(issue_date) = year(max_issue_date)
         and month(issue_date) = month(max_issue_date)
        group by loan_status
        ;
        
# <------------------------------------------------------------------------------------>
# B. BANK LOAN REPORT | OVERVIEW
-- 1. Showcase total number of applications, total loan amount and 
	  -- total amount received for the following parameters.
	-- a. MONTH
		
        select 	date_format(issue_date,"%Y-%m") as year__month,
				count(id) as Total_loan_applications,
				sum(loan_amount) as Total_loan_amount,
				sum(total_payment) as total_loan_amount_received
		from financial_loan
        group by date_format(issue_date,"%Y-%m")
        order by year__month
        ;
        
	-- b. STATE
    
		select 	address_state as State,
				count(id) as Total_loan_applications,
				sum(loan_amount) as Total_loan_amount,
				sum(total_payment) as total_loan_amount_received
		from financial_loan
        group by State
        order by Total_loan_applications desc
        #limit 10
        ;
        
	-- c. TERM
		
        select 	term,
				count(id) as Total_loan_applications,
				sum(loan_amount) as Total_loan_amount,
				sum(total_payment) as total_loan_amount_received
		from financial_loan
        group by term
        order by Total_loan_applications desc
        ;
        
	-- d. EMPLOYEE LENGTH
		
        select 	emp_length as EMPLOYEE_LENGTH,
				count(id) as Total_loan_applications,
				sum(loan_amount) as Total_loan_amount,
				sum(total_payment) as total_loan_amount_received
		from financial_loan
        group by EMPLOYEE_LENGTH
        order by Total_loan_applications desc
        ;
        
	-- e. PURPOSE
		
        select 	purpose,
				count(id) as Total_loan_applications,
				sum(loan_amount) as Total_loan_amount,
				sum(total_payment) as total_loan_amount_received
		from financial_loan
        group by purpose
        order by Total_loan_applications desc
        ;
        
	-- f. HOME OWNERSHIP
		
        select 	home_ownership,
				count(id) as Total_loan_applications,
				sum(loan_amount) as Total_loan_amount,
				sum(total_payment) as total_loan_amount_received
		from financial_loan
        group by home_ownership
        order by Total_loan_applications desc
        ;

# <------------------------------------------------------------------------------------>
# C. Miscellaneous | OVERVIEW
-- 1. MoM Loan Application growth rate
	
    with 
		cu_mon_ap as (select count(id) as Current_month_applications
						from financial_loan
						where year(issue_date) = year((select max(issue_date) from financial_loan))
						 and month(issue_date) = month((select max(issue_date) from financial_loan))
		),
		pr_mon_ap as (select count(id) as Previous_month_applications
						from financial_loan
						where year(issue_date) = year(date_sub((select max(issue_date) from financial_loan), INTERVAL 1 MONTH))
						 and month(issue_date) = month(date_sub((select max(issue_date) from financial_loan), INTERVAL 1 MONTH))
    )
    select round((Current_month_applications - Previous_month_applications)/NULLIF(Previous_month_applications, 0)*100.0,2) 
			as MoM_Loan_Application_growth_rate
    from cu_mon_ap, 
		 pr_mon_ap
         ;
    
    
-- 2. Mom Loan Amount Disbursed growth rate
	
    with 
		cu_mon_ap as (select sum(loan_amount) as Current_month_amount
						from financial_loan
						where year(issue_date) = year((select max(issue_date) from financial_loan))
						 and month(issue_date) = month((select max(issue_date) from financial_loan))
		),
		pr_mon_ap as (select sum(loan_amount) as Previous_month_amount
						from financial_loan
						where year(issue_date) = year(date_sub((select max(issue_date) from financial_loan), INTERVAL 1 MONTH))
						 and month(issue_date) = month(date_sub((select max(issue_date) from financial_loan), INTERVAL 1 MONTH))
    )
    select round(((Current_month_amount - Previous_month_amount)/Previous_month_amount)*100.0,2) 
			as MoM_Loan_amount_Disbursed_growth_rate
    from cu_mon_ap, 
		 pr_mon_ap
         ;
	
-- 3. Interest rate for various subgrade and grade loan type 
	with grade_avg as (
						select grade,
							   round(avg(int_rate)*100, 2) as grade_avg_interest
						from financial_loan
                        group by grade
                        ),
    subgrade_avg as (
						select grade,
							   sub_grade, 
							   round(avg(int_rate)*100, 2) as subgrade_avg_interest							   
						from financial_loan
						group by grade,sub_grade
						)
    select ga.grade,
		   ga.grade_avg_interest,
           sa.sub_grade,
           sa.subgrade_avg_interest
    from grade_avg ga
    join subgrade_avg sa on ga.grade = sa.grade
    order by ga.grade,sa.sub_grade
    ;
    
    


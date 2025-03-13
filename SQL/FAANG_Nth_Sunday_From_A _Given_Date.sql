--nth occurence of sunday from a given date


declare @curr_date date,@n int,@day int;
set @curr_date='2024-11-3';
set @n=3;
set @day=DATEPART(dw,@curr_date);

-- select dateadd(dd,(@n*7)-1,@curr_date);

select case when @day=1 then dateadd(dd,(@n*7),@curr_date)
 when @day=2 then dateadd(dd,(@n*7)-1,@curr_date)
 when @day=3 then dateadd(dd,(@n*7)-2,@curr_date) 
 when @day=4 then dateadd(dd,(@n*7)-3,@curr_date) 
 when @day=5 then dateadd(dd,(@n*7)-4,@curr_date) 
 when @day=6 then dateadd(dd,(@n*7)-5,@curr_date) 
else dateadd(dd,(@n*7)-6,@curr_date) end;

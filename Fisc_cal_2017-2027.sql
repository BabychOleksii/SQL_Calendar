-- ========================================================
-- Calendar is creating according to www.timeanddate.com --
-- ========================================================
-- ==========================
-- create table "calender" --
-- ==========================
create table calendar as
select 
    cal_date
    , to_char(cal_date, 'ddd') as day_of_year
    , to_char(cal_date, 'd') as day_of_week
    , to_char(cal_date, 'dy') as day_name_abbr
    , to_char(cal_date, 'day') as day_name
    , to_char(cal_date, 'dd') as day_of_mon
    , to_char(cal_date, 'ddspth') as day_of_mon_str
    , to_char(cal_date, 'iw') as iso_week_num
    , to_char(cal_date, 'ww') as week_of_year
    , to_char(cal_date, 'mm') as month_numb
    , to_char(cal_date, 'mon') as month_name_abbr
    , to_char(cal_date, 'month') as month_name
    , to_char(cal_date, 'q') as quarter_numb
    , to_char(cal_date, 'iyyy') as iso_year_numb
    , to_char(cal_date, 'yyyy') as year_numb
    , to_char(cal_date, 'year') as year_str    
    , to_char(cal_date, 'dl') as day_full_str -- check
from    
    (select level n
    , (to_date('01/01/2017','dd/mm/yyyy') + level - 1) as cal_date
    from dual
    connect by level  <= 11*365+93 -- calendar made for 10 years. Fisc cal is from 01/04 to 31/03 so wee need period from 01/01/2017 to 31/03/2028. So we take 10 years + 3 months + 3 days for leap year 
    order by cal_date)
;
/
--=========================================
-- create ukrainian holiday's calendar ---
--=========================================
create table hol_ukr(
     cal_date date
    , hol_name varchar2(100)
    , hol_type varchar2(100)
    , hol_region varchar2(100)
    , hol_desc varchar2(1000)
);
/

-- insert ukrainian holidays
insert into hol_ukr (cal_date , hol_name , hol_type , hol_region , hol_desc)
select cal_date
    , hol_name
    , hol_type
    , hol_region
    , hol_desc
from
    (
    select
         cal_date
         , case
            when to_char(cal_date, 'ddmm') = '0101' then q'[New Year's Day]'
            when to_char(cal_date, 'ddmm') = '0701' then 'Christmas Day'
            when to_char(cal_date, 'ddmm') = '1401' then 'Orthodox New Year'
            when to_char(cal_date, 'ddmm') = '2201' then 'Ukrainian Unity Day'
            when to_char(cal_date, 'ddmm') = '2501' then 'Tatiana Day'
            when to_char(cal_date, 'ddmm') = '1402' then q'[Valentine's Day]'
            when to_char(cal_date, 'ddmm') = '0803' then q'[International Women's Day]'
            when to_char(cal_date, 'ddmm') = '2003' then 'March equinox'
            when to_char(cal_date, 'ddmm') = '0104' then 'April Fools'
            when to_char(cal_date, 'dd.mm.yyyy') in ('16.04.2017', '08.04.2018', '28.04.2019', '19.04.2020', '02.05.2021', '24.04.2022', '16.04.2023'
            , '05.05.2024', '20.04.2025', '12.04.2026', '02.05.2027', '16.04.2028') then 'Orthodox Easter Day'
            when to_char(cal_date, 'ddmm') = '0105' then 'Labor Day'
            when to_char(cal_date, 'dd.mm.yyyy') = '02.05.2017' then 'Labor Day Holiday'
            when to_char(cal_date, 'ddmm') = '0905' then 'Victory Day / Memorial Day'
            when to_char(cal_date, 'dd.mm.yyyy') in ('04.06.2017', '27.05.2018', '16.06.2019', '07.06.2020', '20.06.2021', '12.06.2022', '04.06.2023'
            , '23.06.2024', '08.06.2025', '31.05.2026', '20.06.2027', '04.06.2028') then 'Orthodox Pentecost' 
            when to_char(cal_date, 'ddmm') = '2106' THEN 'June Solstice'
            when to_char(cal_date, 'ddmm') = '2806' then 'Constitution Day'
            when to_char(cal_date, 'ddmm') = '0707' THEN 'Kupala Night'
            when to_char(cal_date, 'ddmm') = '0807' THEN 'Family Day'
            when to_char(cal_date, 'ddmm') = '2807' THEN 'Baptism of Kyivan Rus'
            when to_char(cal_date, 'ddmm') = '2408' then 'Independence Day'
            when to_char(cal_date, 'ddmm') = '1410' then q'[Defenders' Day]'
            when to_char(cal_date, 'ddmm') = '2111' THEN 'Dignity and Freedom Day'
            when to_char(cal_date, 'ddmm') = '0612' THEN 'Army Day'
            when to_char(cal_date, 'ddmm') = '1912' THEN 'St. Nicholas Day'
            when to_char(cal_date, 'ddmm') = '2512' then 'Christmas Day'
        end as hol_name
        , case
            when to_char(cal_date, 'ddmm')in ('0101', '0701', '0803', '0105', '0905', '2806', '2408', '1410', '2512') 
                or to_char(cal_date, 'dd.mm.yyyy') = '02.05.2017'
                or to_char(cal_date, 'dd.mm.yyyy') in ('16.04.2017', '08.04.2018', '28.04.2019', '19.04.2020', '02.05.2021', '24.04.2022', '16.04.2023'
            , '05.05.2024', '20.04.2025', '12.04.2026', '02.05.2027', '16.04.2028')
                or to_char(cal_date, 'dd.mm.yyyy') in ('04.06.2017', '27.05.2018', '16.06.2019', '07.06.2020', '20.06.2021', '12.06.2022', '04.06.2023'
                    , '23.06.2024', '08.06.2025', '31.05.2026', '20.06.2027', '04.06.2028')
                then 'National'
            when to_char(cal_date, 'ddmm')in ('1401', '2201', '2501', '1402', '0104', '2106', '0707', '0807', '2807', '2111', '0612', '1912') 
                then 'Observance'
            when to_char(cal_date, 'ddmm')in ('2003', '2106')
                then 'Season'
        end as hol_type
        , null as hol_region
        , case 
            when  to_char(cal_date, 'ddmmyyyy') = '02.05.2017' then 'Rejected as holiday in november 2017'
        end as hol_desc
    from calendar
    
    union all
    
    select -- holidays with float date
        cal_date
        , case 
            when to_char(cal_date, 'mm') = '03' and (cal_date = next_day(last_day(cal_date), 'sunday')-7) then 'Daylight Saving Time starts'
            when to_char(cal_date, 'mm') = '05' and (cal_date = next_day(trunc(cal_date, 'month')-1, 'sunday')+7) then q'[Mother's Day]'
            when to_char(cal_date, 'mm') = '05' and (cal_date = next_day(trunc(cal_date, 'month')-1, 'saturday')+14) then 'Europe Day'
            when to_char(cal_date, 'mm') = '05' and (cal_date = next_day(trunc(cal_date, 'month')-1, 'sunday')+21) then 'Cultural Workers and Folk Artists Day'
            when to_char(cal_date, 'mm') = '07' and (cal_date = next_day(last_day(cal_date), 'sunday')-7) then 'Navy Day'
            when (to_char(cal_date, 'ddmm') = '2209' and to_char(cal_date, 'yy') in ('17','20','21','24','25','28'))
            or (to_char(cal_date, 'ddmm') = '2309' and to_char(cal_date, 'yy') in ('18','19','22','23','26','27')) THEN 'September equinox'
            when to_char(cal_date, 'mm') = '10' and cal_date = next_day(trunc(cal_date, 'month')-1, 'sunday') then q'[Teacher's Day]'
            when to_char(cal_date, 'mm') = '10' and (cal_date = next_day(last_day(cal_date), 'sunday')-7) then 'Daylight Saving Time ends'
            when (to_char(cal_date, 'ddmm') = '2112' and to_char(cal_date, 'yy') in ('17','20','21','22','24','25','26','28'))
            or (to_char(cal_date, 'ddmm') = '2212' and to_char(cal_date, 'yy') in ('18','19','23','27')) THEN 'December Solstice' 
        end as hol_name
        , case 
            when (to_char(cal_date, 'ddmm') = '2209' and to_char(cal_date, 'yy') in ('17','20','21','24','25','28'))
                or (to_char(cal_date, 'ddmm') = '2309' and to_char(cal_date, 'yy') in ('18','19','22','23','26','27'))
                or (to_char(cal_date, 'ddmm') = '2112' and to_char(cal_date, 'yy') in ('17','20','21','22','24','25','26','28'))
                or (to_char(cal_date, 'ddmm') = '2212' and to_char(cal_date, 'yy') in ('18','19','23','27'))
             then 'Season'
             else 'Observance'
        end as hol_type
        , null as hol_region
        , case 
            when to_char(cal_date, 'mm') = '03' and (cal_date = next_day(last_day(cal_date), 'sunday')-7) then 'Last Sunday of March'
            when to_char(cal_date, 'mm') = '05' and (cal_date = next_day(trunc(cal_date, 'month')-1, 'sunday')+7) then '2-nd Sunday of May'
            when to_char(cal_date, 'mm') = '05' and (cal_date = next_day(trunc(cal_date, 'month')-1, 'sunday')+14) then '3-nd Sunday of May'
            when to_char(cal_date, 'mm') = '05' and (cal_date = next_day(trunc(cal_date, 'month')-1, 'sunday')+21) then '4-th Sunday of May'
            when to_char(cal_date, 'mm') = '07' and (cal_date = next_day(last_day(cal_date), 'sunday')-7) then 'Last Sunday of July'
            when to_char(cal_date, 'mm') = '10' and cal_date = next_day(trunc(cal_date, 'month')-1, 'sunday') then 'First Sunday in October'
            when to_char(cal_date, 'mm') = '10' and (cal_date = next_day(last_day(cal_date), 'sunday')-7) then 'Last Sunday of October'
        end as hol_desc 
    from calendar

    union all
    
    select -- holidays with float date part 2
        cal_date
        , case 
            when to_char(cal_date, 'mm') = '05' and (cal_date = next_day(last_day(cal_date), 'sunday')-7) then 'Kiev Day'
        end as hol_name
        , 'Observance' as hol_type
        , null as hol_region
        , 'Last Sunday of May' as hol_desc
    from calendar
    )
where hol_name is not null
order by cal_date
;
/

-- for pivot the hol_ukr table i need to add the index number to holidays in same date and add the priopity of holidays

-- add the column for index number
alter table hol_ukr add hol_numb number;
/

-- add column for holiday priority
alter table hol_ukr add hol_pr number;
/

-- add holiday priority numbers into hol_ukr 
update hol_ukr
set hol_pr = 
    (
    select
        case
            when hol_nat > 0 then 1
            when hol_loc > 0 then 2
            when hol_obs > 0 then 3
            when hol_sea > 0 then 4
            else 5
        end as hol_pr
    from
        (
        select
            cal_date
            , hol_name
            , instr(hol_type, 'National') as hol_nat
            , instr(hol_type, 'Local') as hol_loc
            , instr(hol_type, 'Observance') as hol_obs
            , instr(hol_type, 'Season') as hol_sea
        from hol_ukr
        ) tab
    where tab.cal_date = hol_ukr.cal_date
                and tab.hol_name = hol_ukr.hol_name
    )
;
/

-- we create the copy of hol_ukr table
create table hol_ukr_1 as
select * from hol_ukr;
/

-- insert into hol_ukr the index number to holidays in same date
update hol_ukr
set hol_numb =
            (
            select hol_numb
            from
                (
                select cal_date
                    , hol_name
                    , hol_pr
                    , row_number() over (partition by cal_date order by hol_pr, hol_name) as hol_numb
                from hol_ukr_1
                ) tab
            where tab.cal_date = hol_ukr.cal_date
                and tab.hol_name = hol_ukr.hol_name
            )
;
/

-- drop the copy of hol_ukr table, because we don`t need this table any more
drop table hol_ukr_1;
/

--======================================
-- create canadian holiday's calendar --
--======================================
create table hol_can(
    cal_date date
    , hol_name varchar2(100)
    , hol_type varchar2(100)
    , hol_region varchar2(100)
    , hol_desc varchar2(1000)
    , hol_numb number
    , hol_pr number
);
/

--insert canadian holidays without Muslim, Jewish holidays, Hindu calendar --
insert into hol_can (cal_date, hol_name, hol_type, hol_region, hol_desc, hol_pr, hol_numb)
select cal_date 
    , hol_name
    , hol_type
    , hol_region
    , hol_desc
    , hol_pr
    , row_number() over (partition by cal_date order by hol_pr, hol_name) as hol_numb
from    
    (
    select
        cal_date 
        , hol_name
        , hol_type
        , hol_region
        , hol_desc
        , case
            when hol_nat > 0 then 1
            when hol_loc > 0 then 2
            when hol_obs > 0 then 3
            when hol_sea > 0 then 4
             else 5
        end as hol_pr
    from
        (
        select cal_date 
            , hol_name
            , hol_type
            , hol_region
            , hol_desc
            , instr(hol_type, 'National') as hol_nat
            , instr(hol_type, 'Local') as hol_loc
            , instr(hol_type, 'Observance') as hol_obs
            , instr(hol_type, 'Season') as hol_sea
        from
            (
            select
                cal_date -- holidays with fixed date
                , case
                    when to_char(cal_date, 'ddmm') = '0101' then q'[New Year's Day]'
                    when to_char(cal_date, 'ddmm') = '0201' then q'[Day After New Year's Day]'
                    when to_char(cal_date, 'ddmm') = '0601' then 'Epiphany'
                    when to_char(cal_date, 'ddmm') = '0701' then 'Orthodox Christmas Day'
                    when to_char(cal_date, 'ddmm') = '1401' then 'Orthodox New Year'
                    when to_char(cal_date, 'ddmmyyyy') in ('28012017','16022018','05022019','25012020','12022021','01022022','22012023','10022024'
                        ,'29012025','17022026','06022027','26012028') then 'Chinese New Year'
                    when to_char(cal_date, 'ddmm') = '0202' then 'Groundhog Day'
                    when to_char(cal_date, 'ddmm') = '1402' then q'[Valentine's Day]'
                    when to_char(cal_date, 'ddmm') = '1502' then 'National Flag of Canada Day'
                    when to_char(cal_date, 'ddmm') = '0103' then q'[St David's Day]'
                    when to_char(cal_date, 'ddmm') = '0604' then 'National Tartan Day'
                    when to_char(cal_date, 'ddmm') = '0904' then 'Vimy Ridge Day'
                    when to_char(cal_date, 'ddmm') = '2106' then 'National Aboriginal Day'
                    when to_char(cal_date, 'ddmm') = '2406' then 'St. Jean Baptiste Day'
                    when to_char(cal_date, 'ddmm') = '0107' then 'Canada Day'
                    when to_char(cal_date, 'ddmm') = '0907' then 'Nunavut Day'
                    when to_char(cal_date, 'ddmm') = '1508' then 'Assumption of Mary'
                    when to_char(cal_date, 'ddmm') = '0410' then 'Feast of St Francis of Assisi'
                    when to_char(cal_date, 'ddmm') = '1810' then 'Healthcare Aide Day'
                    when to_char(cal_date, 'ddmm') = '3110' then 'Halloween'
                    when to_char(cal_date, 'ddmm') = '0111' then q'[All Saints' Day]'
                    when to_char(cal_date, 'ddmm') = '0211' then q'[All Souls' Day]'
                    when to_char(cal_date, 'ddmm') = '1111' then 'Remembrance Day'
                    when to_char(cal_date, 'ddmm') = '0812' then 'Feast of the Immaculate Conception'
                    when to_char(cal_date, 'ddmm') = '1112' then 'Anniversary of the Statute of Westminster'
                    when to_char(cal_date, 'ddmm') = '2412' then 'Christmas Eve'
                    when to_char(cal_date, 'ddmm') = '2512' then 'Christmas'
                    when to_char(cal_date, 'ddmm') = '2612' then 'Boxing Day'
                    when to_char(cal_date, 'ddmm') = '3112' then q'[New Year's Eve]'
                    -- when cal_date = (add_months(trunc(sysdate,'year'),12)-1) then q'[New Year's Eve]'. This way of getting last day of year using when only one year
                end as hol_name
                , case
                    when to_char(cal_date, 'ddmm')in ('0101', '0107', '2512') then 'National'
                    when to_char(cal_date, 'ddmm') in ('0201', '2106', '2406', '0907', '1111', '2612') then 'Local'
                    when to_char(cal_date, 'ddmm') in ('0601', '0701', '1401', '0202', '1402', '1502', '0103', '0604', '0904', '1508', '0410'
                        , '1810', '3110', '0111', '0211', '0812', '1112', '2412', '3112')
                        or to_char(cal_date, 'ddmmyyyy') in ('28012017','16022018','05022019','25012020','12022021','01022022','22012023','10022024'
                        ,'29012025','17022026','06022027','26012028') 
                        then 'Observance'
                end as hol_type
                , case
                    when to_char(cal_date, 'ddmm')in ('0201', '2406') then 'Quebec'
                    when to_char(cal_date, 'ddmm') = '2106' then 'Northwest Territories'
                    when to_char(cal_date, 'ddmm') = '0907' then 'Nunavut'
                    when to_char(cal_date, 'ddmm') = '1810' then 'British Columbia'
                    when to_char(cal_date, 'ddmm') = '1111' then 'Manitoba'
                    when to_char(cal_date, 'ddmm') = '2612' then 'Manitoba'
                end as hol_region
                , null as hol_desc
            from calendar
            
            union all
            
            select
                cal_date
                , case
                    when to_char(cal_date, 'ddmm') = '2106' THEN 'National Aboriginal Day'
                    when to_char(cal_date, 'ddmm') = '0107' THEN 'Memorial Day'
                    when to_char(cal_date, 'ddmm') = '1810' then 'Healthcare Aide Day'
                    when to_char(cal_date, 'ddmm') = '1111' then 'Remembrance Day'
                    when to_char(cal_date, 'ddmm') = '2612' then 'Boxing Day'
                end as hol_name
                , case
                    when to_char(cal_date, 'ddmm') in ('2106', '1111', '2612') then 'Local'
                    when to_char(cal_date, 'ddmm') in ('0107', '1810') then 'Observance'
                end as hol_type
                , case
                    when to_char(cal_date, 'ddmm') = '2106' then 'Yukon'
                    when to_char(cal_date, 'ddmm') = '0107' THEN 'Newfoundland and Labrador'
                    when to_char(cal_date, 'ddmm') = '1810' then 'Manitoba'
                    when to_char(cal_date, 'ddmm') = '1111' then 'Northwest Territories'
                    when to_char(cal_date, 'ddmm') = '2612' then 'Newfoundland and Labrador'
                end as hol_region
                , null as hol_desc
            from calendar
            
            union all
            
            select
                cal_date
                , case
                    when to_char(cal_date, 'ddmm') = '1111' then 'Remembrance Day'
                    when to_char(cal_date, 'ddmm') = '2612' then 'Boxing Day'
                end as hol_name
                , case
                    when to_char(cal_date, 'ddmm') in ('1111', '2612') then 'Local'
                end as hol_type
                , case
                    when to_char(cal_date, 'ddmm') = '1111' then 'Nunavut'
                    when to_char(cal_date, 'ddmm') = '2612' then 'Ontario'
                end as hol_region
                , null as hol_desc
            from calendar
                
            union all
            
            select
                cal_date
                , case
                    when to_char(cal_date, 'ddmm') = '1111' then 'Remembrance Day'
                    when to_char(cal_date, 'ddmm') = '2612' then 'Boxing Day'
                end as hol_name
                , case
                    when to_char(cal_date, 'ddmm') in ('1111', '2612') then 'Local'
                end as hol_type
                , case
                    when to_char(cal_date, 'ddmm') = '1111' then 'British Columbia'
                    when to_char(cal_date, 'ddmm') = '2612' then 'Nova Scotia'
                end as hol_region
                , null as hol_desc
            from calendar
            
            union all
            
            select
                cal_date
                , case
                    when to_char(cal_date, 'ddmm') = '1111' then 'Remembrance Day'
                end as hol_name
                , case
                    when to_char(cal_date, 'ddmm') = '1111' then 'Local'
                end as hol_type
                , case
                    when to_char(cal_date, 'ddmm') = '1111' then 'Alberta'
                end as hol_region
                , null as hol_desc
            from calendar
            
            union all
            
            select
                cal_date
                , case
                    when to_char(cal_date, 'ddmm') = '1111' then 'Remembrance Day'
                end as hol_name
                , case
                    when to_char(cal_date, 'ddmm') = '1111' then 'Local'
                end as hol_type
                , case
                    when to_char(cal_date, 'ddmm') = '1111' then 'Saskatchewan'
                end as hol_region
                , null as hol_desc
            from calendar
            
            union all
            
            select
                cal_date
                , case
                    when to_char(cal_date, 'ddmm') = '1111' then 'Remembrance Day'
                    when to_char(cal_date, 'ddmm') = '2612' then 'Boxing Day'
                end as hol_name
                , case
                    when to_char(cal_date, 'ddmm') in ('1111', '2612') then 'Local'
                end as hol_type
                , case
                    when to_char(cal_date, 'ddmm') in ('1111', '2612') then 'Yukon'
                end as hol_region
                , null as hol_desc
            from calendar
        
            union all
            
            select
                cal_date
                , case
                    when to_char(cal_date, 'ddmm') = '1111' then 'Remembrance Day'
                    when to_char(cal_date, 'ddmm') = '2612' then 'Boxing Day'
                end as hol_name
                , case
                    when to_char(cal_date, 'ddmm') in ('1111', '2612') then 'Local'
                end as hol_type
                , case
                    when to_char(cal_date, 'ddmm') in ('1111', '2612') then 'Prince Edward Island'
                end as hol_region
                , null as hol_desc
            from calendar
            
            union all
            
            select
                cal_date
                , case
                    when to_char(cal_date, 'ddmm') = '1111' then 'Remembrance Day'
                    when to_char(cal_date, 'ddmm') = '2612' then 'Boxing Day'
                end as hol_name
                , case
                    when to_char(cal_date, 'ddmm') in ('1111', '2612') then 'Local'
                end as hol_type
                , case
                    when to_char(cal_date, 'ddmm') in ('1111', '2612') then 'New Brunswick'
                end as hol_region
                , null as hol_desc
            from calendar
            
            union all
            -- holidays with float date
            select  
                cal_date
                , case
                    when to_char(cal_date, 'mm') = '02' and (cal_date = next_day(trunc(cal_date, 'month')-1, 'monday')+7) then 'Family Day'
                    when to_char(cal_date, 'mm') = '02' and (cal_date = next_day(trunc(cal_date, 'month')-1, 'monday')+14) then 'Family Day'
                    when to_char(cal_date, 'mm') = '02' and (cal_date = next_day(last_day(cal_date), 'friday')-7) then 'Yukon Heritage Day'
                    when to_char(cal_date, 'mm') = '03' and (cal_date = next_day(trunc(cal_date, 'month')-1, 'sunday')+7) then 'Daylight Saving Time starts'
                    when to_char(cal_date, 'mm') = '03' and (cal_date = next_day(trunc(cal_date, 'month')-1, 'monday')+7) then 'Commonwealth Day'
                    when to_char(cal_date, 'mm') = '05' and (cal_date = next_day(trunc(cal_date, 'month')-1, 'sunday')+7) then q'[Mother's Day]'
                    when to_char(cal_date, 'mm') = '06' and (cal_date = next_day(trunc(cal_date, 'month')-1, 'sunday')+14) then q'[Father's Day]'
                    when to_char(cal_date, 'mm') = '08' and cal_date = next_day(trunc(cal_date, 'month')-1, 'wednesday') 
                        then q'[The Royal St John's Regatta (Regatta Day)]'
                    when to_char(cal_date, 'mm') = '08' and cal_date = next_day(trunc(cal_date, 'month')-1, 'monday') then 'Heritage Day'
                    when to_char(cal_date, 'mm') = '08' and (cal_date = next_day(trunc(cal_date, 'month')-1, 'friday')+14) then 'Gold Cup Parade'
                    when to_char(cal_date, 'mm') = '08' and (cal_date = next_day(trunc(cal_date, 'month')-1, 'monday')+14) then 'Discovery Day'
                    when to_char(cal_date, 'mm') = '09' and cal_date = next_day(trunc(cal_date, 'month')-1, 'monday') then 'Labour Day'
                    when to_char(cal_date, 'mm') = '10' and (cal_date = next_day(trunc(cal_date, 'month')-1, 'monday')+7) then 'Thanksgiving Day'
                    when to_char(cal_date, 'mm') = '11' and cal_date = next_day(trunc(cal_date, 'month')-1, 'monday') then 'Daylight Saving Time ends'
                        end as hol_name
                , case
                    when to_char(cal_date, 'mm') = '09' and cal_date = next_day(trunc(cal_date, 'month')-1, 'monday') 
                        or to_char(cal_date, 'mm') = '10' and (cal_date = next_day(trunc(cal_date, 'month')-1, 'monday')+7)
                    then 'National'
                    when to_char(cal_date, 'mm') = '02' and (cal_date = next_day(trunc(cal_date, 'month')-1, 'monday')+7) 
                        or to_char(cal_date, 'mm') = '02' and (cal_date = next_day(trunc(cal_date, 'month')-1, 'monday')+14)
                        or to_char(cal_date, 'mm') = '02' and (cal_date = next_day(last_day(cal_date), 'friday')-7)
                        or to_char(cal_date, 'mm') = '08' and cal_date = next_day(trunc(cal_date, 'month')-1, 'wednesday')
                        or to_char(cal_date, 'mm') = '08' and cal_date = next_day(trunc(cal_date, 'month')-1, 'monday')
                        or to_char(cal_date, 'mm') = '08' and (cal_date = next_day(trunc(cal_date, 'month')-1, 'friday')+14)
                        or to_char(cal_date, 'mm') = '08' and (cal_date = next_day(trunc(cal_date, 'month')-1, 'monday')+14)
                    then 'Local'
                    when to_char(cal_date, 'mm') = '03' and (cal_date = next_day(trunc(cal_date, 'month')-1, 'sunday')+7) 
                        or to_char(cal_date, 'mm') = '03' and (cal_date = next_day(trunc(cal_date, 'month')-1, 'monday')+7)
                        or to_char(cal_date, 'mm') = '05' and (cal_date = next_day(trunc(cal_date, 'month')-1, 'sunday')+7)
                        or to_char(cal_date, 'mm') = '06' and (cal_date = next_day(trunc(cal_date, 'month')-1, 'sunday')+14)
                        or to_char(cal_date, 'mm') = '11' and cal_date = next_day(trunc(cal_date, 'month')-1, 'monday')
                    then 'Observance'
                end as hol_type
                , case
                    when to_char(cal_date, 'mm') = '02' and (cal_date = next_day(trunc(cal_date, 'month')-1, 'monday')+7) then 'British Columbia'
                    when to_char(cal_date, 'mm') = '02' and (cal_date = next_day(trunc(cal_date, 'month')-1, 'monday')+14) 
                        or to_char(cal_date, 'mm') = '08' and cal_date = next_day(trunc(cal_date, 'month')-1, 'monday')
                    then 'Alberta'
                    when to_char(cal_date, 'mm') = '02' and (cal_date = next_day(last_day(cal_date), 'friday')-7)
                        or to_char(cal_date, 'mm') = '08' and (cal_date = next_day(trunc(cal_date, 'month')-1, 'monday')+14)
                    then 'Yukon'
                    when to_char(cal_date, 'mm') = '08' and cal_date = next_day(trunc(cal_date, 'month')-1, 'wednesday') then 'Newfoundland and Labrador'
                    when to_char(cal_date, 'mm') = '08' and (cal_date = next_day(trunc(cal_date, 'month')-1, 'friday')+14) then 'Prince Edward Island'
                end as hol_region
                , case
                    when to_char(cal_date, 'mm') = '02' and (cal_date = next_day(trunc(cal_date, 'month')-1, 'monday')+7) then '2-nd monday of February'
                    when to_char(cal_date, 'mm') = '02' and (cal_date = next_day(trunc(cal_date, 'month')-1, 'monday')+14) then '3-rd monday of February'
                    when to_char(cal_date, 'mm') = '02' and (cal_date = next_day(last_day(cal_date), 'friday')-7) then 'Last friday of February'
                    when to_char(cal_date, 'mm') = '03' and (cal_date = next_day(trunc(cal_date, 'month')-1, 'sunday')+7) then '2-nd sunday of March'
                    when to_char(cal_date, 'mm') = '03' and (cal_date = next_day(trunc(cal_date, 'month')-1, 'monday')+7) then '2-nd monday of March'
                    when to_char(cal_date, 'mm') = '05' and (cal_date = next_day(trunc(cal_date, 'month')-1, 'sunday')+7) then '2-nd sunday of May'
                    when to_char(cal_date, 'mm') = '06' and (cal_date = next_day(trunc(cal_date, 'month')-1, 'sunday')+14) then '3-rd sunday of June'
                    when to_char(cal_date, 'mm') = '08' and cal_date = next_day(trunc(cal_date, 'month')-1, 'wednesday') then '1-st wednesday of August'
                    when to_char(cal_date, 'mm') = '08' and cal_date = next_day(trunc(cal_date, 'month')-1, 'monday') then '1-st monday of August'
                    when to_char(cal_date, 'mm') = '08' and (cal_date = next_day(trunc(cal_date, 'month')-1, 'friday')+14) then '3-rd friday of August'
                    when to_char(cal_date, 'mm') = '08' and (cal_date = next_day(trunc(cal_date, 'month')-1, 'monday')+14) then '3-rd monday of August'
                    when to_char(cal_date, 'mm') = '09' and cal_date = next_day(trunc(cal_date, 'month')-1, 'monday') then '1-st monday of September'
                    when to_char(cal_date, 'mm') = '10' and (cal_date = next_day(trunc(cal_date, 'month')-1, 'monday')+7) then '2-nd monday of October'
                    when to_char(cal_date, 'mm') = '11' and cal_date = next_day(trunc(cal_date, 'month')-1, 'monday') then '1-st sunday of November'
                end as hol_desc
                from calendar
                
            union all
            
            select
                cal_date
                , case
                    when to_char(cal_date, 'mm') = '02' and (cal_date = next_day(trunc(cal_date, 'month')-1, 'monday')+14) then 'Family Day'
                    when to_char(cal_date, 'mm') = '08' and cal_date = next_day(trunc(cal_date, 'month')-1, 'monday') then 'Civic Holiday'
                end as hol_name
                , case
                    when to_char(cal_date, 'mm') = '02' and (cal_date = next_day(trunc(cal_date, 'month')-1, 'monday')+14)
                        or to_char(cal_date, 'mm') = '08' and cal_date = next_day(trunc(cal_date, 'month')-1, 'monday')
                    then 'Local'
                end as hol_type
                , case
                    when to_char(cal_date, 'mm') = '02' and (cal_date = next_day(trunc(cal_date, 'month')-1, 'monday')+14)
                        or to_char(cal_date, 'mm') = '08' and cal_date = next_day(trunc(cal_date, 'month')-1, 'monday')
                    then 'Ontario'
                end as hol_region
                , case
                    when to_char(cal_date, 'mm') = '02' and (cal_date = next_day(trunc(cal_date, 'month')-1, 'monday')+14) then '3-rd monday of February'
                    when to_char(cal_date, 'mm') = '08' and cal_date = next_day(trunc(cal_date, 'month')-1, 'monday') then '1-st monday of August'
                end as hol_desc
            from calendar
            
            union all
            
            select
                cal_date
                , case
                    when to_char(cal_date, 'mm') = '02' and (cal_date = next_day(trunc(cal_date, 'month')-1, 'monday')+14) then 'Family Day'
                    when to_char(cal_date, 'mm') = '08' and cal_date = next_day(trunc(cal_date, 'month')-1, 'monday') then 'Civic Holiday'
                end as hol_name
                , case
                    when to_char(cal_date, 'mm') = '02' and (cal_date = next_day(trunc(cal_date, 'month')-1, 'monday')+14)
                        or to_char(cal_date, 'mm') = '08' and cal_date = next_day(trunc(cal_date, 'month')-1, 'monday')
                    then 'Local'
                end as hol_type
                , case
                    when to_char(cal_date, 'mm') = '02' and (cal_date = next_day(trunc(cal_date, 'month')-1, 'monday')+14) 
                        or to_char(cal_date, 'mm') = '08' and cal_date = next_day(trunc(cal_date, 'month')-1, 'monday')
                    then 'Saskatchewan'
                end as hol_region
                , case
                    when to_char(cal_date, 'mm') = '02' and (cal_date = next_day(trunc(cal_date, 'month')-1, 'monday')+14) then '3-rd monday of February'
                    when to_char(cal_date, 'mm') = '08' and cal_date = next_day(trunc(cal_date, 'month')-1, 'monday') then '1-st monday of August'
                end as hol_desc        
            from calendar
            
            union all
            
            select
                cal_date
                , case
                    when to_char(cal_date, 'mm') = '02' and (cal_date = next_day(trunc(cal_date, 'month')-1, 'monday')+14) then 'Family Day'
                    when to_char(cal_date, 'mm') = '08' and cal_date = next_day(trunc(cal_date, 'month')-1, 'monday') then 'New Brunswick Day'
                end as hol_name
                , case
                    when to_char(cal_date, 'mm') = '02' and (cal_date = next_day(trunc(cal_date, 'month')-1, 'monday')+14) 
                        or to_char(cal_date, 'mm') = '08' and cal_date = next_day(trunc(cal_date, 'month')-1, 'monday')
                    then 'Local'
                end as hol_type
                , case
                    when to_char(cal_date, 'mm') = '02' and (cal_date = next_day(trunc(cal_date, 'month')-1, 'monday')+14) 
                        or to_char(cal_date, 'mm') = '08' and cal_date = next_day(trunc(cal_date, 'month')-1, 'monday')
                    then 'New Brunswick'
                end as hol_region
                , case
                    when to_char(cal_date, 'mm') = '02' and (cal_date = next_day(trunc(cal_date, 'month')-1, 'monday')+14) then '3-rd monday of February'
                    when to_char(cal_date, 'mm') = '08' and cal_date = next_day(trunc(cal_date, 'month')-1, 'monday') then '1-st monday of August'
                end as hol_desc        
            from calendar
            
            union all
            
            select
                cal_date
                , case
                    when to_char(cal_date, 'mm') = '02' and (cal_date = next_day(trunc(cal_date, 'month')-1, 'monday')+14) then 'Nova Scotia Heritage Day'
                    when to_char(cal_date, 'mm') = '08' and cal_date = next_day(trunc(cal_date, 'month')-1, 'monday') then 'Natal Day'
                end as hol_name
                , case
                    when to_char(cal_date, 'mm') = '02' and (cal_date = next_day(trunc(cal_date, 'month')-1, 'monday')+14) 
                        or to_char(cal_date, 'mm') = '08' and cal_date = next_day(trunc(cal_date, 'month')-1, 'monday')
                    then 'Local'
                end as hol_type
                , case
                    when to_char(cal_date, 'mm') = '02' and (cal_date = next_day(trunc(cal_date, 'month')-1, 'monday')+14) 
                        or to_char(cal_date, 'mm') = '08' and cal_date = next_day(trunc(cal_date, 'month')-1, 'monday')
                    then 'Nova Scotia'
                end as hol_region
                , case
                    when to_char(cal_date, 'mm') = '02' and (cal_date = next_day(trunc(cal_date, 'month')-1, 'monday')+14) then '3-rd monday of February'
                    when to_char(cal_date, 'mm') = '08' and cal_date = next_day(trunc(cal_date, 'month')-1, 'monday') then '1-st monday of August'
                end as hol_desc        
            from calendar
            
            union all
            
            select
                cal_date
                , case
                    when to_char(cal_date, 'mm') = '02' and (cal_date = next_day(trunc(cal_date, 'month')-1, 'monday')+14) then 'Islander Day'
                    when to_char(cal_date, 'mm') = '08' and cal_date = next_day(trunc(cal_date, 'month')-1, 'monday') then 'Natal Day'
                end as hol_name
                , case
                    when to_char(cal_date, 'mm') = '02' and (cal_date = next_day(trunc(cal_date, 'month')-1, 'monday')+14)  
                        or to_char(cal_date, 'mm') = '08' and cal_date = next_day(trunc(cal_date, 'month')-1, 'monday')
                    then 'Local'
                end as hol_type
                , case
                    when to_char(cal_date, 'mm') = '02' and (cal_date = next_day(trunc(cal_date, 'month')-1, 'monday')+14)   
                        or to_char(cal_date, 'mm') = '08' and cal_date = next_day(trunc(cal_date, 'month')-1, 'monday')
                    then 'Prince Edward Island'
                end as hol_region
                , case
                    when to_char(cal_date, 'mm') = '02' and (cal_date = next_day(trunc(cal_date, 'month')-1, 'monday')+14) then '3-rd monday of February'            
                    when to_char(cal_date, 'mm') = '08' and cal_date = next_day(trunc(cal_date, 'month')-1, 'monday') then '1-st monday of August'
                end as hol_desc        
            from calendar
            
            union all
            
            select
                cal_date
                , case
                    when to_char(cal_date, 'mm') = '02' and (cal_date = next_day(trunc(cal_date, 'month')-1, 'monday')+14) then 'Louis Riel Day'
                    when to_char(cal_date, 'mm') = '08' and cal_date = next_day(trunc(cal_date, 'month')-1, 'monday') then 'Terry Fox Day'
                end as hol_name
                , case
                    when to_char(cal_date, 'mm') = '02' and (cal_date = next_day(trunc(cal_date, 'month')-1, 'monday')+14)   
                        or to_char(cal_date, 'mm') = '08' and cal_date = next_day(trunc(cal_date, 'month')-1, 'monday')
                    then 'Local'
                end as hol_type
                , case
                    when to_char(cal_date, 'mm') = '02' and (cal_date = next_day(trunc(cal_date, 'month')-1, 'monday')+14)   
                        or to_char(cal_date, 'mm') = '08' and cal_date = next_day(trunc(cal_date, 'month')-1, 'monday')
                    then 'Manitoba'
                end as hol_region
                , case
                    when to_char(cal_date, 'mm') = '02' and (cal_date = next_day(trunc(cal_date, 'month')-1, 'monday')+14) then '3-rd monday of February'
                    when to_char(cal_date, 'mm') = '08' and cal_date = next_day(trunc(cal_date, 'month')-1, 'monday') then '1-st monday of August'
                end as hol_desc        
            from calendar
            
            union all
            
            select
                cal_date
                , case
                    when to_char(cal_date, 'mm') = '08' and cal_date = next_day(trunc(cal_date, 'month')-1, 'monday') then 'British Columbia Day'
                end as hol_name
                , case
                    when to_char(cal_date, 'mm') = '08' and cal_date = next_day(trunc(cal_date, 'month')-1, 'monday') then 'Local'
                end as hol_type
                , case
                    when to_char(cal_date, 'mm') = '08' and cal_date = next_day(trunc(cal_date, 'month')-1, 'monday') then 'British Columbia'
                end as hol_region
                , case
                    when to_char(cal_date, 'mm') = '08' and cal_date = next_day(trunc(cal_date, 'month')-1, 'monday') then '1-st monday of August'
                end as hol_desc        
            from calendar 
            
            union all
            
            select
                cal_date
                , case
                    when to_char(cal_date, 'mm') = '08' and cal_date = next_day(trunc(cal_date, 'month')-1, 'monday') then 'Civic Holiday'
                end as hol_name
                , case
                    when to_char(cal_date, 'mm') = '08' and cal_date = next_day(trunc(cal_date, 'month')-1, 'monday') then 'Local'
                end as hol_type
                , case
                    when to_char(cal_date, 'mm') = '08' and cal_date = next_day(trunc(cal_date, 'month')-1, 'monday') then 'Nunavut'
                end as hol_region
                , case
                    when to_char(cal_date, 'mm') = '08' and cal_date = next_day(trunc(cal_date, 'month')-1, 'monday') then '1-st monday of August'
                end as hol_desc        
            from calendar 
            
            union all
            
            select
                cal_date
                , case
                    when to_char(cal_date, 'mm') = '08' and cal_date = next_day(trunc(cal_date, 'month')-1, 'monday') then 'Civic Holiday'
                end as hol_name
                , case
                    when to_char(cal_date, 'mm') = '08' and cal_date = next_day(trunc(cal_date, 'month')-1, 'monday') then 'Local'
                end as hol_type
                , case
                    when to_char(cal_date, 'mm') = '08' and cal_date = next_day(trunc(cal_date, 'month')-1, 'monday') then 'Northwest Territories'
                end as hol_region
                , case
                    when to_char(cal_date, 'mm') = '08' and cal_date = next_day(trunc(cal_date, 'month')-1, 'monday') then '1-st monday of August'
                end as hol_desc        
            from calendar    
            
            union all
            
            select
                cal_date
                , case
                    when to_char(cal_date, 'mm') = '08' and cal_date = next_day(trunc(cal_date, 'month')-1, 'monday') then 'Civic Holiday'
                end as hol_name
                , case
                    when to_char(cal_date, 'mm') = '08' and cal_date = next_day(trunc(cal_date, 'month')-1, 'monday') then 'Local'
                end as hol_type
                , case
                    when to_char(cal_date, 'mm') = '08' and cal_date = next_day(trunc(cal_date, 'month')-1, 'monday') then 'Newfoundland and Labrador'
                end as hol_region
                , case
                    when to_char(cal_date, 'mm') = '08' and cal_date = next_day(trunc(cal_date, 'month')-1, 'monday') then '1-st monday of August'
                end as hol_desc        
            from calendar    
            
            union all
            -- equinox days
            select
                cal_date
                , case
                    when (to_char(cal_date, 'ddmm') = '2003' and to_char(cal_date, 'yy') in ('17','18','19','21','22','23','25','26','27'))
                        or (to_char(cal_date, 'ddmm') = '1903' and to_char(cal_date, 'yy') in ('20','24','28')) then 'March equinox'
                    when (to_char(cal_date, 'ddmm') = '2106' and to_char(cal_date, 'yy') in ('17','18','19','22','23','26','27'))
                        or (to_char(cal_date, 'ddmm') = '2006' and to_char(cal_date, 'yy') in ('20','21','24','25','28')) THEN 'June Solstice'
                    when (to_char(cal_date, 'ddmm') = '2209' and to_char(cal_date, 'yy') in ('17','18','20','21','22','24','25','26','28'))
                        or (to_char(cal_date, 'ddmm') = '2309' and to_char(cal_date, 'yy') in ('19','23','27')) THEN 'September equinox'
                    when to_char(cal_date, 'ddmm') = '2112' then 'December Solstice'
                end as hol_name
                , 'Season' as hol_type
                , null as hol_region
                , null as hol_desc        
            from calendar
            
            union all
             -- Easter Sunday related holidays
            select
                case
                    when n=1 then car_cal_date
                    when n=2 then ash_cal_date
                    when n=3 then pal_cal_date
                    when n=4 then mau_cal_date
                    when n=5 then goo_cal_date
                    when n=6 then hol_cal_date
                    when n=7 then es_cal_date
                    when n=8 then mon_cal_date
                    when n=9 then asc_cal_date
                    when n=10 then pen_cal_date
                    when n=11 then whi_cal_date
                    when n=12 then tri_cal_date
                end as cal_date
                , case
                    when n=1 then 'Carnival/Shrove Tuesday'
                    when n=2 then 'Ash Wednesday'
                    when n=3 then 'Palm Sunday'
                    when n=4 then 'Maundy Thursday'
                    when n=5 then 'Good Friday'
                    when n=6 then 'Holy Saturday'
                    when n=7 then 'Easter Sunday'
                    when n=8 then 'Easter Monday'
                    when n=9 then 'Ascension Day'
                    when n=10 then 'Pentecost'
                    when n=11 then 'Whit Monday'
                    when n=12 then 'Trinity Sunday'
                end as hol_name
                , case
                    when n in (5, 7, 8) then 'National'
                    when n in(1, 2, 3, 4, 6, 9, 10, 11, 12) then'Observance'
                end as hol_type
                , null as hol_region
                , case
                    when n=1 then 'Last day before the long fast for Lent'
                    when n=2 then 'First day of Lent'
                    when n=3 then 'Sunday before Easter Sunday'
                    when n=4 then 'Thursday before Easter Sunday'
                    when n=5 then 'Friday before Easter Sunday'
                    when n=6 then 'Saturday before Easter Sunday'
                    when n=7 then 'Easter Sunday'
                    when n=8 then 'Monday after Easter Sunday'
                    when n=9 then '40-th day after Easter Sunday'
                    when n=10 then '50-th day after Easter Sunday'
                    when n=11 then 'Day after Pentecost'
                    when n=12 then 'Sunday after Pentecost'
                end as hol_desc
            from
                (select
                    cal_date-47 as car_cal_date
                    ,cal_date-46 as ash_cal_date
                    ,cal_date-7 as pal_cal_date
                    ,cal_date-3 as mau_cal_date
                    , cal_date-2 as goo_cal_date
                    , cal_date-1 as hol_cal_date
                    , cal_date as es_cal_date
                    , cal_date+1 as mon_cal_date
                    , cal_date+39 as asc_cal_date
                    , cal_date+49 as pen_cal_date
                    , cal_date+50 as whi_cal_date
                    , cal_date+56 as tri_cal_date
                from calendar
                where to_char(cal_date, 'dd.mm.yyyy') in ('16.04.2017', '01.04.2018', '21.04.2019', '12.04.2020', '04.04.2021', '17.04.2022', '09.04.2023'
                    , '31.03.2024', '20.04.2025', '05.04.2026', '28.03.2027', '16.04.2028')
                ) src
                join
                    (select level n from dual
                    connect by level<= 12)
                on 1 = 1
        
            union all
             -- Ortodox Easter Sunday related holidays
            select
                case
                    when n=1 then ort_goo_cal_date
                    when n=2 then ort_hol_cal_date
                    when n=3 then ort_es_cal_date
                    when n=4 then ort_mon_cal_date
                end as cal_date
                , case
                    when n=1 then 'Orthodox Good Friday'
                    when n=2 then 'Orthodox Holy Saturday'
                    when n=3 then 'Orthodox Easter Sunday'
                    when n=4 then 'Orthodox Easter Monday'
                end as hol_name
                , 'Observance' as hol_type
                , null as hol_region
                , case
                    when n=1 then 'Friday before Orthodox Easter Sunday'
                    when n=2 then 'Saturday before Orthodox Easter Sunday'
                    when n=3 then 'Orthodox Easter Sunday'
                    when n=4 then 'Monday after Orthodox Easter Sunday'
                end as hol_desc
            from
                (select
                    cal_date-2 as ort_goo_cal_date
                    , cal_date-1 as ort_hol_cal_date
                    , cal_date as ort_es_cal_date
                    , cal_date+1 as ort_mon_cal_date
                from calendar
                where to_char(cal_date, 'dd.mm.yyyy') in ('16.04.2017', '08.04.2018', '28.04.2019', '19.04.2020', '02.05.2021', '24.04.2022', '16.04.2023'
                    , '05.05.2024', '20.04.2025', '12.04.2026', '02.05.2027', '16.04.2028')
                ) src
                join
                    (select level n from dual
                    connect by level<= 4)
                on 1 = 1
        
            union all
            
            select
                next_day(trunc(cal_date, 'month')+12, 'monday') as cal_date
                , q'[St. Patrick's Day]' as hol_name
                , 'Local' as hol_type
                , 'Newfoundland and Labrador' as hol_region
                , 'Nearest Monday to March 17' as hol_desc
            from calendar
            where to_char(cal_date, 'ddmm') = '1703'
            
            union all
            
            select
                next_day(trunc(cal_date, 'month')+18, 'monday') as cal_date
                , q'[St. George's Day]' as hol_name
                , 'Local' as hol_type
                , 'Newfoundland and Labrador' as hol_region
                , 'Nearest Monday to April,23' as hol_desc
            from calendar
            where to_char(cal_date, 'ddmm') = '2304'
            
            union all
            -- Victoria Day
            select
                next_day(trunc(cal_date, 'month')+16, 'monday') as cal_date
                , 'Victoria Day' as hol_name
                , 'Local' as hol_type
                , 'Ontario' as hol_region
                , 'Monday before 25 May' as hol_desc
            from calendar
            where to_char(cal_date, 'ddmm') = '2505'
            
            union all
            
            select
                next_day(trunc(cal_date, 'month')+16, 'monday') as cal_date
                , 'Victoria Day' as hol_name
                , 'Local' as hol_type
                , 'New Brunswick' as hol_region
                , 'Monday before 25 May' as hol_desc
            from calendar
            where to_char(cal_date, 'ddmm') = '2505'    
            
            union all
            
            select
                next_day(trunc(cal_date, 'month')+16, 'monday') as cal_date
                , 'Victoria Day' as hol_name
                , 'Local' as hol_type
                , 'Manitoba' as hol_region
                , 'Monday before 25 May' as hol_desc
            from calendar
            where to_char(cal_date, 'ddmm') = '2505' 
            
            union all
            
            select
                next_day(trunc(cal_date, 'month')+16, 'monday') as cal_date
                , 'Victoria Day' as hol_name
                , 'Local' as hol_type
                , 'British Columbia' as hol_region
                , 'Monday before 25 May' as hol_desc
            from calendar
            where to_char(cal_date, 'ddmm') = '2505' 
            
            union all
            
            select
                next_day(trunc(cal_date, 'month')+16, 'monday') as cal_date
                , 'Victoria Day' as hol_name
                , 'Local' as hol_type
                , 'Prince Edward Island' as hol_region
                , 'Monday before 25 May' as hol_desc
            from calendar
            where to_char(cal_date, 'ddmm') = '2505'
            
            union all
            
            select
                next_day(trunc(cal_date, 'month')+16, 'monday') as cal_date
                , 'Victoria Day' as hol_name
                , 'Local' as hol_type
                , 'Saskatchewan' as hol_region
                , 'Monday before 25 May' as hol_desc
            from calendar
            where to_char(cal_date, 'ddmm') = '2505'
            
            union all
            
            select
                next_day(trunc(cal_date, 'month')+16, 'monday') as cal_date
                , 'Victoria Day' as hol_name
                , 'Local' as hol_type
                , 'Alberta' as hol_region
                , 'Monday before 25 May' as hol_desc
            from calendar
            where to_char(cal_date, 'ddmm') = '2505' 
            
            union all
            
            select
                next_day(trunc(cal_date, 'month')+16, 'monday') as cal_date
                , 'Victoria Day' as hol_name
                , 'Local' as hol_type
                , 'Newfoundland and Labrador' as hol_region
                , 'Monday before 25 May' as hol_desc
            from calendar
            where to_char(cal_date, 'ddmm') = '2505' 
            
            union all
            
            select
                next_day(trunc(cal_date, 'month')+16, 'monday') as cal_date
                , 'Victoria Day' as hol_name
                , 'Local' as hol_type
                , 'Northwest Territories' as hol_region
                , 'Monday before 25 May' as hol_desc
            from calendar
            where to_char(cal_date, 'ddmm') = '2505' 
            
            union all
            
            select
                next_day(trunc(cal_date, 'month')+16, 'monday') as cal_date
                , 'Victoria Day' as hol_name
                , 'Local' as hol_type
                , 'Yukon' as hol_region
                , 'Monday before 25 May' as hol_desc
            from calendar
            where to_char(cal_date, 'ddmm') = '2505' 
            
            union all
            
            select
                next_day(trunc(cal_date, 'month')+16, 'monday') as cal_date
                , q'[National Patriots' Day]' as hol_name
                , 'Local' as hol_type
                , 'Quebec' as hol_region
                , 'Monday before 25 May' as hol_desc
            from calendar
            where to_char(cal_date, 'ddmm') = '2505' 
            
            union all
            
            select
                next_day(trunc(cal_date, 'month')+19, 'monday') as cal_date
                , 'Discovery Day' as hol_name
                , 'Local' as hol_type
                , 'Newfoundland and Labrador' as hol_region
                , 'Nearest Monday to June 24' as hol_desc
            from calendar
            where to_char(cal_date, 'ddmm') = '2406'
            
            union all
            
            select
                next_day(trunc(cal_date, 'month')+7, 'monday') as cal_date
                , q'[Orangemen's Day]' as hol_name
                , 'Local' as hol_type
                , 'Newfoundland and Labrador' as hol_region
                , 'Nearest Monday to July 12' as hol_desc
            from calendar
            where to_char(cal_date, 'ddmm') = '1207'
            
            union all
            
            select
                next_day(trunc(cal_date, 'month')+25, 'sunday') as cal_date
                , 'First Sunday of Advent' as hol_name
                , 'Observance' as hol_type
                , null as hol_region
                , 'Nearest Sunday to November 30' as hol_desc
            from calendar
            where to_char(cal_date, 'ddmm') = '3011'
            )
        where hol_name is not null
        )
    )
order by cal_date
;
/

commit;
/

-- ==========================================
-- Another way for Easter related holidays --
-- ==========================================

--    select cal_date 
--        , hol_desc
--    from
--        (select
--            cal_date-47 as cal_date
--            , 'Carnival/Shrove Tuesday' as hol_desc -- last day before the long fast Lent. 47 days before Easter. Not a holiday
--        from calendar
--        where to_char(cal_date, 'dd.mm.yyyy') in ('16.04.2017', '01.04.2018', '21.04.2019', '12.04.2020', '04.04.2021', '17.04.2022', '09.04.2023'
--                        , '31.03.2024', '20.04.2025', '05.04.2026', '28.03.2027', '16.04.2028')
--        
--        union all
--                        
--        -- ....
--                        
--        -- union all 
--        
--        select
--            cal_date
--            , 'Easter Sunday' as hol_desc 
--        from calendar
--        where to_char(cal_date, 'dd.mm.yyyy') in ('16.04.2017', '01.04.2018', '21.04.2019', '12.04.2020', '04.04.2021', '17.04.2022', '09.04.2023'
--                        , '31.03.2024', '20.04.2025', '05.04.2026', '28.03.2027', '16.04.2028')
--                        
--        union all
--        
--        select
--            cal_date+50 as cal_date -- 50 days after Easter. Not a holiday
--            , 'Pentecost' as hol_desc 
--        from calendar
--        where to_char(cal_date, 'dd.mm.yyyy') in ('16.04.2017', '01.04.2018', '21.04.2019', '12.04.2020', '04.04.2021', '17.04.2022', '09.04.2023'
--                        , '31.03.2024', '20.04.2025', '05.04.2026', '28.03.2027', '16.04.2028')
--        )
--;
--/

-- =================================
-- spread (pivot) hol_can table --
-- =================================

-- pivot table hol_can for making only one string with date and all holidays this date
create table hol_can_piv as
select * from
(
  select hol_numb, cal_date, hol_name, hol_region, hol_type from hol_can
)
pivot
(
  max(hol_name||' - '||hol_type||' - '|| nvl(hol_region, 'Canada'))
  for (hol_numb) in (1 as hol_1
                    , 2 as hol_2
                    , 3 as hol_3
                    , 4 as hol_4
                    , 5 as hol_5
                    , 6 as hol_6
                    , 7 as hol_7
                    , 8 as hol_8
                    , 9 as hol_9
                    , 10 as hol_10
                    , 11 as hol_11
                    , 12 as hol_12
                    , 13 as hol_13)
                            
)
order by cal_date
;
/

-- add to calendar column for canadian day type
alter table calendar add can_day_type number;
/

-- insert into calendar type of canadian days
update calendar
set can_day_type =
    (
    select cal_day_type
    from
        (
        select cal_date_q1
            , day_of_week_q1
            , hol_1_q1
            , case
                when ins_nat > 0 and day_of_week_q1 in (6,7) then 1 -- National holiday + weekend
                when ins_loc > 0 and day_of_week_q1 in (6,7) then 2 -- Local holiday + weekend
                when ins_nat > 0 then 3 -- National holiday
                when day_of_week_q1 in (6,7) then 4 -- Weekend
                when prev_1_sun = 7 and  nat_hol_sun > 0 then 5 -- Work day after (national holiday + sunday) transform into day off
                -- when prev_2_sat = 6 and  nat_hol_sat > 0 then 6 --  Work day after (national holiday + saturday) transform into day off (Don`t use in Canada)
                when ins_loc > 0 then 7 -- Local
                when prev_1_sun = 7 and  loc_hol_sun > 0 then 8 -- Work day after (local holiday + sunday) transform into local day off
                -- when prev_2_sat = 6 and  loc_hol_sat > 0 then 9 -- Work day after (local holiday + saturday) transform into local day off (Don`t use in Canada)
                when ins_obs > 0 then 10 -- Observance
                when ins_sea > 0 then 11 -- Season
            else 12 -- Work day
            end as cal_day_type
        from
            (
            select calendar.cal_date as cal_date_q1
                , calendar.day_of_week as day_of_week_q1
                , instr(hol_1, '- National -') as ins_nat
                , instr(hol_1, '- Local -') as ins_loc
                , instr(hol_1, '- Observance -') as ins_obs
                , instr(hol_1, '- Season -') as ins_sea
                , lag(day_of_week,1) over (order by calendar.cal_date) as prev_1_sun
                , lag(day_of_week,2) over (order by calendar.cal_date) as prev_2_sat
                , lag(instr(hol_1, '- National -'),1) over (order by calendar.cal_date) as nat_hol_sun
                , lag(instr(hol_1, '- National -'),2) over (order by calendar.cal_date) as nat_hol_sat
                , lag(instr(hol_1, '- Local -'),1) over (order by calendar.cal_date) as loc_hol_sun
                , lag(instr(hol_1, '- Local -'),2) over (order by calendar.cal_date) as loc_hol_sat
                , hol_can_piv.hol_1 as hol_1_q1
                , hol_can_piv.*
            from calendar
            left outer join hol_can_piv
            on calendar.cal_date = hol_can_piv.cal_date
            ) q1
        ) q2
    where q2.cal_date_q1 = calendar.cal_date
    )
;
/

-- add to calendar column for ukrainian day type
alter table calendar add ukr_day_type number;
/

-- insert into calendar type of ukrainian days
update calendar
set ukr_day_type =
    (
    select ukr_day_type
    from
        (
        select cal_date_q1
            , day_of_week_q1
            , hol_1_q1
            , case
                when ins_nat > 0 and day_of_week_q1 in (6,7) then 1 -- National holiday + weekend
                when ins_loc > 0 and day_of_week_q1 in (6,7) then 2 -- Local holiday + weekend
                when ins_nat > 0 then 3 -- National holiday
                when day_of_week_q1 in (6,7) then 4 -- Weekend
                when prev_1_sun = 7 and  nat_hol_sun > 0 then 5 -- Work day after (national holiday + sunday) transform into day off
                when prev_2_sat = 6 and  nat_hol_sat > 0 then 6 --  Work day after (national holiday + saturday) transform into day off (Don`t use in Canada)
                when ins_loc > 0 then 7 -- Local
                when prev_1_sun = 7 and  loc_hol_sun > 0 then 8 -- Work day after (local holiday + sunday) transform into local day off
                when prev_2_sat = 6 and  loc_hol_sat > 0 then 9 -- Work day after (local holiday + saturday) transform into local day off (Don`t use in Canada)
                when ins_obs > 0 then 10 -- Observance
                when ins_sea > 0 then 11 -- Season
            else 12 -- Work day
            end as ukr_day_type
        from
            (
            select calendar.cal_date as cal_date_q1
                , calendar.day_of_week as day_of_week_q1
                , instr(hol_1, '- National -') as ins_nat
                , instr(hol_1, '- Local -') as ins_loc
                , instr(hol_1, '- Observance -') as ins_obs
                , instr(hol_1, '- Season -') as ins_sea
                , lag(day_of_week,1) over (order by calendar.cal_date) as prev_1_sun
                , lag(day_of_week,2) over (order by calendar.cal_date) as prev_2_sat
                , lag(instr(hol_1, '- National -'),1) over (order by calendar.cal_date) as nat_hol_sun
                , lag(instr(hol_1, '- National -'),2) over (order by calendar.cal_date) as nat_hol_sat
                , lag(instr(hol_1, '- Local -'),1) over (order by calendar.cal_date) as loc_hol_sun
                , lag(instr(hol_1, '- Local -'),2) over (order by calendar.cal_date) as loc_hol_sat
                , hol_1 as hol_1_q1
            from calendar
            left outer join 
                (select * from
                    (
                      select hol_numb, cal_date, hol_name, hol_region, hol_type from hol_ukr
                    )
                    pivot
                    (
                      max(hol_name||' - '||hol_type||' - '|| nvl(hol_region, 'Ukraine'))
                      for (hol_numb) in (1 as hol_1
                                        , 2 as hol_2
                                        , 3 as hol_3)
                                                
                    )
                ) hol_ukr_piv
            on calendar.cal_date = hol_ukr_piv.cal_date
            ) q1
        ) q2
    where q2.cal_date_q1 = calendar.cal_date
    )
;
/

commit;
/
select * from hol_ukr where to_char(cal_date, 'd') = '6' AND hol_type = 'National';
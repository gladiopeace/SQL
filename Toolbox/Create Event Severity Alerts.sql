declare @operator_name sysname, @min_severity int
Select
	@operator_name = 'Alex Dess',
	@min_severity = 11
	


declare @event table([Name] nvarchar(255), severity int)

insert into @event ([Name], severity) values ('Specified Database Object Not Found', 11)
insert into @event ([Name], severity) values ('User Transaction Syntax Error', 13)
insert into @event ([Name], severity) values ('Insufficient Permission', 14)
insert into @event ([Name], severity) values ('Syntax Error in SQL Statements', 15)
insert into @event ([Name], severity) values ('Miscellaneous User Error', 16)
insert into @event ([Name], severity) values ('Insufficient Resources', 17)
insert into @event ([Name], severity) values ('Nonfatal Internal Error', 18)
insert into @event ([Name], severity) values ('Fatal Error in Resource', 19)
insert into @event ([Name], severity) values ('Fatal Error in Current Process', 20)
insert into @event ([Name], severity) values ('Fatal Error in Database Processes', 21)
insert into @event ([Name], severity) values ('Fatal Error: Table Integrity Suspect', 22)
insert into @event ([Name], severity) values ('Fatal Error: Database Inegrity Suspect ', 23)
insert into @event ([Name], severity) values ('Fatal Error: Hardware Error', 24)
insert into @event ([Name], severity) values ('Fatal Error', 25)

declare @alert_name sysname, @severity int, @sql varchar(MAX)

declare alert cursor for
 select
	N'Event (Severity ' + CONVERT(varchar(2), severity) + ') - ' + [Name],
	severity
  from @event
  Where severity >= @min_severity
open alert
Fetch next from alert into @alert_name, @severity

While @@FETCH_STATUS = 0
 Begin
	Set @sql = 'EXEC msdb.dbo.sp_add_alert @name=N''' + @alert_name + ''', @message_id=0, @severity=' + CONVERT(varchar(2), @severity) + ', @enabled=1, @delay_between_responses=0, @include_event_description_in=1'

 	print @sql
 	exec (@sql)

	Set @sql = 'EXEC msdb.dbo.sp_add_notification @alert_name=N''' + @alert_name + ''', @operator_name=N''' + @operator_name + ''', @notification_method = 1'
 	print @sql
 	exec (@sql)

	Fetch next from alert into @alert_name, @severity
 End

close alert
deallocate alert
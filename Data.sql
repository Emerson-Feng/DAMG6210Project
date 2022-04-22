--Data
USE Warehouse
GO

INSERT dbo.Administrator VALUES ('ad01','Allen','8573768271','21 Aspinwall Ave','Brookline','02446');
INSERT dbo.Administrator VALUES ('ad02','Barry','8573768272','22 Aspinwall Ave','Brookline','02446');
INSERT dbo.Administrator VALUES ('ad03','Curry','8573768273','23 Aspinwall Ave','Brookline','02446');
INSERT dbo.Administrator VALUES ('ad04','Daley','8573768274','24 Aspinwall Ave','Brookline','02446');
INSERT dbo.Administrator VALUES ('ad05','Ethan','8573768275','25 Aspinwall Ave','Brookline','02446');
INSERT dbo.Administrator VALUES ('ad06','Frank','8573768276','26 Aspinwall Ave','Brookline','02446');
INSERT dbo.Administrator VALUES ('ad07','Grant','8573768277','27 Aspinwall Ave','Brookline','02446');
INSERT dbo.Administrator VALUES ('ad08','Hughe','8573768278','28 Aspinwall Ave','Brookline','02446');
INSERT dbo.Administrator VALUES ('ad09','Ivery','8573768279','29 Aspinwall Ave','Brookline','02446');
INSERT dbo.Administrator VALUES ('ad10','James','8573768270','30 Aspinwall Ave','Brookline','02446');

Go

INSERT dbo.Warehouse VALUES (1001,'Warehouse 1','121 Harvard Street','Brookline','02446');
INSERT dbo.Warehouse VALUES (1002,'Warehouse 2','122 Harvard Street','Brookline','02446');
INSERT dbo.Warehouse VALUES (1003,'Warehouse 3','123 Harvard Street','Brookline','02446');
INSERT dbo.Warehouse VALUES (1004,'Warehouse 4','124 Harvard Street','Brookline','02446');
INSERT dbo.Warehouse VALUES (1005,'Warehouse 5','125 Harvard Street','Brookline','02446');
INSERT dbo.Warehouse VALUES (1006,'Warehouse 6','126 Harvard Street','Brookline','02446');
INSERT dbo.Warehouse VALUES (1007,'Warehouse 7','127 Harvard Street','Brookline','02446');
INSERT dbo.Warehouse VALUES (1008,'Warehouse 8','128 Harvard Street','Brookline','02446');
INSERT dbo.Warehouse VALUES (1009,'Warehouse 9','129 Harvard Street','Brookline','02446');
INSERT dbo.Warehouse VALUES (1010,'Warehouse 10','120 Harvard Street','Brookline','02446');

GO

INSERT dbo.Supplier VALUES (20001,'Apple','6171001001','201 Huntington Ave','Boston','02115');
INSERT dbo.Supplier VALUES (20002,'Samsung','6171001002','202 Huntington Ave','Boston','02115');
INSERT dbo.Supplier VALUES (20003,'Meta','6171001003','203 Huntington Ave','Boston','02115');
INSERT dbo.Supplier VALUES (20004,'Twiiter','6171001004','204 Huntington Ave','Boston','02115');
INSERT dbo.Supplier VALUES (20005,'Reddit','6171001005','205 Huntington Ave','Boston','02115');
INSERT dbo.Supplier VALUES (20006,'Amazon','6171001006','206 Huntington Ave','Boston','02115');
INSERT dbo.Supplier VALUES (20007,'AT&T','6171001007','207 Huntington Ave','Boston','02115');
INSERT dbo.Supplier VALUES (20008,'Walgreen','6171001008','208 Huntington Ave','Boston','02115');
INSERT dbo.Supplier VALUES (20009,'Microsoft','6171001009','209 Huntington Ave','Boston','02115');
INSERT dbo.Supplier VALUES (20010,'Walmart','6171001010','210 Huntington Ave','Boston','02115');

GO

INSERT dbo.Product VALUES (10001,'Laptop','appliance','20001');
INSERT dbo.Product VALUES (10002,'Ipad','appliance','20002');
INSERT dbo.Product VALUES (10003,'Printer','appliance','20003');
INSERT dbo.Product VALUES (10004,'Scanner','appliance','20004');
INSERT dbo.Product VALUES (10005,'Lamp','appliance','20005');
INSERT dbo.Product VALUES (10006,'Desk','furniture','20006');
INSERT dbo.Product VALUES (10007,'Bed','furniture','20007');
INSERT dbo.Product VALUES (10008,'Chair','furniture','20008');
INSERT dbo.Product VALUES (10009,'Bread','food','20009');
INSERT dbo.Product VALUES (10010,'Milk','food','20010');

INSERT dbo.Product VALUES (10011,'TV','appliance','20002');
INSERT dbo.Product VALUES (10012,'Router','appliance','20007');
INSERT dbo.Product VALUES (10013,'Reticle','appliance','20007');
INSERT dbo.Product VALUES (10014,'ScrewDrver','appliance','20006');
INSERT dbo.Product VALUES (10015,'Hammer','appliance','20006');
INSERT dbo.Product VALUES (10016,'Cookies','food','20006');
INSERT dbo.Product VALUES (10017,'Juice','food','20010');
INSERT dbo.Product VALUES (10018,'Cheese','food','20010');
INSERT dbo.Product VALUES (10019,'Egg','food','20010');
INSERT dbo.Product VALUES (10020,'Fruit','food','20010');


GO

INSERT dbo.Customer VALUES (30001,'CustomerA','6173721001','1 Kent Street','Brookline','02446');
INSERT dbo.Customer VALUES (30002,'CustomerB','6173721002','2 Kent Street','Brookline','02446');
INSERT dbo.Customer VALUES (30003,'CustomerC','6173721003','3 Kent Street','Brookline','02446');
INSERT dbo.Customer VALUES (30004,'CustomerD','6173721004','4 Kent Street','Brookline','02446');
INSERT dbo.Customer VALUES (30005,'CustomerE','6173721005','5 Kent Street','Brookline','02446');
INSERT dbo.Customer VALUES (30006,'CustomerF','6173721006','6 Kent Street','Brookline','02446');
INSERT dbo.Customer VALUES (30007,'CustomerG','6173721007','7 Kent Street','Brookline','02446');
INSERT dbo.Customer VALUES (30008,'CustomerH','6173721008','8 Kent Street','Brookline','02446');
INSERT dbo.Customer VALUES (30009,'CustomerI','6173721009','9 Kent Street','Brookline','02446');
INSERT dbo.Customer VALUES (30010,'CustomerJ','6173721010','10 Kent Street','Brookline','02446');

GO
INSERT dbo.Store VALUES (10001,1001,550);
INSERT dbo.Store VALUES (10002,1002,450);
INSERT dbo.Store VALUES (10003,1003,0);
INSERT dbo.Store VALUES (10004,1004,450);
INSERT dbo.Store VALUES (10005,1005,460);
INSERT dbo.Store VALUES (10006,1006,480);
INSERT dbo.Store VALUES (10007,1007,420);
INSERT dbo.Store VALUES (10008,1008,390);
INSERT dbo.Store VALUES (10009,1009,450);
INSERT dbo.Store VALUES (10010,1010,330);

INSERT dbo.Store VALUES (10011,1001,500);
INSERT dbo.Store VALUES (10012,1002,500);
INSERT dbo.Store VALUES (10013,1003,500);
INSERT dbo.Store VALUES (10014,1004,500);
INSERT dbo.Store VALUES (10015,1005,500);
INSERT dbo.Store VALUES (10016,1006,500);
INSERT dbo.Store VALUES (10017,1007,500);
INSERT dbo.Store VALUES (10018,1008,500);
INSERT dbo.Store VALUES (10019,1009,500);
INSERT dbo.Store VALUES (10020,1010,500);

GO



INSERT dbo.InStock VALUES (1001,10001,500,'ad01',getdate());
INSERT dbo.InStock VALUES (1002,10002,500,'ad02',getdate());
INSERT dbo.InStock VALUES (1003,10003,500,'ad03',getdate());
INSERT dbo.InStock VALUES (1004,10004,500,'ad04',getdate());
INSERT dbo.InStock VALUES (1005,10005,500,'ad05',getdate());
INSERT dbo.InStock VALUES (1006,10006,500,'ad06',getdate());
INSERT dbo.InStock VALUES (1007,10007,500,'ad07',getdate());
INSERT dbo.InStock VALUES (1008,10008,500,'ad08',getdate());
INSERT dbo.InStock VALUES (1009,10009,500,'ad09',getdate());
INSERT dbo.InStock VALUES (1010,10010,350,'ad10',getdate());

INSERT dbo.InStock VALUES (1001,10011,500,'ad01',getdate());
INSERT dbo.InStock VALUES (1002,10012,500,'ad02',getdate());
INSERT dbo.InStock VALUES (1003,10013,500,'ad03',getdate());
INSERT dbo.InStock VALUES (1004,10014,500,'ad04',getdate());
INSERT dbo.InStock VALUES (1005,10015,500,'ad05',getdate());
INSERT dbo.InStock VALUES (1006,10016,500,'ad06',getdate());
INSERT dbo.InStock VALUES (1007,10017,500,'ad07',getdate());
INSERT dbo.InStock VALUES (1008,10018,500,'ad08',getdate());
INSERT dbo.InStock VALUES (1009,10019,500,'ad09',getdate());
INSERT dbo.InStock VALUES (1010,10020,500,'ad10',getdate());

INSERT dbo.InStock VALUES (1001,10001,200,'ad01','2022-4-10');
INSERT dbo.InStock VALUES (1010,10010,200,'ad10','2022-4-11');
INSERT dbo.InStock VALUES (1010,10010,150,'ad10','2022-4-16');

GO
INSERT dbo.OutStock VALUES (1001,10001,150,30001,'ad01',getdate());
INSERT dbo.OutStock VALUES (1002,10002,50,30002,'ad02',getdate());
INSERT dbo.OutStock VALUES (1003,10003,500,30003,'ad03',getdate());
INSERT dbo.OutStock VALUES (1004,10004,50,30004,'ad04',getdate());
INSERT dbo.OutStock VALUES (1005,10005,40,30005,'ad05',getdate());
INSERT dbo.OutStock VALUES (1006,10006,20,30006,'ad06',getdate());
INSERT dbo.OutStock VALUES (1007,10007,80,30007,'ad07',getdate());
INSERT dbo.OutStock VALUES (1008,10008,110,30008,'ad08',getdate());
INSERT dbo.OutStock VALUES (1009,10009,50,30009,'ad09',getdate());
INSERT dbo.OutStock VALUES (1010,10010,370,30010,'ad10',getdate());


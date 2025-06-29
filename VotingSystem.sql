create table admin(
username varchar2(28) constraint admin_pk primary key,
password varchar2(20));

create table party(
party_name varchar2(50) constraint party_pk primary key,
founder varchar2(50),
date_of_found date,
party_chief varchar2(40));

create table members(
name_m varchar2(30),
id_m number(15) constraint member_pk primary key, 
address_m varchar2(40),
Dob_m date,
party_name varchar2(50),
id_c number(15));

create table candidate(
id_c number(15) constraint candidate_pk primary key,
password_c varchar2(20),
name_c varchar2(30),
constituency_number number(15),
username varchar2(28));

create table results(
number_of_votes number(15),
id_c number(15),
constituency_number number(15),
username varchar2(28),
constraint results_pk primary key(number_of_votes,id_c,constituency_number,username));

create table area(
area_name varchar2(40),
constituency_number number(15) constraint area_pk primary key);

create table e_ballot(
s_no number(15) constraint e_ballot_pk primary key,
date_of_vote date,
party_name varchar2(50),
constituency_number number(15),
id number(15),
username varchar2(28));

create table voter(
id number(15) constraint voter_pk primary key,
pass varchar2(20),
name varchar2(35),
DOB date,
address varchar2(55),
constituency_number number(15));

create table keeps_check_on(
username varchar2(28),
party_name varchar2(50),
constraint keeps_check_on_pk primary key(username,party_name));

create table view_profile(
id number(15),
id_c number(15),
constraint view_profile_pk primary key(id,id_c));

create table manages(
username varchar2(28),
id number(15),
constraint manages_pk primary key(username,id));

CREATE TABLE member_phone (
    id_m NUMBER(15),
    phone_no VARCHAR2(15),
    CONSTRAINT member_phone_pk PRIMARY KEY (id_m, phone_no),
    CONSTRAINT member_phone_fk FOREIGN KEY (id_m) REFERENCES members(id_m)
);




alter table members add constraint members_fk foreign key(id_c) references candidate(id_c);
alter table candidate add constraint candidate_fk foreign key(username) references admin(username);
alter table candidate add constraint candidate_fk1 foreign key(constituency_number) references area(constituency_number);
alter table results add constraint results_fk foreign key(id_c) references candidate(id_c);
alter table results add constraint results_fk1 foreign key(constituency_number) references area(constituency_number);
alter table results add constraint results_fk2 foreign key(username) references admin(username);
alter table e_ballot add constraint e_ballot_fk2 foreign key(party_name) references party(party_name);
alter table e_ballot add constraint e_ballot_fk1 foreign key(constituency_number) references area(constituency_number);
alter table e_ballot add constraint e_ballot_fk foreign key(id) references voter(id);
alter table e_ballot add constraint e_ballot_fk4 foreign key(username) references admin(username);
alter table voter add constraint voter_fk foreign key(constituency_number) references area(constituency_number);
alter table keeps_check_on add constraint keeps_check_on_fk foreign key(username) references admin(username);
alter table keeps_check_on add constraint keeps_check_on_fk1 foreign key(party_name) references party(party_name);
alter table view_profile add constraint view_profile_fk1 foreign key(id) references voter(id);
alter table manages add constraint manages_fk foreign key(username) references admin(username);
alter table manages add constraint manages_fk1 foreign key(id) references voter(id);


CREATE OR REPLACE TRIGGER trg_default_vote_date
BEFORE INSERT ON e_ballot
FOR EACH ROW
BEGIN
  IF :NEW.date_of_vote IS NULL THEN
    :NEW.date_of_vote := SYSDATE;
  END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_prevent_duplicate_vote
BEFORE INSERT ON e_ballot
FOR EACH ROW
DECLARE
  v_count INTEGER;
BEGIN
  SELECT COUNT(*) INTO v_count
  FROM e_ballot
  WHERE id = :NEW.id
    AND constituency_number = :NEW.constituency_number
    AND date_of_vote = :NEW.date_of_vote;

  IF v_count > 0 THEN
    RAISE_APPLICATION_ERROR(-20001, 'Duplicate vote detected:voter cannot vote twice in the election.');
  END IF;
END;
/

create trigger trig6
after update on area
for each row
begin
update voter set constituency_number=:new.constituency_number where constituency_number=:old.constituency_number;
end trig6;

update area set constituency_number=212345 where area_name='Varanasi';
select * from area;
select * from voter;



INSERT INTO admin VALUES ('mohitverma6161','mohit123');
INSERT INTO admin VALUES ('aayush123','canadanoor');
INSERT INTO admin VALUES ('purushottam123','gangleader');
INSERT INTO admin VALUES ('prateek','coder');

INSERT INTO area VALUES ('gandhinagar',112233);
INSERT INTO area VALUES ('Varanasi',22113);
INSERT INTO area VALUES ('yelagiri',998869);
INSERT INTO area VALUES ('ballia',224050);
INSERT INTO area VALUES ('ballia',224052);

INSERT INTO voter VALUES (123, 'dbms1', 'Adarsh', TO_DATE('1998-08-15', 'YYYY-MM-DD'), 'Bhubhaneshwar', 112233);
INSERT INTO voter VALUES (111, 'dbms2', 'Siddharth', TO_DATE('1997-01-26', 'YYYY-MM-DD'), 'Delhi', 998869);
INSERT INTO voter VALUES (222, 'dbms3', 'Sankalp', TO_DATE('1996-10-02', 'YYYY-MM-DD'), 'Ghaziabad', 998869);
INSERT INTO voter VALUES (331, 'dbms4', 'Deepak', TO_DATE('1996-11-14', 'YYYY-MM-DD'), 'Varanasi', 22113);
INSERT INTO voter VALUES (444, 'dbms5', 'Yuvi', TO_DATE('1995-10-28', 'YYYY-MM-DD'), 'Ballia', 224050);
INSERT INTO voter VALUES (555, 'dbms6', 'Dhoni', TO_DATE('1995-12-28', 'YYYY-MM-DD'), 'Ranchi', 224050);
INSERT INTO voter VALUES (666, 'dbms7', 'Shikhar', TO_DATE('1993-03-11', 'YYYY-MM-DD'), 'Lucknow', 224050);
INSERT INTO voter VALUES (777, 'dbms8', 'Rohit', TO_DATE('1993-01-10', 'YYYY-MM-DD'), 'Ludhiana', 998869);
INSERT INTO voter VALUES (888, 'dbms9', 'Suresh', TO_DATE('1999-12-28', 'YYYY-MM-DD'), 'Hisar', 112233);
INSERT INTO voter VALUES (999, 'dbms10', 'Ajinkya', TO_DATE('1999-11-28', 'YYYY-MM-DD'), 'Chennai', 224052);
INSERT INTO voter VALUES (998, 'dbms11', 'Pandya', TO_DATE('1999-06-21', 'YYYY-MM-DD'), 'Chennai', 224052);
INSERT INTO voter VALUES (988, 'dbms12', 'Krunal', TO_DATE('1999-06-21', 'YYYY-MM-DD'), 'Pondicherry', 998869);

INSERT INTO party VALUES ('KKP', 'kavi', TO_DATE('1964-08-01', 'YYYY-MM-DD'), 'ravi');
INSERT INTO party VALUES ('RJD', 'lalu', TO_DATE('1964-08-01', 'YYYY-MM-DD'), 'nitish');
INSERT INTO party VALUES ('SHIVSENA', 'Thakare', TO_DATE('1950-11-14', 'YYYY-MM-DD'), 'Shaktiman');
INSERT INTO party VALUES ('BANARAS MUKTI MORCHA', 'Mohit', TO_DATE('1999-02-14', 'YYYY-MM-DD'), 'Rohit');

INSERT INTO members VALUES ('Pappu', 777, 'Ameethi', TO_DATE('1985-11-14', 'YYYY-MM-DD'), 'RJD', 555);
INSERT INTO members VALUES ('Raj', 854, 'Faridabad', TO_DATE('1994-03-30', 'YYYY-MM-DD'), 'KKP', 212);
INSERT INTO members VALUES ('Gautam', 666, 'Hisar', TO_DATE('1998-10-30', 'YYYY-MM-DD'), 'BANARAS MUKTI MORCHA', 111);
INSERT INTO members VALUES ('Vidit', 742, 'Kurushetra', TO_DATE('1998-11-30', 'YYYY-MM-DD'), 'BANARAS MUKTI MORCHA', 111);

INSERT INTO e_ballot VALUES (12345, TO_DATE('2018-10-14', 'YYYY-MM-DD'), 'KKP', 112233, 123, 'prateek');
INSERT INTO e_ballot VALUES (12346, TO_DATE('2018-10-18', 'YYYY-MM-DD'), 'RJD', 224050, 333, 'mohitverma6161');
INSERT INTO e_ballot VALUES (12347, TO_DATE('2018-11-04', 'YYYY-MM-DD'), 'BANARAS MUKTI MORCHA', 998869, 222, 'purushottam123');
INSERT INTO e_ballot VALUES (12348, TO_DATE('2018-11-10', 'YYYY-MM-DD'), 'SHIVSENA', 998869, 998, 'mohitverma6161');
INSERT INTO e_ballot VALUES (12349, TO_DATE('2018-10-14', 'YYYY-MM-DD'), 'KKP', 112233, 777, 'prateek');
INSERT INTO e_ballot VALUES (12350, TO_DATE('2018-10-14', 'YYYY-MM-DD'), 'KKP', 112233, 666, 'mohitverma6161');
INSERT INTO e_ballot VALUES (12351, TO_DATE('2018-10-14', 'YYYY-MM-DD'), 'KKP', 112233, 888, 'mohitverma6161');
INSERT INTO e_ballot VALUES (12352, TO_DATE('2018-10-14', 'YYYY-MM-DD'), 'KKP', 112233, 988, 'purushottam123');
INSERT INTO e_ballot VALUES (12353, TO_DATE('2018-10-14', 'YYYY-MM-DD'), 'BANARAS MUKTI MORCHA', 112233, 111, 'mohitverma6161');
INSERT INTO e_ballot VALUES (12354, TO_DATE('2018-10-28', 'YYYY-MM-DD'), 'BANARAS MUKTI MORCHA', 112233, 444, 'mohitverma6161');


INSERT INTO keeps_check_on VALUES ('mohitverma6161','RJD');
INSERT INTO keeps_check_on VALUES ('mohitverma6161','BANARAS MUKTI MORCHA');
INSERT INTO keeps_check_on VALUES ('mohitverma6161','SHIVSENA');
INSERT INTO keeps_check_on VALUES ('prateek','KKP');
INSERT INTO keeps_check_on VALUES ('aayush123','RJD');

INSERT INTO manages VALUES ('mohitverma6161',123);
INSERT INTO manages VALUES ('mohitverma6161',111);
INSERT INTO manages VALUES ('aayush123',222);
INSERT INTO manages VALUES ('purushottam123',333);
INSERT INTO manages VALUES ('prateek',123);

INSERT INTO view_profile VALUES (123,666);
INSERT INTO view_profile VALUES (123,111);
INSERT INTO view_profile VALUES (123,212);
INSERT INTO view_profile VALUES (111,212);
INSERT INTO view_profile VALUES (222,666);
INSERT INTO view_profile VALUES (333,555);
INSERT INTO view_profile VALUES (222,555);
INSERT INTO view_profile VALUES (111,555);
INSERT INTO view_profile VALUES (111,666);
INSERT INTO view_profile VALUES (111,111);

INSERT INTO results VALUES (4,111,224052,'mohitverma6161');
INSERT INTO results VALUES (3,666,998869,'aayush123');
INSERT INTO results VALUES (0,555,112233,'purushottam123');
INSERT INTO results VALUES (3,212,224050,'mohitverma6161');

INSERT INTO member_phone VALUES (777, '9876543210');
INSERT INTO member_phone VALUES (777, '9123456780');
INSERT INTO member_phone VALUES (854, '9988776655');
INSERT INTO member_phone VALUES (854, '7766554433');
INSERT INTO member_phone VALUES (666, '9090909090');
INSERT INTO member_phone VALUES (666, '8080808080');
INSERT INTO member_phone VALUES (742, '7007007007');
INSERT INTO member_phone VALUES (742, '6006006006');


create or replace function cons(cons number) return varchar is
a area.area_name%type;
begin
select area_name into a from area where constituency_number=cons;
return a;
end;
/
begin
dbms_output.put_line(cons(221133));
end;
/ 

declare
id number(15);
name members.name_m%type;
dob members.Dob_m%type;
cursor c1 is select name_m,Dob_m,party_name from members where id_c=id; 
party members.party_name%type;
begin
d:=&id;
open c1;
loop
fetch c1 into name,dob,party;
exit when c1%notfound;
dbms_output.put_line(name||' '||dob||' '||party);
end loop;
close c1;
end;
/

create or replace procedure area2(id in number,area out varchar) is
begin
select area_name into area from area where constituency_number in(select constituency_number from candidate where id_c=id);
dbms_output.put_line(area); 
end;
/
declare
b varchar2(15); 
begin
area2(212,b); 
end;
/
--FIND THE NUMBER OF VOTES FOR A CANDIDATE AND HIS RESPECTIVE PARTY DETAILS
select r.number_of_votes,c.id_c,m.party_name from results r,candidate c,members m where r.id_c=c.id_c and c.id_c=m.id_c;


SELECT * FROM admin;


SELECT * FROM party;


SELECT * FROM members;


SELECT * FROM candidate;


SELECT * FROM results;


SELECT * FROM area;

SELECT * FROM e_ballot;


SELECT * FROM voter;


SELECT * FROM keeps_check_on;


SELECT * FROM view_profile;


SELECT * FROM manages;


SELECT * FROM member_phone;

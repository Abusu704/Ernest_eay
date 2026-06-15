create database student_informatio_db;
use student_information_db;
create table students(
student_id INT auto_increment primary key,
index_number varchar(20) unique not null,
first_name varchar(50) not null,
last_name varchar(50) not null,
gender enum('Male','Female') not null,
date_of_birth date not null,
level enum('100','200','300','400') not null,
programme varchar(100) not null,
email varchar(100) unique not null,
admission_year year not null,
gpa decimal(3,2) check (gpa >=0.00 and  gpa<= 4.00),
residential_status enum('Resident','Non-Resident') not null,
status enum('Active','Deferred','Graduated') not null);
INSERT INTO students (
    index_number, first_name, last_name, gender, date_of_birth, level, programme, 
    email, phone_number, admission_year, gpa, residential_status, status
)
VALUES
('2425574890', 'Kwame',    'Asante',    'Male',   '2002-03-15', '400', 'Computer Engineering',          'kwame.asante@student.edu',    '0241234567', 2020, 3.75, 'Resident',     'Active'),
('2425312047', 'Abena',    'Mensah',    'Female', '2002-07-22', '400', 'Electrical Engineering',        'abena.mensah@student.edu',    '0242345678', 2020, 3.50, 'Non-Resident', 'Active'),
('2425198763', 'Kofi',     'Boateng',   'Male',   '2003-01-10', '300', 'Computer Engineering',          'kofi.boateng@student.edu',    '0243456789', 2021, 2.85, 'Resident',     'Active'),
('2425487231', 'Akosua',   'Darko',     'Female', '2003-05-18', '300', 'Telecommunication Engineering',        'akosua.darko@student.edu',    '0244567890', 2021, 3.20, 'Non-Resident', 'Active'),
('2425653908', 'Yaw',      'Amponsah',  'Male',   '2004-09-30', '200', 'Computer Science',        'yaw.amponsah@student.edu',    '0245678901', 2022, 1.95, 'Resident',     'Active'),
('2425820416', 'Ama',      'Frimpong',  'Female', '2004-11-05', '200', 'Computer Engineering',          'ama.frimpong@student.edu',    '0246789012', 2022, 3.60, 'Resident',     'Active'),
('2425741852', 'Kweku',    'Owusu',     'Male',   '2005-02-14', '100', 'Electrical Engineering',        'kweku.owusu@student.edu',     '0247890123', 2023, 2.50, 'Non-Resident', 'Active'),
('2425036974', 'Efua',     'Asiedu',    'Female', '2005-06-25', '100', 'Computer Engineering',          'efua.asiedu@student.edu',     '0248901234', 2023, 3.10, 'Resident',     'Active'),
('2425295180', 'Nana',     'Acheampong','Male',   '2001-04-08', '400', 'Data Science',             'nana.acheampong@student.edu', '0249012345', 2019, 3.90, 'Resident',     'Graduated'),
('2425463729', 'Adwoa',    'Bonsu',     'Female', '2001-08-17', '400', 'Computer Engineering',          'adwoa.bonsu@student.edu',      NULL,        2019, 2.40, 'Non-Resident', 'Graduated'),
('2425817364', 'Fiifi',    'Mensah',    'Male',   '2002-12-03', '400', 'Telecommunications Engineering','fiifi.mensah@student.edu',    '0240123456', 2020, 1.80, 'Resident',     'Deferred'),
('2425502843', 'Araba',    'Brew',      'Female', '2003-03-27', '300', 'Electrical Engineering',        'araba.brew@student.edu',      '0251234567', 2021, 3.45, 'Resident',     'Active'),
('2425671590', 'Kwabena',  'Appiah',    'Male',   '2004-07-19', '200', 'Computer Science',        'kwabena.appiah@student.edu',  '0252345678', 2022, 2.70, 'Non-Resident', 'Active'),
('2425389017', 'Maame',    'Sarpong',   'Female', '2005-10-11', '100', 'Computer Science',        'maame.sarpong@student.edu',   '0253456789', 2023, 3.80, 'Resident',     'Active'),
('2425924681', 'Kojo',     'Asare',     'Male',   '2002-05-29', '400', 'Computer Engineering',          'kojo.asare@student.edu',      '0254567890', 2020, 3.55, 'Non-Resident', 'Active'),
('2425158342', 'Akua',     'Manu',      'Female', '2003-09-14', '300', 'Computer Science',             'akua.manu@student.edu',        NULL,        2021, 2.10, 'Resident',     'Deferred'),
('2425736408', 'Bright',   'Antwi',     'Male',   '2004-01-23', '200', 'Electrical Engineering',        'bright.antwi@student.edu',    '0255678901', 2022, 3.30, 'Resident',     'Active'),
('2425043267', 'Abena',    'Amoah',     'Female', '2000-06-07', '400', 'Telecommunications Engineering','abena.amoah@student.edu',     '0256789012', 2019, 3.95, 'Non-Resident', 'Graduated'),
('2425615839', 'Samuel',   'Boadu',     'Male',   '2005-04-16', '100', 'Computer Engineering',          'samuel.boadu@student.edu',    '0257890123', 2023, 1.60, 'Non-Resident', 'Active'),
('2425279456', 'Serwa',    'Nyarko',    'Female', '2004-08-20', '200', 'Data Science',        'serwa.nyarko@student.edu',    '0258901234', 2022, 2.95, 'Resident',     'Active');
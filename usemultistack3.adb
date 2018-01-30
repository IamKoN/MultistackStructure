with multistack3;
with Ada.Text_IO; use Ada.Text_IO;

procedure usemultistack3 is
   package IIO is new Ada.Text_IO.Integer_IO(integer); use IIO;
   
   type StackType IS (Name, Date); 
   package Stack_IO is new Ada.Text_IO.Enumeration_IO(StackType); use Stack_IO;
    --Date Stack	
   type MonthName is (January, February, March, April, May, June, July,
                      August, September, October, November, December);
   
   package MonthName_IO is new Ada.Text_IO.Enumeration_IO(MonthName);
   
   type DateType is record
      Month: MonthName;
      Day: Integer range 1..31;
      Year: Integer range 1400..2020;
   end record;
	
   procedure GetDate(X: in out DateType) is begin
      MonthName_IO.get(X.Month);
      IIO.get(X.Day);
      IIO.get(X.Year);
   end GetDate;
	
   procedure PutDate(X: DateType) is begin
      MonthName_IO.put(X.Month); put(" ");
      IIO.put(X.Day, 0); put(", ");
      IIO.put(X.Year, 0);
   end PutDate;
	
   function DateToString(X: DateType) return String is begin
      return X.month'Image & " " & X.day'Image & ", " & X.year'Image;
   end DateToString;
	
   package DateStack is new multistack3(DateType, "DateInput.text", "DateOutput.txt", GetDate, PutDate, DateToString); use DateStack;
  
   --Name Stack
   type NameType is (Burris, Zhou, Shashidhar, Lester, Arcos, Yang, Wei, Rabieh, Song, Cho,
                     Varol, Karabiyik, Cooper, Smith, McGuire, Najar, An, Deering, Hope, Pray, NoHope);
   
   package NameType_IO is new Ada.Text_IO.Enumeration_IO(NameType); use NameType_IO;

   procedure GetName(X: in out NameType) is begin NameType_IO.get(X); end GetName;
	
   procedure PutName(X: NameType) is begin NameType_IO.put(X); end PutName;
	
   function NameToString(X: NameType) return String is begin return X'Image; end NameToString;
   
   package NameStack is new multistack3(NameType, "NameInput.txt", "NameOutput.txt", GetName, PutName, NameToString);
   

begin
   --I1 Burris, I2 Zhou, I2 Shashidhar, I3 Deering, I2 An, I2 Deering, I3 Lester,
   --I1 Yang, I3 Smith, I2 Wei, I2 Zhou, ***I2 Arcos, D2, I1 Wei, I2 Rabieh, D1, D1,
   --I2 Song, I2 Cho, D3, I2 Varol, I3 Karabiyik, I1 Cooper, I1 Smith, I1 McGuire,
   --I3 Najar, I2 An, I1 Zhou, D2,  I2 Deering, I1 Burris, I2 Cho, I2 McGuire,
   --I3 Hope, I3 Pray, I3 NoHope
   
   --I2 January 15 1956;  I2 February 14 1957;  I3 September 16 1946;  
   --I2 September 17 1842;  I2 April 1 2015; I1 December 24 1996,  D1, I3 March 16 1992;  
   --D1;  I2 January 15 1956;  I3 April 4 1492;  I3 November 7 1776;  
   --I3 June 12 1994;  I2 July 4 1776;  I2 January 15 2012;  I3 December 6 1991;
   --I3 March 5 1886;  I1 October 24 1996;  I1 November 23 1996;  I1 November 2 1990;
   --I3 September 14 1998
   null;  
end usemultistack3;

with Ada.Text_IO; use Ada.Text_IO;

package body multistack3 is
   
   subtype OCstring is String(1..25);

   package IIO is new Ada.Text_IO.Integer_IO(integer); use IIO;
   package FIIO is new Ada.Text_IO.Float_IO(Float); use FIIO;


   -- Input text file can specify allocation of space
   function fileSize return Integer is
      InputFile: File_Type;
      retFileSize: Integer:= 0;
   begin
      Open(InputFile, In_File, InFileName);
      while not End_Of_File(InputFile) loop
         declare
            Line: String:= Get_Line(InputFile);
         begin
            retFileSize:= retFileSize + Integer'Value(Line);
         end;
      end loop;
      Close(InputFile);
      return retFileSize;
   end fileSize;
   
   --overload floor function
   function floor(X: float) return integer is
      temp: integer;
   begin
      temp := integer(X);
      if (float(temp) <= X) then return temp;
      else return temp - 1; end if;
   end floor;
   
   --set and get lower array index
   function lowerArraySubscript return integer is
      OutFile: File_Type;
      lowerSub: Integer;
   begin
      Create(OutFile, Append_File, OutFileName);
      put("Lower index for array: "); put(OutFile,"Lower index for array: ");
      get(lowerSub); put(OutFile, lowerSub'Image); Close(OutFile); return lowerSub;
   end lowerArraySubscript;
	
   --set and get upper array index
   function upperArraySubscript return integer is
      OutFile: File_Type;
      upperSub: integer;
   begin
      Open(OutFile, Append_File, OutFileName);
      put("Upper index for array: "); put(OutFile,"Upper index for array: ");
      get(upperSub); put(OutFile, upperSub'Image); Close(OutFile); return upperSub;
   end upperArraySubscript;

   --set and get number of stacks in array
   function stackCount return integer is
      OutFile: File_Type;
      stkCount: integer;
   begin
      Open(OutFile, Append_File, OutFileName);
      put("Number of stacks for array: "); put(OutFile, "Number of stacks for array: ");
      get(stkCount); put(OutFile, stkCount'Image); Close(OutFile); return stkCount;
   end stackCount;

   --reallocate memory in the array to make space for each stack
   function reallocate(StackSpace: in out newTypeArray; OneArray: in out intArray;
                       Base: in out intArray; Top: in out intArray; L: integer; M: integer;
                       N: integer; K: integer; input: newType) return boolean is
	
      J: integer := N;
      AvailSpace, temp: integer;
      TotalInc: integer := 0;
      MinSpace: integer := floor(0.07*(float(M) - float(L)));
      
      equalAllocate: Float := 0.13;
      growthAllocate: Float := 0.87;
      Alpha, Beta, Sigma, Tau: Float := 0.0;
      
      OutFile: File_Type;
      
   begin
      --Reallocate Algorithm 1
      --------------------------
      Put("Current values of Base, Top, OldTop"); New_Line;
      for i in 1..n loop
         Put("Stack #: "); put(i,1); Put(", Base: "); put(Base(i),1); Put(",Top: ");
         put(Top(i),1); put(", OldTop: "); put(OneArray(i),1); New_Line;
      end loop;
      
      if MinSpace = 0 then MinSpace := 1; end if;
      AvailSpace := M - L;
      while J > 0 loop
         AvailSpace := AvailSpace - (Top(J) - Base(J));
         if Top(J) > OneArray(J) then
            OneArray(J) := Top(J) - OneArray(J);
            TotalInc := TotalInc + OneArray(J);
         else
            OneArray(J) := 0;
         end if;
         J := J - 1;
      end loop;
      
      --Reallocate Algorithm 2
      New_Line; put("Available space:" & Integer'Image(Availspace)); 
      put(", Minimum space:" & Integer'Image(Minspace)); New_Line;

      if AvailSpace < (MinSpace - 1) then
         for j in base(1)+1..base(base'Last) loop
            put("Location" & Integer'Image(j) & " is ");
            put((StackSpace(j))); New_Line;                      
         end loop;       
         --raise Program_Error;
      
         put("Insufficent memory to repack, stopping..."); New_Line;
         Open(OutFile, Append_File, OutFileName); put_Line(OutFile, "");
         put(OutFile, "Insufficent memory to repack, stopping..."); Close(OutFile);
         return false;
      end if;
      
      --Reallocate Algorithm 3
      Alpha := equalAllocate * float(AvailSpace) / float(N);
      
      --Reallocate Algorithm 4
      Beta := growthAllocate * float(AvailSpace) / float(TotalInc);
      
      --Reallocate Algorithm 5
      Sigma := 0.0;
      temp := OneArray(1);
      OneArray(1) := Base(1);
      for J in 2..N loop
         Tau := Sigma + Alpha + float(temp)*Beta; temp := OneArray(J);
         OneArray(J) := OneArray(J-1) + Top(J-1) - Base(J-1) + floor(Tau) - floor(Sigma);
         Sigma := Tau;
      end loop;
      
      --Reallocate Algorithm 6
      Top(K) := Top(K) - 1;
      movestack(StackSpace, OneArray, Top, Base, N);
      Top(K) := Top(K) + 1;
      StackSpace(Top(K)) := input;
      
      Put("Preparing for next overflow: printing new base and top"); 
      for J in 1..N loop
         Put("Stack #: "); put(j,1); Put(", Base: "); put(base(j),1); Put(",Top: "); put(top(j),1);
         New_Line; OneArray(J) := Top(J);
      end loop;
      return true;
   end reallocate;
   
   procedure movestack(StackSpace: in out newTypeArray; OneArray: intArray;
                       Top: in out intArray; Base: in out intArray; N: integer) is
      Delt: integer;
   begin
      --MoveStack Algorithm 1               
      for J in 2..N loop
         if OneArray(J) < Base(J) then
            Delt := Base(J) - OneArray(J);
            for L in (Base(J)+1)..Top(J) loop
               StackSpace(L - Delt) := StackSpace(L);
            end loop;
            Base(J) := OneArray(J);
            Top(J) := Top(J) - Delt;
         end if;
      end loop;
      
      --MoveStack Algorithm 2
      for J in reverse 2..N loop
         if OneArray(J) > Base(J) then
            Delt := OneArray(J) - Base(J);
            for L in reverse (Base(J)+1)..Top(J) loop --(Top(J)-1)--(Base(J)+1)
               StackSpace(L + Delt) := StackSpace(L);
            end loop;
            Base(J) := OneArray(J);
            Top(J) := Top(J) + Delt;
         end if;
      end loop;
   end movestack;
   
   procedure print(StackSpace: newTypeArray; L: integer; M: integer; N: integer;
                   Base: intArray; Top: intArray; OneArray: intArray) is
      OutFile: File_Type;
   begin
      Open(OutFile, Append_File, OutFileName);
      for J in 1..N+1 loop
         put("Base["); put(J,0); put("]: "); put(Base(J),0); put("  ");
         put(OutFile, "Base["); put(OutFile, J'Image); put(OutFile, "]: ");
         put(OutFile, Base(J)'Image); put(OutFile, "  ");
         if J <= N then
            put("Top["); put(J,0); put("]: "); put(Top(J),0); put("  ");
            put(OutFile, "Top["); put(OutFile, J'Image); put(OutFile, "]: ");
            put(OutFile, Top(J)'Image); put(OutFile, "  ");
            put("OldTop["); put(J,0); put("]: "); put(OneArray(J),0); put("  ");
            put(OutFile, "OldTop["); put(OutFile, J'Image); put(OutFile, "]: ");
            put(OutFile, OneArray(J)'Image); put_line(OutFile, "  ");
         end if; new_line;
      end loop;
      put_line(OutFile, ""); put_line(OutFile, ""); new_line;
		
      for j in 1..N loop
         for i in Base(j)+1..Top(j) loop
            if i <= Base(j+1) then
               put(i,0); put(": "); put(StackSpace(i)); new_line;
               put(OutFile, i'Image); put(OutFile, ": ");
               put_line(OutFile, convert(StackSpace(i)));
            end if;
         end loop;
         for i in Top(j)+1..Base(j+1) loop
            put(i,0); put(":"); put(" "); new_line;
            put(OutFile, i'Image); put(OutFile, ":"); put_line(OutFile, " ");
         end loop;
      end loop;
      Close(OutFile);
      new_line;
   end print;
   
   procedure useStack is
      StackSpace: newTypeArray(lowerArraySubscript..upperArraySubscript);
      N: integer := stackCount;
      L, M, K: integer;
		
      Base: intArray(1..N + 1);
      Top: intArray(1..N);
      OneArray: intArray(1..N + 1);		--holds OldTop, Growth, and NewBase

      opcode, temp: String := "  ";
      input: newType;		
      OutFile, InputFile: File_Type;

   begin
      Open(OutFile, Append_File, OutFileName);
      --Open(InputFile, In_File, InFileName);
     
      put("Lower index for stacks: "); put(OutFile, "Lower index for stacks: ");
      IIO.get(L); put_line(OutFile, L'Image);
      put("Upper index for stacks: "); put(OutFile, "Upper index for stacks: ");
      IIO.get(M); put_Line(OutFile, M'Image); put_line(OutFile, "");

      New_Line; Put("Stacks Initialized.");
      
      for J in 1..N loop
         Base(j) := floor((float(J)-1.0)/float(N)*(float(M) - float(L))) + L;
         Top(j) := Base(J); OneArray(J) := Top(J); New_Line;
         Put("Stack #: "); put(j,1); put(", Base: "); put(Base(j),1); put(", Top: "); put(Top(j),1);
      end loop;
      Base(N + 1) := M;
      OneArray(N + 1) := M;
		
      new_line; put("Begin Opcodes, type 'EX' to quit: ");
      new_line; put(OutFile, "Begin Opcodes, type 'EX' to quit: "); Close(OutFile);

      while opcode /= "EX" loop		
         put("Opcode: "); Open(OutFile, Append_File, OutFileName);
         put_line(OutFile, "Opcode: "); Ada.Text_IO.get(opcode);
         put(OutFile, opcode); put(OutFile, " ");    

         if opcode(1) = 'I' then
            get(input);
            put(OutFile, convert(input));
            put_Line(OutFile, ""); put_Line(OutFile, "");
            temp(1) := opcode(2);
            K := Integer'Value(temp);
            
            --insert item
            Top(K) := Top(K) + 1;
            if Top(K) > Base(K + 1) then
               put("Overflow occured, reallocating..."); new_line;
               put_line(OutFile, "Overflow occured, reallocating..."); put_Line(OutFile, "");
               put_line(OutFile, "--------Before--------"); Close(OutFile);
               print(StackSpace, L, M, N, Base, Top, OneArray);
              
               --Reallocate used to see if space can taken from another stack
               if reallocate(StackSpace, OneArray, Base, Top, L, M, N, K, input) = false then
                  opcode := "EX";
               end if;
               
               if opcode /= "EX" then
                  Open(OutFile, Append_File, OutFileName); put_line(OutFile, "");
                  put_line(OutFile, "--------After--------"); Close(OutFile);
                  print(StackSpace, L, M, N, Base, Top, OneArray);
                  
                  Open(OutFile, Append_File, OutFileName);
                  put_line(OutFile, ""); Close(OutFile);
               end if;
            else
               StackSpace(Top(K)) := input; Close(OutFile);
            end if;
         end if;
         
         if opcode(1) = 'D' then
            temp(1) := opcode(2);
            K := Integer'Value(temp);
            
            --Delete item
            if Top(K) = Base(K) then
               put("Underflow occured, empty stack"); new_line;
               put_Line(OutFile, ""); put_Line(OutFile, "");
               put_line(OutFile, "Underflow occured, empty stack");
               put_Line(OutFile, "");
            else
               put_Line(OutFile, ""); put_Line(OutFile, "");
               input := StackSpace(Top(K));
               Top(K) := Top(K) - 1;
            end if;
            Close(OutFile);
            end if; new_line;
         --end;
      end loop;
      --      end loop;
      --   end;
      --end LOOP;
      --Close(InputFile);
   end useStack;

begin
   useStack;
end multistack3;


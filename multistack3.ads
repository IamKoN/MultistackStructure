generic
   type newType is private;
   InFileName, OutFileName: String;
   with procedure get(X: in out newType); --pop
   with procedure put(X: newType); --push
   with function convert(X: newType) return String;
package multistack3 is

   type newTypeArray is array(Integer range <>) of newType;
   type intArray is array(Integer range <>) of Integer;

   function fileSize return Integer;
   function floor(X: float) return Integer;
   function lowerArraySubscript return Integer;
   function upperArraySubscript return Integer;
   function stackCount return Integer;

   function reallocate(StackSpace: in out newTypeArray;
                       OneArray: in out intArray;
                       Base: in out intArray;
                       Top: in out intArray;
                       L: Integer; M: Integer; N: Integer; K: Integer;
                       input: newType) return Boolean;
   procedure movestack(StackSpace: in out newTypeArray;
                       OneArray: intArray;
                       Top: in out intArray;
                       Base: in out intArray;
                       N: Integer);
   procedure print(StackSpace: newTypeArray;
                   L: Integer;
                   M: Integer;
                   N: Integer;
                   Base: intArray;
                   Top: intArray;
                   OneArray: intArray);
   procedure useStack;
end multistack3;

program lab7;
{$APPTYPE CONSOLE}

uses
  SysUtils;

Const
  N = 9;

Type
  Tarr = array [1 .. N] of integer;

Var
  Arr: Tarr;
  i: integer;
  sum: integer;

begin
  randomize;

  for i := Low(Arr) to High(Arr) do
  begin
    Arr[i] := random(400);
    write(Arr[i]:8);
  end;

  sum := 0;

  asm
    mov ebx, 0 // start with a[1]
    mov ecx, N/2 + 1
    mov eax, sum
    mov esi, 1

  @Sum:
    add eax, dword[Arr[ebx*4]]
    add ebx, 2
    loop @Sum
    mov dword[sum], eax
  end;

  writeln;
  write('Sum of elems: ');
  for i := 1 to N - 2 do
  begin
    if (i mod 2) <> 0 then
    begin
      write(Arr[i], '+');
    end;
  end;

  if (N mod 2 = 0) then
  begin
    write(Arr[N - 1], '=');
  end
  else
  begin
    write(Arr[N], '=');
  end;
  writeln(sum);
  readln;

end.

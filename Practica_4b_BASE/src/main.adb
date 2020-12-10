with ada.Integer_Text_IO; use ada.Integer_Text_IO;
with ada.text_io; use ada.text_io;
with data; use data;

procedure Main is
   Num_tasks: integer:=0;
   Num_Conjunto: integer;
   tipe_RM: boolean:=true;

begin  --Hay que indicar el numero de tareas que tendr� el conjunto
   loop
   Put("Introduzca el numero de tareas del conjunto (3 � 4): ");
   Get(Num_tasks);
      exit when Num_tasks=3 or Num_tasks=4;
   end loop;
   declare 
      tareas:task_set(1..Num_tasks);
   begin 
      
   inicializar(tareas); --Pone todos los valores a cero
   Put("Introduzca el numero del conjunto [1..4]: ");
   Get(Num_Conjunto);

   conjuntos(tareas, Num_Conjunto, Num_tasks); --Establece los valores de las tareas
   
   Put_line ("Programa que calcula si las siguientes tareas son planificables");  
   -- imprimir parametros temporales de tareas 
      imprimir(tareas);
   -- Se comprueba si todos los periodos = deadlines  
   for i in 1..Num_tasks loop
      if (params(tareas(i), 'T') /= params(tareas(i), 'D')) then
            tipe_RM := false;
      end if;
   end loop; 
      -- si periodos = deadlines
      if tipe_RM then
         Put_Line("D = T");
      end if;
      
   --      test del factor de utilizacion 
   --      si test utilizacion dice que no es planificable
   --        test del peor tiempo de respuesta 
   -- si no  
   --      test del peor tiempo de respuesta  

   end;
end Main;
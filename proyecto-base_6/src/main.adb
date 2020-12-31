-- Trabajo 2:Planificador FCFS; por Sergio Bou Grau
with schedule_output_functions; use schedule_output_functions;
with ada.Integer_Text_IO; use ada.Integer_Text_IO;
with text_io; use text_io;
with data; use data;

procedure Main is

   -- prioridad de tereas por �ndice m�s bajo
   -- �ndice de tarea activa, si 0 no hay
   taskactiva:integer:=-1;
   -- numero de tareas --
   num_tasks: integer:=0;
   -- numero de instantes del cronograma
   exec:integer:=0; -- poner a 0 cuando se empiece el trabajo   
   -- Datos de eventos aperi�dicos
   -- numero de eventos aperiodicos
   num_aperiodic: integer:=0;
   -- unidades de computo del evento aperiodico
   wcet_aperiodic: integer:=0;
   
begin
      loop
         Put("Introduzca el n�mero de tareas del conjunto [1..9]: ");
         Get(num_tasks);
      exit when num_tasks>0 and num_tasks<10;
      end loop;

      loop
         Put("Introduzca el n�mero de eventos aperi�dicos [1..9]: ");
         Get(num_aperiodic);
      exit when num_aperiodic>0 and num_aperiodic<10;
      end loop;
   declare 
      -- El vector de tareas --
      wcet:v_enteros(1..num_tasks);
      deadline:v_enteros(1..num_tasks);
      period:v_enteros(1..num_tasks);
   -- vector de tiempos de ocurrencia de eventos aperiodicos
      eventstime:v_enteros(1..num_aperiodic);
   -- vector con estados de las tareas: 1= activa, 0 inactiva
      tasksstate:v_enteros(1..num_tasks);
   -- vector con el valor actualizado del tiempo de computo   
      real_WCET:v_enteros(1..num_tasks);
   -- vector con tareas ordenadas por prioridad
      rowtasks:v_enteros(1..num_tasks);
      
      taskgroup:v_taskgroup(1..num_tasks);
   begin 
   -- Introducimos los datos de las tareas aqui a mano o elegimos uno conjunto predefinido
   -- Mejora: se pueden pedir por teclado
      SetNumTasks(num_tasks);
      Setdata(wcet,deadline,period);
 
   -- Introducimos los datos de computo aperi�dico 
   -- y tiempos en los que suceden los eventos
   -- Mejora: se pueden pedir por teclado   
      wcet_aperiodic:=SetTimeEvents(eventstime);
   -- Se muestra por pantalla los valores de las tareas   
      Imprimir(wcet,deadline,period);
   -- Se muestra por pantalla los tiempos de los eventos aperi�dicos
      ImprimirET(wcet_aperiodic,eventstime);
      --Inicializar lo que haga falta
      Inittasks(taskgroup,wcet,deadline,period);
      for i in 1..num_tasks loop
         tasksstate(i):=0;
         rowtasks(i):=0;
      end loop;
      -- copio tiempos de computo para manejarlos
      real_WCET:=wcet;
      -- Planificacion -----------------------------------------------------
      for time in 0..100 loop     
         -- Actualizar tareas activas
         Estadotareas(time,taskgroup);
         --rowtasks:=Setpriority(tasksstate,rowtasks);     
         -- muestra por consola el tiempo y el estado de las tareas
         ShowStateTasks(time,taskgroup);
                
         -- Ver si hay algun evento aperiodico activado en este tiempo
         -- Si hay evento aperiodico, decidir que hacer. Si se elige para
         -- ejecutar la tarea aperiodica entonces task_id=0
              
         -- Si no hay nigun evento aperiodico,
         --    elegir la tarea seg�n el algoritmo de planificacion
         --    considerar el caso de que no haya ninguna activa
         -- Escribir en chrono 
         if taskactiva/=-1 then
            exec:=exec+1;
            chrono(exec).task_id:=Getpriority;
            chrono(exec).start:=time;
            chrono(exec).finish:=chrono(exec).start +1;
         end if;
         -- Decrementar computo pendiente de la tarea elegida 
         --    y si llega a cero, suspenderla            
         --real_WCET:=Refreshcomput(tasksstate,wcet,real_WCET);
      end loop;
      --------------------------
      -- Y lo escribimos en un fichero
      for i in chrono'Range loop
         Put(chrono(i).task_id);Put(chrono(i).start);New_Line;
      end loop;
      write_chronogram(period, deadline, chrono, num_tasks, exec, "test.svg");
      Put_line("Cronograma generado en test.svg");
   end;
end Main;


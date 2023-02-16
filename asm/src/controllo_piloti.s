.section .data

pilot_0_str:
  .string "Pierre Gasly\0"
pilot_0_str_len:
  .long . -pilot_0_str

pilot_1_str:
  .string "Charles Leclerc\0"
pilot_1_str_len:
  .long . -pilot_1_str

pilot_2_str:
  .string "Max Verstappen\0"
pilot_2_str_len:
  .long . -pilot_2_str

pilot_3_str:
  .string "Lando Norris\0"
pilot_3_str_len:
  .long . -pilot_3_str

pilot_4_str:
  .string "Sebastian Vettel\0"
pilot_4_str_len:
  .long . -pilot_4_str

pilot_5_str:
  .string "Daniel Ricciardo\0"
pilot_5_str_len:
  .long . -pilot_5_str

pilot_6_str: 
  .string "Lance Stroll\0"
pilot_6_str_len:
  .long . -pilot_6_str

pilot_7_str:
  .string "Carlos Sainz\0"
pilot_7_str_len:
  .long . -pilot_7_str

pilot_8_str:
  .string "Antonio Giovinazzi\0"
pilot_8_str_len:
  .long . -pilot_8_str

pilot_9_str:
  .string "Kevin Magnussen\0"
pilot_9_str_len:
  .long . -pilot_9_str

pilot_10_str:
  .string "Alexander Albon\0"
pilot_10_str_len:
  .long . -pilot_10_str

pilot_11_str:
  .string "Nicholas Latifi\0"
pilot_11_str_len:
  .long . -pilot_11_str

pilot_12_str:
  .string "Lewis Hamilton\0"
pilot_12_str_len:
  .long . -pilot_12_str

pilot_13_str:
  .string "Romain Grosjean\0"
pilot_13_str_len:
  .long . -pilot_13_str

pilot_14_str:
  .string "George Russell\0"
pilot_14_str_len:
  .long . -pilot_13_str

pilot_15_str:
  .string "Sergio Perez\0"
pilot_15_str_len:
  .long . -pilot_15_str

pilot_16_str:
  .string "Daniil Kvyat\0"
pilot_16_str_len:
  .long . -pilot_16_str

pilot_17_str:
  .string "Kimi Raikkonen\0"
pilot_17_str_len:
  .long . -pilot_17_str

pilot_18_str:
  .string "Esteban Ocon\0"
pilot_18_str_len:
  .long . -pilot_18_str

pilot_19_str:
  .string "Valtteri Bottas\0"
pilot_19_str_len:
  .long . -pilot_19_str

.section .text
.global controllo_piloti

.type controllo_piloti, @function

controllo_piloti:

  # Azzero il registro esi prima dell'utilizzo
  xorl %esi, %esi
  
  # Salvo in esi il puntatore al file input.txt
  movl 4(%ebp), %esi

# Arrivati a quersto punto, abbiamo in esi il puntatore a input.txt

# Per ogni pilot_*, se la posizione del carattere di terminazione '\0' della stringa pilot_*_str (file .s) coincide con la posizione del carattere a capo '\n' del file di input (file input.txt), allora passo a controllare i singoli caratteri per verificare l'ID pilota (con ciclo_*), altrimenti (se la lunghezza della stringa del file input.txt non corrisponde alla lunghezza della stringa pilot_*_str, è inutile fare il controllo dei singoli caratteri), passiamo al pilot_* successivo. Se tutti i controlli falliscono allora la stringa di input.txt non coincide con nessun pilot_*_str e passo a Invalid.

# Nota #
# ecx non viene modificato per input e stringa perchè l'offset di entrambi combacia essendo all'inizio sia della stringa di input che alla stringa di pilot_*

pilot_0:
  # Decremento per arrivare all'ultimo carattere della stringa pilot_* (senza '\0'))
  decl pilot_0_str_len
  decl pilot_0_str_len

  # Salvo in ecx l'offset per raggiungere '\0' della stringa pilot_0
  movl pilot_0_str_len, %ecx

  # Controllo che in esi (input.txt) + offset ci sia \n
  movb (%ecx, %esi, 1), %al

  # Controllo il carattere \n
  cmp $10, %al

  # Se non ho il carattere \n vado al prossimo pilota
  jne pilot_1

  # Altrimenti vado a ciclare
  # Salvo in edx l'ID del pilota
  movb $0, %dl

  # Azzero l'offset per il confronto
  xorl %ecx, %ecx

  ciclo_0:
    # Azzero il registro eax prima dell'utilizzo
    xorl %eax, %eax

    # Acquisisco in al il carattere puntato da esi+offset (ecx) nel file input.txt
    movb (%ecx, %esi, 1), %al

    # Salvo nello stack esi di input.txt
    pushl %esi

    # Azzero il registro esi prima dell'utilizzo
    xorl %esi, %esi

    # Salvo in esi l'indirizzo della stringa pilot_0
    leal pilot_0_str, %esi

    # Azzero il registro ebx prima dell'utilizzo
    xorl %ebx, %ebx

    # Acquisisco in bl il carattere puntato da esi+offset (ecx) nella stringa pilot_0
    movb (%ecx, %esi, 1), %bl

    # Operazioni da fare qui così abbiamo il valore di esi input già ripristinato prima dei salti #
    #
    # Azzero il registro esi prima dell'utilizzo
    xorl %esi, %esi

    # Recupero esi di input.txt dallo stack
    popl %esi
    #

    # Se il carattere di input.txt è uguale a '\n' (quindi se sono alla fine)
    cmp $10, %al

    # Ho finito il controllo e salto all'etichetta end
    je end

    # Altrimenti se non sono alla fine incremento ecx (per scorrere alla posizione successiva)
    incl %ecx

    # Confronto il carattere della stringa input.txt con il carattere della stringa pilota
    cmp %al, %bl

    # Se i caratteri non sono uguali vado all'etichetta del pilota successivo
    jne pilot_1

    # Se i caratteri sono uguali, torno a ciclo_0
    je ciclo_0

pilot_1:
  # Decremento per arrivare all'ultimo carattere della stringa pilot_* (senza '\0'))
  decl pilot_1_str_len
  decl pilot_1_str_len

  # Azzero il registro ecx prima dell'utilizzo
  xorl %ecx, %ecx

  # Salvo in ecx l'offset per raggiungere '\0' della stringa pilot_1
  movl pilot_1_str_len, %ecx

  # Azzero il registro eax prima dell'utilizzo
  xorl %eax, %eax

  # Controllo che in esi (input.txt) + offset ci sia \n
  movb (%ecx, %esi, 1), %al

  # Controllo il carattere \n
  cmp $10, %al

  # Se non ho il carattere \n vado al prossimo pilota
  jne pilot_2

  # Altrimenti vado a ciclare
  # Azzero il registro edx prima dell'utilizzo
  xorl %edx, %edx

  # Salvo in edx l'ID del pilota
  movb $1, %dl

  # Azzero l'offset (ecx) per il confronto
  xorl %ecx, %ecx

  ciclo_1:
    # Azzero il registro eax prima dell'utilizzo
    xorl %eax, %eax

    # Acquisisco in al il carattere puntato da esi+offset (ecx) nel file input.txt
    movb (%ecx, %esi, 1), %al

    # Salvo nello stack esi di input.txt
    pushl %esi

    # Azzero il registro esi prima dell'utilizzo
    xorl %esi, %esi

    # Salvo in esi l'indirizzo della stringa pilot_1
    leal pilot_1_str, %esi

    # Azzero il registro ebx prima dell'utilizzo
    xorl %ebx, %ebx

    # Acquisisco in bl il carattere puntato da esi+offset (ecx) nella stringa pilot_1
    movb (%ecx, %esi, 1), %bl

    # Operazioni da fare qui così abbiamo il valore di esi input già ripristinato prima dei salti #
    #
    # Azzero il registro esi prima dell'utilizzo
    xorl %esi, %esi

    # Recupero esi di input.txt dallo stack
    popl %esi
    #

    # Se il carattere di input.txt è uguale a '\n' (quindi se sono alla fine)
    cmp $10, %al

    # Ho finito il controllo e salto all'etichetta end
    je end

    # Altrimenti se non sono alla fine incremento ecx (per scorrere alla posizione successiva)
    incl %ecx

    # Confronto il carattere della stringa input.txt con il carattere della stringa pilota
    cmp %al, %bl

    # Se i caratteri non sono uguali vado all'etichetta del pilota successivo
    jne pilot_2

    # Se i caratteri sono uguali, torno a ciclo_1
    je ciclo_1

pilot_2:
  # Decremento per arrivare all'ultimo carattere della stringa pilot_* (senza '\0'))
  decl pilot_2_str_len
  decl pilot_2_str_len

  # Azzero il registro ecx prima dell'utilizzo
  xorl %ecx, %ecx

  # Salvo in ecx l'offset per raggiungere '\0' della stringa pilot_2
  movl pilot_2_str_len, %ecx

  # Azzero il registro eax prima dell'utilizzo
  xorl %eax, %eax

  # Controllo che in esi (input.txt) + offset ci sia \n
  movb (%ecx, %esi, 1), %al

  # Controllo il carattere \n
  cmp $10, %al

  # Se non ho il carattere \n vado al prossimo pilota
  jne pilot_3

  # Altrimenti vado a ciclare
  # Azzero il registro edx prima dell'utilizzo
  xorl %edx, %edx

  # Salvo in edx l'ID del pilota
  movb $2, %dl

  # Azzero l'offset (ecx) per il confronto
  xorl %ecx, %ecx

  ciclo_2:
    # Azzero il registro eax prima dell'utilizzo
    xorl %eax, %eax

    # Acquisisco in al il carattere puntato da esi+offset (ecx) nel file input.txt
    movb (%ecx, %esi, 1), %al

    # Salvo nello stack esi di input.txt
    pushl %esi

    # Azzero il registro esi prima dell'utilizzo
    xorl %esi, %esi

    # Salvo in esi l'indirizzo della stringa pilot_2
    leal pilot_2_str, %esi

    # Azzero il registro ebx prima dell'utilizzo
    xorl %ebx, %ebx

    # Acquisisco in bl il carattere puntato da esi+offset (ecx) nella stringa pilot_2
    movb (%ecx, %esi, 1), %bl

    # Operazioni da fare qui così abbiamo il valore di esi input già ripristinato prima dei salti #
    #
    # Azzero il registro esi prima dell'utilizzo
    xorl %esi, %esi

    # Recupero esi di input.txt dallo stack
    popl %esi
    #

    # Se il carattere di input.txt è uguale a '\n' (quindi se sono alla fine)
    cmp $10, %al

    # Ho finito il controllo e salto all'etichetta end
    je end

    # Altrimenti se non sono alla fine incremento ecx (per scorrere alla posizione successiva)
    incl %ecx

    # Confronto il carattere della stringa input.txt con il carattere della stringa pilota
    cmp %al, %bl

    # Se i caratteri non sono uguali vado all'etichetta del pilota successivo
    jne pilot_3

    # Se i caratteri sono uguali, torno a ciclo_2
    je ciclo_2

pilot_3:
  # Decremento per arrivare all'ultimo carattere della stringa pilot_* (senza '\0'))
  decl pilot_3_str_len
  decl pilot_3_str_len

  # Azzero il registro ecx prima dell'utilizzo
  xorl %ecx, %ecx

  # Salvo in ecx l'offset per raggiungere '\0' della stringa pilot_3
  movl pilot_3_str_len, %ecx

  # Azzero il registro eax prima dell'utilizzo
  xorl %eax, %eax

  # Controllo che in esi (input.txt) + offset ci sia \n
  movb (%ecx, %esi, 1), %al

  # Controllo il carattere \n
  cmp $10, %al

  # Se non ho il carattere \n vado al prossimo pilota
  jne pilot_4

  # Altrimenti vado a ciclare
  # Azzero il registro edx prima dell'utilizzo
  xorl %edx, %edx

  # Salvo in edx l'ID del pilota
  movb $3, %dl

  # Azzero l'offset (ecx) per il confronto
  xorl %ecx, %ecx

  ciclo_3:
    # Azzero il registro eax prima dell'utilizzo
    xorl %eax, %eax

    # Acquisisco in al il carattere puntato da esi+offset (ecx) nel file input.txt
    movb (%ecx, %esi, 1), %al

    # Salvo nello stack esi di input.txt
    pushl %esi

    # Azzero il registro esi prima dell'utilizzo
    xorl %esi, %esi

    # Salvo in esi l'indirizzo della stringa pilot_3
    leal pilot_3_str, %esi

    # Azzero il registro ebx prima dell'utilizzo
    xorl %ebx, %ebx

    # Acquisisco in bl il carattere puntato da esi+offset (ecx) nella stringa pilot_3
    movb (%ecx, %esi, 1), %bl

    # Operazioni da fare qui così abbiamo il valore di esi input già ripristinato prima dei salti #
    #
    # Azzero il registro esi prima dell'utilizzo
    xorl %esi, %esi

    # Recupero esi di input.txt dallo stack
    popl %esi
    #

    # Se il carattere di input.txt è uguale a '\n' (quindi se sono alla fine)
    cmp $10, %al

    # Ho finito il controllo e salto all'etichetta end
    je end

    # Altrimenti se non sono alla fine incremento ecx (per scorrere alla posizione successiva)
    incl %ecx

    # Confronto il carattere della stringa input.txt con il carattere della stringa pilota
    cmp %al, %bl

    # Se i caratteri non sono uguali vado all'etichetta del pilota successivo
    jne pilot_4

    # Se i caratteri sono uguali, torno a ciclo_3
    je ciclo_3

pilot_4:
  # Decremento per arrivare all'ultimo carattere della stringa pilot_* (senza '\0'))
  decl pilot_4_str_len
  decl pilot_4_str_len

  # Azzero il registro ecx prima dell'utilizzo
  xorl %ecx, %ecx

  # Salvo in ecx l'offset per raggiungere '\0' della stringa pilot_4
  movl pilot_4_str_len, %ecx

  # Azzero il registro eax prima dell'utilizzo
  xorl %eax, %eax

  # Controllo che in esi (input.txt) + offset ci sia \n
  movb (%ecx, %esi, 1), %al

  # Controllo il carattere \n
  cmp $10, %al

  # Se non ho il carattere \n vado al prossimo pilota
  jne pilot_5

  # Altrimenti vado a ciclare
  # Azzero il registro edx prima dell'utilizzo
  xorl %edx, %edx

  # Salvo in edx l'ID del pilota
  movb $4, %dl

  # Azzero l'offset (ecx) per il confronto
  xorl %ecx, %ecx

  ciclo_4:
    # Azzero il registro eax prima dell'utilizzo
    xorl %eax, %eax

    # Acquisisco in al il carattere puntato da esi+offset (ecx) nel file input.txt
    movb (%ecx, %esi, 1), %al

    # Salvo nello stack esi di input.txt
    pushl %esi

    # Azzero il registro esi prima dell'utilizzo
    xorl %esi, %esi

    # Salvo in esi l'indirizzo della stringa pilot_4
    leal pilot_4_str, %esi

    # Azzero il registro ebx prima dell'utilizzo
    xorl %ebx, %ebx

    # Acquisisco in bl il carattere puntato da esi+offset (ecx) nella stringa pilot_4
    movb (%ecx, %esi, 1), %bl

    # Operazioni da fare qui così abbiamo il valore di esi input già ripristinato prima dei salti #
    #
    # Azzero il registro esi prima dell'utilizzo
    xorl %esi, %esi

    # Recupero esi di input.txt dallo stack
    popl %esi
    #

    # Se il carattere di input.txt è uguale a '\n' (quindi se sono alla fine)
    cmp $10, %al

    # Ho finito il controllo e salto all'etichetta end
    je end

    # Altrimenti se non sono alla fine incremento ecx (per scorrere alla posizione successiva)
    incl %ecx

    # Confronto il carattere della stringa input.txt con il carattere della stringa pilota
    cmp %al, %bl

    # Se i caratteri non sono uguali vado all'etichetta del pilota successivo
    jne pilot_5

    # Se i caratteri sono uguali, torno a ciclo_4
    je ciclo_4

pilot_5:
  # Decremento per arrivare all'ultimo carattere della stringa pilot_* (senza '\0'))
  decl pilot_5_str_len
  decl pilot_5_str_len

  # Azzero il registro ecx prima dell'utilizzo
  xorl %ecx, %ecx

  # Salvo in ecx l'offset per raggiungere '\0' della stringa pilot_5
  movl pilot_5_str_len, %ecx

  # Azzero il registro eax prima dell'utilizzo
  xorl %eax, %eax

  # Controllo che in esi (input.txt) + offset ci sia \n
  movb (%ecx, %esi, 1), %al

  # Controllo il carattere \n
  cmp $10, %al

  # Se non ho il carattere \n vado al prossimo pilota
  jne pilot_6

  # Altrimenti vado a ciclare
  # Azzero il registro edx prima dell'utilizzo
  xorl %edx, %edx

  # Salvo in edx l'ID del pilota
  movb $5, %dl

  # Azzero l'offset (ecx) per il confronto
  xorl %ecx, %ecx

  ciclo_5:
    # Azzero il registro eax prima dell'utilizzo
    xorl %eax, %eax

    # Acquisisco in al il carattere puntato da esi+offset (ecx) nel file input.txt
    movb (%ecx, %esi, 1), %al

    # Salvo nello stack esi di input.txt
    pushl %esi

    # Azzero il registro esi prima dell'utilizzo
    xorl %esi, %esi

    # Salvo in esi l'indirizzo della stringa pilot_5
    leal pilot_5_str, %esi

    # Azzero il registro ebx prima dell'utilizzo
    xorl %ebx, %ebx

    # Acquisisco in bl il carattere puntato da esi+offset (ecx) nella stringa pilot_5
    movb (%ecx, %esi, 1), %bl

    # Operazioni da fare qui così abbiamo il valore di esi input già ripristinato prima dei salti #
    #
    # Azzero il registro esi prima dell'utilizzo
    xorl %esi, %esi

    # Recupero esi di input.txt dallo stack
    popl %esi
    #

    # Se il carattere di input.txt è uguale a '\n' (quindi se sono alla fine)
    cmp $10, %al

    # Ho finito il controllo e salto all'etichetta end
    je end

    # Altrimenti se non sono alla fine incremento ecx (per scorrere alla posizione successiva)
    incl %ecx

    # Confronto il carattere della stringa input.txt con il carattere della stringa pilota
    cmp %al, %bl

    # Se i caratteri non sono uguali vado all'etichetta del pilota successivo
    jne pilot_6

    # Se i caratteri sono uguali, torno a ciclo_5
    je ciclo_5

pilot_6:
  # Decremento per arrivare all'ultimo carattere della stringa pilot_* (senza '\0'))
  decl pilot_6_str_len
  decl pilot_6_str_len

  # Azzero il registro ecx prima dell'utilizzo
  xorl %ecx, %ecx

  # Salvo in ecx l'offset per raggiungere '\0' della stringa pilot_6
  movl pilot_6_str_len, %ecx

  # Azzero il registro eax prima dell'utilizzo
  xorl %eax, %eax

  # Controllo che in esi (input.txt) + offset ci sia \n
  movb (%ecx, %esi, 1), %al

  # Controllo il carattere \n
  cmp $10, %al

  # Se non ho il carattere \n vado al prossimo pilota
  jne pilot_7

  # Altrimenti vado a ciclare
  # Azzero il registro edx prima dell'utilizzo
  xorl %edx, %edx

  # Salvo in edx l'ID del pilota
  movb $6, %dl

  # Azzero l'offset (ecx) per il confronto
  xorl %ecx, %ecx

  ciclo_6:
    # Azzero il registro eax prima dell'utilizzo
    xorl %eax, %eax

    # Acquisisco in al il carattere puntato da esi+offset (ecx) nel file input.txt
    movb (%ecx, %esi, 1), %al

    # Salvo nello stack esi di input.txt
    pushl %esi

    # Azzero il registro esi prima dell'utilizzo
    xorl %esi, %esi

    # Salvo in esi l'indirizzo della stringa pilot_7
    leal pilot_7_str, %esi

    # Azzero il registro ebx prima dell'utilizzo
    xorl %ebx, %ebx

    # Acquisisco in bl il carattere puntato da esi+offset (ecx) nella stringa pilot_7
    movb (%ecx, %esi, 1), %bl

    # Operazioni da fare qui così abbiamo il valore di esi input già ripristinato prima dei salti #
    #
    # Azzero il registro esi prima dell'utilizzo
    xorl %esi, %esi

    # Recupero esi di input.txt dallo stack
    popl %esi
    #

    # Se il carattere di input.txt è uguale a '\n' (quindi se sono alla fine)
    cmp $10, %al

    # Ho finito il controllo e salto all'etichetta end
    je end

    # Altrimenti se non sono alla fine incremento ecx (per scorrere alla posizione successiva)
    incl %ecx

    # Confronto il carattere della stringa input.txt con il carattere della stringa pilota
    cmp %al, %bl

    # Se i caratteri non sono uguali vado all'etichetta del pilota successivo
    jne pilot_7

    # Se i caratteri sono uguali, torno a ciclo_7
    je ciclo_6

pilot_7:
  # Decremento per arrivare all'ultimo carattere della stringa pilot_* (senza '\0'))
  decl pilot_7_str_len
  decl pilot_7_str_len

  # Azzero il registro ecx prima dell'utilizzo
  xorl %ecx, %ecx

  # Salvo in ecx l'offset per raggiungere '\0' della stringa pilot_7
  movl pilot_7_str_len, %ecx

  # Azzero il registro eax prima dell'utilizzo
  xorl %eax, %eax

  # Controllo che in esi (input.txt) + offset ci sia \n
  movb (%ecx, %esi, 1), %al

  # Controllo il carattere \n
  cmp $10, %al

  # Se non ho il carattere \n vado al prossimo pilota
  jne pilot_8

  # Altrimenti vado a ciclare
  # Azzero il registro edx prima dell'utilizzo
  xorl %edx, %edx

  # Salvo in edx l'ID del pilota
  movb $7, %dl

  # Azzero l'offset (ecx) per il confronto
  xorl %ecx, %ecx

  ciclo_7:
    # Azzero il registro eax prima dell'utilizzo
    xorl %eax, %eax

    # Acquisisco in al il carattere puntato da esi+offset (ecx) nel file input.txt
    movb (%ecx, %esi, 1), %al

    # Salvo nello stack esi di input.txt
    pushl %esi

    # Azzero il registro esi prima dell'utilizzo
    xorl %esi, %esi

    # Salvo in esi l'indirizzo della stringa pilot_7
    leal pilot_7_str, %esi

    # Azzero il registro ebx prima dell'utilizzo
    xorl %ebx, %ebx

    # Acquisisco in bl il carattere puntato da esi+offset (ecx) nella stringa pilot_7
    movb (%ecx, %esi, 1), %bl

    # Operazioni da fare qui così abbiamo il valore di esi input già ripristinato prima dei salti #
    #
    # Azzero il registro esi prima dell'utilizzo
    xorl %esi, %esi

    # Recupero esi di input.txt dallo stack
    popl %esi
    #

    # Se il carattere di input.txt è uguale a '\n' (quindi se sono alla fine)
    cmp $10, %al

    # Ho finito il controllo e salto all'etichetta end
    je end

    # Altrimenti se non sono alla fine incremento ecx (per scorrere alla posizione successiva)
    incl %ecx

    # Confronto il carattere della stringa input.txt con il carattere della stringa pilota
    cmp %al, %bl

    # Se i caratteri non sono uguali vado all'etichetta del pilota successivo
    jne pilot_8

    # Se i caratteri sono uguali, torno a ciclo_7
    je ciclo_7

pilot_8:
  # Decremento per arrivare all'ultimo carattere della stringa pilot_* (senza '\0'))
  decl pilot_8_str_len
  decl pilot_8_str_len

  # Azzero il registro ecx prima dell'utilizzo
  xorl %ecx, %ecx

  # Salvo in ecx l'offset per raggiungere '\0' della stringa pilot_8
  movl pilot_8_str_len, %ecx

  # Azzero il registro eax prima dell'utilizzo
  xorl %eax, %eax

  # Controllo che in esi (input.txt) + offset ci sia \n
  movb (%ecx, %esi, 1), %al

  # Controllo il carattere \n
  cmp $10, %al

  # Se non ho il carattere \n vado al prossimo pilota
  jne pilot_9

  # Altrimenti vado a ciclare
  # Azzero il registro edx prima dell'utilizzo
  xorl %edx, %edx

  # Salvo in edx l'ID del pilota
  movb $8, %dl

  # Azzero l'offset (ecx) per il confronto
  xorl %ecx, %ecx

  ciclo_8:
    # Azzero il registro eax prima dell'utilizzo
    xorl %eax, %eax

    # Acquisisco in al il carattere puntato da esi+offset (ecx) nel file input.txt
    movb (%ecx, %esi, 1), %al

    # Salvo nello stack esi di input.txt
    pushl %esi

    # Azzero il registro esi prima dell'utilizzo
    xorl %esi, %esi

    # Salvo in esi l'indirizzo della stringa pilot_8
    leal pilot_8_str, %esi

    # Azzero il registro ebx prima dell'utilizzo
    xorl %ebx, %ebx

    # Acquisisco in bl il carattere puntato da esi+offset (ecx) nella stringa pilot_8
    movb (%ecx, %esi, 1), %bl

    # Operazioni da fare qui così abbiamo il valore di esi input già ripristinato prima dei salti #
    #
    # Azzero il registro esi prima dell'utilizzo
    xorl %esi, %esi

    # Recupero esi di input.txt dallo stack
    popl %esi
    #

    # Se il carattere di input.txt è uguale a '\n' (quindi se sono alla fine)
    cmp $10, %al

    # Ho finito il controllo e salto all'etichetta end
    je end

    # Altrimenti se non sono alla fine incremento ecx (per scorrere alla posizione successiva)
    incl %ecx

    # Confronto il carattere della stringa input.txt con il carattere della stringa pilota
    cmp %al, %bl

    # Se i caratteri non sono uguali vado all'etichetta del pilota successivo
    jne pilot_9

    # Se i caratteri sono uguali, torno a ciclo_8
    je ciclo_8

pilot_9:
  # Decremento per arrivare all'ultimo carattere della stringa pilot_* (senza '\0'))
  decl pilot_9_str_len
  decl pilot_9_str_len

  # Azzero il registro ecx prima dell'utilizzo
  xorl %ecx, %ecx

  # Salvo in ecx l'offset per raggiungere '\0' della stringa pilot_9
  movl pilot_9_str_len, %ecx

  # Azzero il registro eax prima dell'utilizzo
  xorl %eax, %eax

  # Controllo che in esi (input.txt) + offset ci sia \n
  movb (%ecx, %esi, 1), %al

  # Controllo il carattere \n
  cmp $10, %al

  # Se non ho il carattere \n vado al prossimo pilota
  jne pilot_10

  # Altrimenti vado a ciclare
  # Azzero il registro edx prima dell'utilizzo
  xorl %edx, %edx

  # Salvo in edx l'ID del pilota
  movb $9, %dl

  # Azzero l'offset (ecx) per il confronto
  xorl %ecx, %ecx

  ciclo_9:
    # Azzero il registro eax prima dell'utilizzo
    xorl %eax, %eax

    # Acquisisco in al il carattere puntato da esi+offset (ecx) nel file input.txt
    movb (%ecx, %esi, 1), %al

    # Salvo nello stack esi di input.txt
    pushl %esi

    # Azzero il registro esi prima dell'utilizzo
    xorl %esi, %esi

    # Salvo in esi l'indirizzo della stringa pilot_9
    leal pilot_9_str, %esi

    # Azzero il registro ebx prima dell'utilizzo
    xorl %ebx, %ebx

    # Acquisisco in bl il carattere puntato da esi+offset (ecx) nella stringa pilot_9
    movb (%ecx, %esi, 1), %bl

    # Operazioni da fare qui così abbiamo il valore di esi input già ripristinato prima dei salti #
    #
    # Azzero il registro esi prima dell'utilizzo
    xorl %esi, %esi

    # Recupero esi di input.txt dallo stack
    popl %esi
    #

    # Se il carattere di input.txt è uguale a '\n' (quindi se sono alla fine)
    cmp $10, %al

    # Ho finito il controllo e salto all'etichetta end
    je end

    # Altrimenti se non sono alla fine incremento ecx (per scorrere alla posizione successiva)
    incl %ecx

    # Confronto il carattere della stringa input.txt con il carattere della stringa pilota
    cmp %al, %bl

    # Se i caratteri non sono uguali vado all'etichetta del pilota successivo
    jne pilot_10

    # Se i caratteri sono uguali, torno a ciclo_9
    je ciclo_9

pilot_10:
  # Decremento per arrivare all'ultimo carattere della stringa pilot_* (senza '\0'))
  decl pilot_10_str_len
  decl pilot_10_str_len

  # Azzero il registro ecx prima dell'utilizzo
  xorl %ecx, %ecx

  # Salvo in ecx l'offset per raggiungere '\0' della stringa pilot_10
  movl pilot_10_str_len, %ecx

  # Azzero il registro eax prima dell'utilizzo
  xorl %eax, %eax

  # Controllo che in esi (input.txt) + offset ci sia \n
  movb (%ecx, %esi, 1), %al

  # Controllo il carattere \n
  cmp $10, %al

  # Se non ho il carattere \n vado al prossimo pilota
  jne pilot_11

  # Altrimenti vado a ciclare
  # Azzero il registro edx prima dell'utilizzo
  xorl %edx, %edx

  # Salvo in edx l'ID del pilota
  movb $10, %dl

  # Azzero l'offset (ecx) per il confronto
  xorl %ecx, %ecx

  ciclo_10:
    # Azzero il registro eax prima dell'utilizzo
    xorl %eax, %eax

    # Acquisisco in al il carattere puntato da esi+offset (ecx) nel file input.txt
    movb (%ecx, %esi, 1), %al

    # Salvo nello stack esi di input.txt
    pushl %esi

    # Azzero il registro esi prima dell'utilizzo
    xorl %esi, %esi

    # Salvo in esi l'indirizzo della stringa pilot_10
    leal pilot_10_str, %esi

    # Azzero il registro ebx prima dell'utilizzo
    xorl %ebx, %ebx

    # Acquisisco in bl il carattere puntato da esi+offset (ecx) nella stringa pilot_10
    movb (%ecx, %esi, 1), %bl

    # Operazioni da fare qui così abbiamo il valore di esi input già ripristinato prima dei salti #
    #
    # Azzero il registro esi prima dell'utilizzo
    xorl %esi, %esi

    # Recupero esi di input.txt dallo stack
    popl %esi
    #

    # Se il carattere di input.txt è uguale a '\n' (quindi se sono alla fine)
    cmp $10, %al

    # Ho finito il controllo e salto all'etichetta end
    je end

    # Altrimenti se non sono alla fine incremento ecx (per scorrere alla posizione successiva)
    incl %ecx

    # Confronto il carattere della stringa input.txt con il carattere della stringa pilota
    cmp %al, %bl

    # Se i caratteri non sono uguali vado all'etichetta del pilota successivo
    jne pilot_11

    # Se i caratteri sono uguali, torno a ciclo_10
    je ciclo_10

pilot_11:
  # Decremento per arrivare all'ultimo carattere della stringa pilot_* (senza '\0'))
  decl pilot_11_str_len
  decl pilot_11_str_len

  # Azzero il registro ecx prima dell'utilizzo
  xorl %ecx, %ecx

  # Salvo in ecx l'offset per raggiungere '\0' della stringa pilot_11
  movl pilot_11_str_len, %ecx

  # Azzero il registro eax prima dell'utilizzo
  xorl %eax, %eax

  # Controllo che in esi (input.txt) + offset ci sia \n
  movb (%ecx, %esi, 1), %al

  # Controllo il carattere \n
  cmp $10, %al

  # Se non ho il carattere \n vado al prossimo pilota
  jne pilot_12

  # Altrimenti vado a ciclare
  # Azzero il registro edx prima dell'utilizzo
  xorl %edx, %edx

  # Salvo in edx l'ID del pilota
  movb $11, %dl

  # Azzero l'offset (ecx) per il confronto
  xorl %ecx, %ecx

  ciclo_11:
    # Azzero il registro eax prima dell'utilizzo
    xorl %eax, %eax

    # Acquisisco in al il carattere puntato da esi+offset (ecx) nel file input.txt
    movb (%ecx, %esi, 1), %al

    # Salvo nello stack esi di input.txt
    pushl %esi

    # Azzero il registro esi prima dell'utilizzo
    xorl %esi, %esi

    # Salvo in esi l'indirizzo della stringa pilot_11
    leal pilot_11_str, %esi

    # Azzero il registro ebx prima dell'utilizzo
    xorl %ebx, %ebx

    # Acquisisco in bl il carattere puntato da esi+offset (ecx) nella stringa pilot_11
    movb (%ecx, %esi, 1), %bl

    # Operazioni da fare qui così abbiamo il valore di esi input già ripristinato prima dei salti #
    #
    # Azzero il registro esi prima dell'utilizzo
    xorl %esi, %esi

    # Recupero esi di input.txt dallo stack
    popl %esi
    #

    # Se il carattere di input.txt è uguale a '\n' (quindi se sono alla fine)
    cmp $10, %al

    # Ho finito il controllo e salto all'etichetta end
    je end

    # Altrimenti se non sono alla fine incremento ecx (per scorrere alla posizione successiva)
    incl %ecx

    # Confronto il carattere della stringa input.txt con il carattere della stringa pilota
    cmp %al, %bl

    # Se i caratteri non sono uguali vado all'etichetta del pilota successivo
    jne pilot_12

    # Se i caratteri sono uguali, torno a ciclo_11
    je ciclo_11

pilot_12:
  # Decremento per arrivare all'ultimo carattere della stringa pilot_* (senza '\0'))
  decl pilot_12_str_len
  decl pilot_12_str_len

  # Azzero il registro ecx prima dell'utilizzo
  xorl %ecx, %ecx

  # Salvo in ecx l'offset per raggiungere '\0' della stringa pilot_12
  movl pilot_12_str_len, %ecx

  # Azzero il registro eax prima dell'utilizzo
  xorl %eax, %eax

  # Controllo che in esi (input.txt) + offset ci sia \n
  movb (%ecx, %esi, 1), %al

  # Controllo il carattere \n
  cmp $10, %al

  # Se non ho il carattere \n vado al prossimo pilota
  jne pilot_13

  # Altrimenti vado a ciclare
  # Azzero il registro edx prima dell'utilizzo
  xorl %edx, %edx

  # Salvo in edx l'ID del pilota
  movb $12, %dl

  # Azzero l'offset (ecx) per il confronto
  xorl %ecx, %ecx

  ciclo_12:
    # Azzero il registro eax prima dell'utilizzo
    xorl %eax, %eax

    # Acquisisco in al il carattere puntato da esi+offset (ecx) nel file input.txt
    movb (%ecx, %esi, 1), %al

    # Salvo nello stack esi di input.txt
    pushl %esi

    # Azzero il registro esi prima dell'utilizzo
    xorl %esi, %esi

    # Salvo in esi l'indirizzo della stringa pilot_12
    leal pilot_12_str, %esi

    # Azzero il registro ebx prima dell'utilizzo
    xorl %ebx, %ebx

    # Acquisisco in bl il carattere puntato da esi+offset (ecx) nella stringa pilot_12
    movb (%ecx, %esi, 1), %bl

    # Operazioni da fare qui così abbiamo il valore di esi input già ripristinato prima dei salti #
    #
    # Azzero il registro esi prima dell'utilizzo
    xorl %esi, %esi

    # Recupero esi di input.txt dallo stack
    popl %esi
    #

    # Se il carattere di input.txt è uguale a '\n' (quindi se sono alla fine)
    cmp $10, %al

    # Ho finito il controllo e salto all'etichetta end
    je end

    # Altrimenti se non sono alla fine incremento ecx (per scorrere alla posizione successiva)
    incl %ecx

    # Confronto il carattere della stringa input.txt con il carattere della stringa pilota
    cmp %al, %bl

    # Se i caratteri non sono uguali vado all'etichetta del pilota successivo
    jne pilot_13

    # Se i caratteri sono uguali, torno a ciclo_12
    je ciclo_12

pilot_13:
  # Decremento per arrivare all'ultimo carattere della stringa pilot_* (senza '\0'))
  decl pilot_13_str_len
  decl pilot_13_str_len

  # Azzero il registro ecx prima dell'utilizzo
  xorl %ecx, %ecx

  # Salvo in ecx l'offset per raggiungere '\0' della stringa pilot_13
  movl pilot_13_str_len, %ecx

  # Azzero il registro eax prima dell'utilizzo
  xorl %eax, %eax

  # Controllo che in esi (input.txt) + offset ci sia \n
  movb (%ecx, %esi, 1), %al

  # Controllo il carattere \n
  cmp $10, %al

  # Se non ho il carattere \n vado al prossimo pilota
  jne pilot_14

  # Altrimenti vado a ciclare
  # Azzero il registro edx prima dell'utilizzo
  xorl %edx, %edx

  # Salvo in edx l'ID del pilota
  movb $13, %dl

  # Azzero l'offset (ecx) per il confronto
  xorl %ecx, %ecx

  ciclo_13:
    # Azzero il registro eax prima dell'utilizzo
    xorl %eax, %eax

    # Acquisisco in al il carattere puntato da esi+offset (ecx) nel file input.txt
    movb (%ecx, %esi, 1), %al

    # Salvo nello stack esi di input.txt
    pushl %esi

    # Azzero il registro esi prima dell'utilizzo
    xorl %esi, %esi

    # Salvo in esi l'indirizzo della stringa pilot_13
    leal pilot_13_str, %esi

    # Azzero il registro ebx prima dell'utilizzo
    xorl %ebx, %ebx

    # Acquisisco in bl il carattere puntato da esi+offset (ecx) nella stringa pilot_13
    movb (%ecx, %esi, 1), %bl

    # Operazioni da fare qui così abbiamo il valore di esi input già ripristinato prima dei salti #
    #
    # Azzero il registro esi prima dell'utilizzo
    xorl %esi, %esi

    # Recupero esi di input.txt dallo stack
    popl %esi
    #

    # Se il carattere di input.txt è uguale a '\n' (quindi se sono alla fine)
    cmp $10, %al

    # Ho finito il controllo e salto all'etichetta end
    je end

    # Altrimenti se non sono alla fine incremento ecx (per scorrere alla posizione successiva)
    incl %ecx

    # Confronto il carattere della stringa input.txt con il carattere della stringa pilota
    cmp %al, %bl

    # Se i caratteri non sono uguali vado all'etichetta del pilota successivo
    jne pilot_14

    # Se i caratteri sono uguali, torno a ciclo_13
    je ciclo_13

pilot_14:
  # Decremento per arrivare all'ultimo carattere della stringa pilot_* (senza '\0'))
  decl pilot_14_str_len
  decl pilot_14_str_len

  # Azzero il registro ecx prima dell'utilizzo
  xorl %ecx, %ecx

  # Salvo in ecx l'offset per raggiungere '\0' della stringa pilot_14
  movl pilot_14_str_len, %ecx

  # Azzero il registro eax prima dell'utilizzo
  xorl %eax, %eax

  # Controllo che in esi (input.txt) + offset ci sia \n
  movb (%ecx, %esi, 1), %al

  # Controllo il carattere \n
  cmp $10, %al

  # Se non ho il carattere \n vado al prossimo pilota
  jne pilot_15

  # Altrimenti vado a ciclare
  # Azzero il registro edx prima dell'utilizzo
  xorl %edx, %edx

  # Salvo in edx l'ID del pilota
  movb $14, %dl

  # Azzero l'offset (ecx) per il confronto
  xorl %ecx, %ecx

  ciclo_14:
    # Azzero il registro eax prima dell'utilizzo
    xorl %eax, %eax

    # Acquisisco in al il carattere puntato da esi+offset (ecx) nel file input.txt
    movb (%ecx, %esi, 1), %al

    # Salvo nello stack esi di input.txt
    pushl %esi

    # Azzero il registro esi prima dell'utilizzo
    xorl %esi, %esi

    # Salvo in esi l'indirizzo della stringa pilot_14
    leal pilot_14_str, %esi

    # Azzero il registro ebx prima dell'utilizzo
    xorl %ebx, %ebx

    # Acquisisco in bl il carattere puntato da esi+offset (ecx) nella stringa pilot_14
    movb (%ecx, %esi, 1), %bl

    # Operazioni da fare qui così abbiamo il valore di esi input già ripristinato prima dei salti #
    #
    # Azzero il registro esi prima dell'utilizzo
    xorl %esi, %esi

    # Recupero esi di input.txt dallo stack
    popl %esi
    #

    # Se il carattere di input.txt è uguale a '\n' (quindi se sono alla fine)
    cmp $10, %al

    # Ho finito il controllo e salto all'etichetta end
    je end

    # Altrimenti se non sono alla fine incremento ecx (per scorrere alla posizione successiva)
    incl %ecx

    # Confronto il carattere della stringa input.txt con il carattere della stringa pilota
    cmp %al, %bl

    # Se i caratteri non sono uguali vado all'etichetta del pilota successivo
    jne pilot_15

    # Se i caratteri sono uguali, torno a ciclo_14
    je ciclo_14

pilot_15:
  # Decremento per arrivare all'ultimo carattere della stringa pilot_* (senza '\0'))
  decl pilot_15_str_len
  decl pilot_15_str_len

  # Azzero il registro ecx prima dell'utilizzo
  xorl %ecx, %ecx

  # Salvo in ecx l'offset per raggiungere '\0' della stringa pilot_15
  movl pilot_15_str_len, %ecx

  # Azzero il registro eax prima dell'utilizzo
  xorl %eax, %eax

  # Controllo che in esi (input.txt) + offset ci sia \n
  movb (%ecx, %esi, 1), %al

  # Controllo il carattere \n
  cmp $10, %al

  # Se non ho il carattere \n vado al prossimo pilota
  jne pilot_16

  # Altrimenti vado a ciclare
  # Azzero il registro edx prima dell'utilizzo
  xorl %edx, %edx

  # Salvo in edx l'ID del pilota
  movb $15, %dl

  # Azzero l'offset (ecx) per il confronto
  xorl %ecx, %ecx

  ciclo_15:
    # Azzero il registro eax prima dell'utilizzo
    xorl %eax, %eax

    # Acquisisco in al il carattere puntato da esi+offset (ecx) nel file input.txt
    movb (%ecx, %esi, 1), %al

    # Salvo nello stack esi di input.txt
    pushl %esi

    # Azzero il registro esi prima dell'utilizzo
    xorl %esi, %esi

    # Salvo in esi l'indirizzo della stringa pilot_15
    leal pilot_15_str, %esi

    # Azzero il registro ebx prima dell'utilizzo
    xorl %ebx, %ebx

    # Acquisisco in bl il carattere puntato da esi+offset (ecx) nella stringa pilot_15
    movb (%ecx, %esi, 1), %bl

    # Operazioni da fare qui così abbiamo il valore di esi input già ripristinato prima dei salti #
    #
    # Azzero il registro esi prima dell'utilizzo
    xorl %esi, %esi

    # Recupero esi di input.txt dallo stack
    popl %esi
    #

    # Se il carattere di input.txt è uguale a '\n' (quindi se sono alla fine)
    cmp $10, %al

    # Ho finito il controllo e salto all'etichetta end
    je end

    # Altrimenti se non sono alla fine incremento ecx (per scorrere alla posizione successiva)
    incl %ecx

    # Confronto il carattere della stringa input.txt con il carattere della stringa pilota
    cmp %al, %bl

    # Se i caratteri non sono uguali vado all'etichetta del pilota successivo
    jne pilot_16

    # Se i caratteri sono uguali, torno a ciclo_15
    je ciclo_15

pilot_16:
  # Decremento per arrivare all'ultimo carattere della stringa pilot_* (senza '\0'))
  decl pilot_16_str_len
  decl pilot_16_str_len

  # Azzero il registro ecx prima dell'utilizzo
  xorl %ecx, %ecx

  # Salvo in ecx l'offset per raggiungere '\0' della stringa pilot_16
  movl pilot_16_str_len, %ecx

  # Azzero il registro eax prima dell'utilizzo
  xorl %eax, %eax

  # Controllo che in esi (input.txt) + offset ci sia \n
  movb (%ecx, %esi, 1), %al

  # Controllo il carattere \n
  cmp $10, %al

  # Se non ho il carattere \n vado al prossimo pilota
  jne pilot_17

  # Altrimenti vado a ciclare
  # Azzero il registro edx prima dell'utilizzo
  xorl %edx, %edx

  # Salvo in edx l'ID del pilota
  movb $16, %dl

  # Azzero l'offset (ecx) per il confronto
  xorl %ecx, %ecx

  ciclo_16:
    # Azzero il registro eax prima dell'utilizzo
    xorl %eax, %eax

    # Acquisisco in al il carattere puntato da esi+offset (ecx) nel file input.txt
    movb (%ecx, %esi, 1), %al

    # Salvo nello stack esi di input.txt
    pushl %esi

    # Azzero il registro esi prima dell'utilizzo
    xorl %esi, %esi

    # Salvo in esi l'indirizzo della stringa pilot_16
    leal pilot_16_str, %esi

    # Azzero il registro ebx prima dell'utilizzo
    xorl %ebx, %ebx

    # Acquisisco in bl il carattere puntato da esi+offset (ecx) nella stringa pilot_16
    movb (%ecx, %esi, 1), %bl

    # Operazioni da fare qui così abbiamo il valore di esi input già ripristinato prima dei salti #
    #
    # Azzero il registro esi prima dell'utilizzo
    xorl %esi, %esi

    # Recupero esi di input.txt dallo stack
    popl %esi
    #

    # Se il carattere di input.txt è uguale a '\n' (quindi se sono alla fine)
    cmp $10, %al

    # Ho finito il controllo e salto all'etichetta end
    je end

    # Altrimenti se non sono alla fine incremento ecx (per scorrere alla posizione successiva)
    incl %ecx

    # Confronto il carattere della stringa input.txt con il carattere della stringa pilota
    cmp %al, %bl

    # Se i caratteri non sono uguali vado all'etichetta del pilota successivo
    jne pilot_17

    # Se i caratteri sono uguali, torno a ciclo_16
    je ciclo_16

pilot_17:
  # Decremento per arrivare all'ultimo carattere della stringa pilot_* (senza '\0'))
  decl pilot_17_str_len
  decl pilot_17_str_len

  # Azzero il registro ecx prima dell'utilizzo
  xorl %ecx, %ecx

  # Salvo in ecx l'offset per raggiungere '\0' della stringa pilot_17
  movl pilot_17_str_len, %ecx

  # Azzero il registro eax prima dell'utilizzo
  xorl %eax, %eax

  # Controllo che in esi (input.txt) + offset ci sia \n
  movb (%ecx, %esi, 1), %al

  # Controllo il carattere \n
  cmp $10, %al

  # Se non ho il carattere \n vado al prossimo pilota
  jne pilot_18

  # Altrimenti vado a ciclare
  # Azzero il registro edx prima dell'utilizzo
  xorl %edx, %edx

  # Salvo in edx l'ID del pilota
  movb $17, %dl

  # Azzero l'offset (ecx) per il confronto
  xorl %ecx, %ecx

  ciclo_17:
    # Azzero il registro eax prima dell'utilizzo
    xorl %eax, %eax

    # Acquisisco in al il carattere puntato da esi+offset (ecx) nel file input.txt
    movb (%ecx, %esi, 1), %al

    # Salvo nello stack esi di input.txt
    pushl %esi

    # Azzero il registro esi prima dell'utilizzo
    xorl %esi, %esi

    # Salvo in esi l'indirizzo della stringa pilot_17
    leal pilot_17_str, %esi

    # Azzero il registro ebx prima dell'utilizzo
    xorl %ebx, %ebx

    # Acquisisco in bl il carattere puntato da esi+offset (ecx) nella stringa pilot_17
    movb (%ecx, %esi, 1), %bl

    # Operazioni da fare qui così abbiamo il valore di esi input già ripristinato prima dei salti #
    #
    # Azzero il registro esi prima dell'utilizzo
    xorl %esi, %esi

    # Recupero esi di input.txt dallo stack
    popl %esi
    #

    # Se il carattere di input.txt è uguale a '\n' (quindi se sono alla fine)
    cmp $10, %al

    # Ho finito il controllo e salto all'etichetta end
    je end

    # Altrimenti se non sono alla fine incremento ecx (per scorrere alla posizione successiva)
    incl %ecx

    # Confronto il carattere della stringa input.txt con il carattere della stringa pilota
    cmp %al, %bl

    # Se i caratteri non sono uguali vado all'etichetta del pilota successivo
    jne pilot_18

    # Se i caratteri sono uguali, torno a ciclo_17
    je ciclo_17

pilot_18:
  # Decremento per arrivare all'ultimo carattere della stringa pilot_* (senza '\0'))
  decl pilot_18_str_len
  decl pilot_18_str_len

  # Azzero il registro ecx prima dell'utilizzo
  xorl %ecx, %ecx

  # Salvo in ecx l'offset per raggiungere '\0' della stringa pilot_18
  movl pilot_18_str_len, %ecx

  # Azzero il registro eax prima dell'utilizzo
  xorl %eax, %eax

  # Controllo che in esi (input.txt) + offset ci sia \n
  movb (%ecx, %esi, 1), %al

  # Controllo il carattere \n
  cmp $10, %al

  # Se non ho il carattere \n vado al prossimo pilota
  jne pilot_19

  # Altrimenti vado a ciclare
  # Azzero il registro edx prima dell'utilizzo
  xorl %edx, %edx

  # Salvo in edx l'ID del pilota
  movb $18, %dl

  # Azzero l'offset (ecx) per il confronto
  xorl %ecx, %ecx

  ciclo_18:
    # Azzero il registro eax prima dell'utilizzo
    xorl %eax, %eax

    # Acquisisco in al il carattere puntato da esi+offset (ecx) nel file input.txt
    movb (%ecx, %esi, 1), %al

    # Salvo nello stack esi di input.txt
    pushl %esi

    # Azzero il registro esi prima dell'utilizzo
    xorl %esi, %esi

    # Salvo in esi l'indirizzo della stringa pilot_18
    leal pilot_18_str, %esi

    # Azzero il registro ebx prima dell'utilizzo
    xorl %ebx, %ebx

    # Acquisisco in bl il carattere puntato da esi+offset (ecx) nella stringa pilot_18
    movb (%ecx, %esi, 1), %bl

    # Operazioni da fare qui così abbiamo il valore di esi input già ripristinato prima dei salti #
    #
    # Azzero il registro esi prima dell'utilizzo
    xorl %esi, %esi

    # Recupero esi di input.txt dallo stack
    popl %esi
    #

    # Se il carattere di input.txt è uguale a '\n' (quindi se sono alla fine)
    cmp $10, %al

    # Ho finito il controllo e salto all'etichetta end
    je end

    # Altrimenti se non sono alla fine incremento ecx (per scorrere alla posizione successiva)
    incl %ecx

    # Confronto il carattere della stringa input.txt con il carattere della stringa pilota
    cmp %al, %bl

    # Se i caratteri non sono uguali vado all'etichetta del pilota successivo
    jne pilot_19

    # Se i caratteri sono uguali, torno a ciclo_18
    je ciclo_18

pilot_19:
  # Decremento per arrivare all'ultimo carattere della stringa pilot_* (senza '\0'))
  decl pilot_19_str_len
  decl pilot_19_str_len

  # Azzero il registro ecx prima dell'utilizzo
  xorl %ecx, %ecx

  # Salvo in ecx l'offset per raggiungere '\0' della stringa pilot_19
  movl pilot_19_str_len, %ecx

  # Azzero il registro eax prima dell'utilizzo
  xorl %eax, %eax

  # Controllo che in esi (input.txt) + offset ci sia \n
  movb (%ecx, %esi, 1), %al

  # Controllo il carattere \n
  cmp $10, %al

  # Se non ho il carattere \n vado a Invalid
  jne Invalid

  # Altrimenti vado a ciclare
  # Azzero il registro edx prima dell'utilizzo
  xorl %edx, %edx

  # Salvo in edx l'ID del pilota
  movb $19, %dl

  # Azzero l'offset (ecx) per il confronto
  xorl %ecx, %ecx

  ciclo_19:
    # Azzero il registro eax prima dell'utilizzo
    xorl %eax, %eax

    # Acquisisco in al il carattere puntato da esi+offset (ecx) nel file input.txt
    movb (%ecx, %esi, 1), %al

    # Salvo nello stack esi di input.txt
    pushl %esi

    # Azzero il registro esi prima dell'utilizzo
    xorl %esi, %esi

    # Salvo in esi l'indirizzo della stringa pilot_19
    leal pilot_19_str, %esi

    # Azzero il registro ebx prima dell'utilizzo
    xorl %ebx, %ebx

    # Acquisisco in bl il carattere puntato da esi+offset (ecx) nella stringa pilot_19
    movb (%ecx, %esi, 1), %bl

    # Operazioni da fare qui così abbiamo il valore di esi input già ripristinato prima dei salti #
    #
    # Azzero il registro esi prima dell'utilizzo
    xorl %esi, %esi

    # Recupero esi di input.txt dallo stack
    popl %esi
    #

    # Se il carattere di input.txt è uguale a '\n' (quindi se sono alla fine)
    cmp $10, %al

    # Ho finito il controllo e salto all'etichetta end
    je end

    # Altrimenti se non sono alla fine incremento ecx (per scorrere alla posizione successiva)
    incl %ecx

    # Confronto il carattere della stringa input.txt con il carattere della stringa pilota
    cmp %al, %bl

    # Se i caratteri non sono uguali vado a Invalid
    jne Invalid

    # Se i caratteri sono uguali, torno a ciclo_19
    je ciclo_19


Invalid:
  # Se tutti i controlli falliscono, allora viene ritornato come ID pilota 20 (telemetry.s stampa "Invalid")
  movb $20, %dl

end:
  ret

.section .data

tempo:
  .ascii "                                        " #40 spazi

address_output:
  .long 0

offset_output:
  .long 0

velocita:
  .long 0

velocita_max:
  .long 0

velocita_media:
  .long 0

rpm_max:
  .long 0

temp_max:
  .long 0

counter_velocita:
  .long 0

sum_velocita:
  .long 0

.section .text
.global verifica_riga

.type verifica_riga, @function

verifica_riga:

  # ############################################################################ #
  # Formato stringa input --> <tempo>,<id_pilota>,<velocità>,<rpm>,<temperatura> #
  # ############################################################################ #

  # ######################################################################################### #
  # Formato stringa output --> <tempo>,<livello rpm>,<livello temperatura>,<livello velocità> #
  # ######################################################################################### #

  # # # # Essential Registers Status # # # #
  # esi -> address input                   #
  # ecx -> offset input (esi + ecx = '\n') #
  # edx -> id pilot                        #
  # ebx -> 0                               #
  # # # # # # # # # #  # # # # # # # # # # #

  # Salvo in address_output il puntatore al file output.txt
  movl 8(%ebp), %eax
  movl %eax, address_output

  # Salvo id pilota nello stack
  pushl %edx

  # Azzero il registro edx prima dell'utilizzo
  xorl %edx, %edx
  # Salvo l'indirizzo della stringa tempo in edx
  leal tempo, %edx

  # # # # Essential Registers Status # # # #
  # esi -> address input                   #
  # ecx -> offset input (esi + ecx = '\n') #
  # edx -> address tempo                   #
  # ebx -> 0                               #
  # # # # # # # # # #  # # # # # # # # # # #

  # # # # Stack Status # # # #
  # > id pilota              #
  # # # # # # #  # # # # # # #

  # Ogni volta che viene richiamata l'etichetta ciclo_tempo, bisogna ssicurarsi che ci sia l'immagine di memoria sopra descritta

  # Scorro nel file input.txt fino alla prima virgola della
  ciclo_tempo:
    # Azzero il registro eax prima dell'utilizzo
    xorl %eax, %eax

    # Incremento ecx per scorrere alla posizione successiva di input.txt
    incl %ecx

    # Acquisisco carattere da input.txt
    movb (%ecx, %esi, 1), %al

    # Controllo \0
    cmp $0, %al

    # Se trovo \0 allora sono alla fine del file input.txt --> vado a stampa_finale
    je stampa_finale

    # Controllo ','
    cmp $44, %al

    # Se trovo ',' allora ho finito l'acquisizione e aggiungo \0
    je terminatore_tempo

    # Altrimenti salvo il tempo nella stringa tempo
    # Scrivo il carattere di input.txt nella stringa tempo
    movb %al, (%ebx, %edx, 1)

    # Incremento ebx per scrivere nella posizione successiva della stringa tempo
    incl %ebx

    # Continuo a ciclare
    jmp ciclo_tempo

  terminatore_tempo:
    movb $0, (%ebx, %edx, 1)

# ################################################################################# #
    # Azzero il registro ebx prima dell'utilizzo
    xorl %eax, %eax
    # Azzero il registro edx prima dell'utilizzo
    xorl %ebx, %ebx
    # Azzero il registro eax prima dell'utilizzo
    xorl %edx, %edx
    # Base 10 per le moltiplicazioni conversione ASCII --> INT
    movl $10, %ebx
# ################################################################################# #

  ciclo_id_pilota:
    # Incremento ecx per scorrere alla posizione successiva
    incl %ecx

    # Acquisisco carattere da input.txt
    movb (%ecx, %esi, 1), %dl

    # Controllo ','
    cmp $44, %dl

    # Se trovo ',' allora controllo la corrispondenza con ID pilota
    je check_id_pilota

    # Conversione ASCII --> INT
    subl $48, %edx

    # Salvo il valore intero nello stack
    pushl %edx

    # eax = eax * ebx ( = 10), shift SX cifre in eax
    mull %ebx

    # A questo punto il valore intero si trova in eax

    # Azzero il registro edx prima dell'utilizzo
    xorl %edx, %edx

    # Recupero il valore intero dallo stack
    popl %edx

    # Aggiungo il valore intero corrente a quello precedente
    addl %edx, %eax

    # Continuo a ciclare
    jmp ciclo_id_pilota

  check_id_pilota:
    # Azzero il registro edx prima dell'utilizzo
    xorl %edx, %edx

    # Recupero l'id pilota dallo stack
    popl %edx

    # Controllo corrispondenza ID pilota
    cmp %edx, %eax

    # Se corrisponde allora passo al prossimo controllo
    je stampa_tempo

    # Altrimenti passo alla prossima riga

  prossima_riga:
    # Incremento ecx per scorrere alla posizione successiva
    incl %ecx

    # Azzero il registro eax prima dell'utilizzo
    xorl %eax, %eax

    # Acquisisco carattere da input.txt
    movb (%ecx, %esi, 1), %al

    # Controllo \n
    cmp $10, %al

    # Se non sono alla fine della riga continuo a scorrere
    jne prossima_riga

    # Inizializzazione registri #
    #
    # Azzero il registro ebx prima dell'utilizzo (conterrà il contatore di stringa tempo)
    xorl %ebx, %ebx
    
    # ecx contiene già l'offset di input.txt aggiornato

    # Salvo nello stack l'id pilota
    pushl %edx

    # Azzero il registro edx prima dell'utilizzo
    xorl %edx, %edx

    # Salvo l'indirizzo della stringa tempo in edx
    leal tempo, %edx

    # esi contiene già l'indirizzo di input.txt
    #

    # Alla fine della riga ricomincio da ciclo_tempo
    jmp ciclo_tempo

  stampa_tempo:
  # Salvo l'id pilota nello stack
  pushl %edx

  # Salvo offset di input.txt nello stack            
  pushl %ecx

  # Salvo esi di input.txt nello stack            
  pushl %esi            
  
  # Azzero il registro esi prima dell'utilizzo
  xorl %esi, %esi
  
  # Azzero il registro ebx prima dell'utilizzo       
  xorl %ebx, %ebx
  
  # Azzero il registro ecx prima dell'utilizzo       
  xorl %ecx, %ecx

  # Azzero il registro edx prima dell'utilizzo       
  xorl %edx, %edx       

  # Salvo in ecx l'offset di output.txt
  movl offset_output, %ecx

  # Salvo in esi l'indirizzo di output.txt
  movl address_output, %esi
  
  # Salvo in edx l'indirizzo della stringa tempo
  leal tempo, %edx

  ciclo_stampa_tempo:
    # Azzero il registro eax prima dell'utilizzo
    xorl %eax, %eax       

    # Acquisisco carattere dalla stringa tempo
    movb (%ebx, %edx, 1), %al

    # Incremento l'offset di stringa tempo
    incl %ebx

    # Se trovo il terminatore in stringa tempo
    cmp $0, %al

    # Stampo la virgola
    je virgola

    # Stampo carattere in output.txt
    movb %al, (%ecx, %esi, 1)
    
    # Incremento l'offset di output.txt
    incl %ecx
    
    jmp ciclo_stampa_tempo

  virgola:
    # Stampo la virgola in output.txt
    movl $44, (%ecx, %esi, 1)
    
    # Salvo l'offset di output.txt in offset_output
    movl %ecx, offset_output

  # # # # Essential Registers Status # # # #
  # esi -> address output                  #
  # ecx -> offset output                   #
  # edx -> address tempo                   #
  # ebx -> offset tempo                    #
  # # # # # # # # # #  # # # # # # # # # # #

  # # # # Stack Status # # # #
  # > address input          #
  #   offset input           #
  # - id pilota              #
  # # # # # # #  # # # # # # #

  # Azzero il registro esi prima dell'utilizzo
  xorl %esi, %esi

  # Azzero il registro ecx prima dell'utilizzo
  xorl %ecx, %ecx

  # Recupero address input dallo stack
  popl %esi

  # Recupero offset input dallo stack
  popl %ecx

  # # # # Essential Registers Status # # # #
  # esi -> address output                  #
  # ecx -> offset output                   #
  # edx -> address tempo                   #
  # ebx -> offset tempo                    #
  # # # # # # # # # #  # # # # # # # # # # #

  # # # # Stack Status # # # #
  # > id pilota              #
  # # # # # # #  # # # # # # #

# ################################################################################# #
    # Azzero il registro ebx prima dell'utilizzo
    xorl %eax, %eax
    # Azzero il registro edx prima dell'utilizzo
    xorl %ebx, %ebx
    # Azzero il registro eax prima dell'utilizzo
    xorl %edx, %edx
    # Base 10 per le moltiplicazioni conversione ASCII --> INT
    movl $10, %ebx
# ################################################################################# #

  ciclo_velocita:
    # Incremento ecx per scorrere alla posizione successiva
    incl %ecx

    # Acquisisco carattere da input.txt
    movb (%ecx, %esi, 1), %dl

    # Controllo ','
    cmp $44, %dl

    # Se trovo ',' allora passo a store_velocita
    je store_velocita

    # Conversione ASCII --> INT
    subl $48, %edx

    # Salvo il valore intero nello stack
    pushl %edx

    # eax = eax * ebx ( = 10), shift SX cifre in eax
    mull %ebx
    
    # A questo punto il valore intero si trova in eax

    # Azzero il registro edx prima dell'utilizzo
    xorl %edx, %edx

    # Recupero il valore intero dallo stack
    popl %edx

    # Aggiungo il valore intero corrente a quello precedente
    addl %edx, %eax

    # Continuo a ciclare
    jmp ciclo_velocita

  # # # # Essential Registers Status # # # #
  # esi -> address input                   #
  # ecx -> offset input                    #
  # eax -> valore velocita                 #
  # ebx -> 10                              #
  # # # # # # # # # #  # # # # # # # # # # #

  # # # # Stack Status # # # #
  # > id pilota              #
  # # # # # # #  # # # # # # #

  store_velocita:
    # Salvo la velocità in velocita
    movl %eax, velocita
    
    # sum_velocita += eax
    addl %eax, sum_velocita
    
    # Incremento il contatore per il calcolo della velocità media
    incl counter_velocita
    
    # Se la velocità corrente è minore della velocità massima 
    cmp velocita_max, %eax
    
    # Salto al prossimo controllo
    jle rpm
    
    # Altrimenti aggiorno il valore della velocità massima
    movl %eax, velocita_max

# # # Same Status as before # # #

  rpm:
    # Azzero il registro eax prima dell'utilizzo
    xorl %eax, %eax

    # Azzero il registro edx prima dell'utilizzo
    xorl %edx, %edx

  ciclo_rpm:
    # Incremento ecx per scorrere alla posizione successiva
    incl %ecx

    # Acquisisco carattere da input.txt
    movb (%ecx, %esi, 1), %dl

    # Controllo ','
    cmp $44, %dl

    # Se trovo ',' allora passo a verifica_rpm
    je check_rpm

    # Conversione ASCII --> INT
    subl $48, %edx

    # Salvo il valore intero nello stack
    pushl %edx

    # eax = eax * ebx ( = 10), shift SX cifre in eax
    mull %ebx

    # Azzero il registro edx prima dell'utilizzo
    xorl %edx, %edx

    # Recupero il valore intero dallo stack
    popl %edx

    # Aggiungo il valore intero corrente a quello precedente
    addl %edx, %eax

    # Altrimenti continuo a ciclare
    jmp ciclo_rpm

# # # # Essential Registers Status # # # #
# esi -> address input                   #
# ecx -> offset input                    #
# eax -> valore rpm                      #
# # # # # # # # # #  # # # # # # # # # # #

# # # # Stack Status # # # #
# > id pilota              #
# # # # # # #  # # # # # # #

  check_rpm:
    # Azzero il registro ebx prima dell'utilizzo
    xorl %ebx, %ebx

    # Azzero il registro edx prima dell'utilizzo
    xorl %edx, %edx

    # Copio offset output nel registro ebx
    movl offset_output, %ebx

    # Copio addres output nel registro edx
    movl address_output, %edx
    
    # Eseguo il confronto per soglia inferiore o uguale
    cmp $5000, %eax

    # Se minore o uguale di 5 000 stampo stringa "LOW"
    jle LOW_rpm

    # Altrimenti eseguo il confronto per soglia superiore
    cmp $10000, %eax
    
    # Se è maggiore di 10 000 stampo stringa "HIGH"
    jg HIGH_rpm

    # Altrimenti stampo stringa "MEDIUM"

  MEDIUM_rpm:
    incl %ebx                    # Incremento contatore file output.txt
    movl $77, (%ebx, %edx, 1)    # Stampo "M"
    incl %ebx                    # Incremento contatore file output.txt
    movl $69, (%ebx, %edx, 1)    # Stampo "E"
    incl %ebx                    # Incremento contatore file output.txt
    movl $68, (%ebx, %edx, 1)    # Stampo "D"
    incl %ebx                    # Incremento contatore file output.txt
    movl $73, (%ebx, %edx, 1)    # Stampo "I"
    incl %ebx                    # Incremento contatore file output.txt
    movl $85, (%ebx, %edx, 1)    # Stampo "U"
    incl %ebx                    # Incremento contatore file output.txt
    movl $77, (%ebx, %edx, 1)    # Stampo "M"             

    jmp end_rpm                  # Fine stampa --> passo a end_rpm

  LOW_rpm:
    incl %ebx                    # Incremento contatore file output.txt
    movl $76, (%ebx, %edx, 1)    # Stampo "L"
    incl %ebx                    # Incremento contatore file output.txt
    movl $79, (%ebx, %edx, 1)    # Stampo "O"
    incl %ebx                    # Incremento contatore file output.txt
    movl $87, (%ebx, %edx, 1)    # Stampo "W"

    jmp end_rpm                  # Fine stampa --> passo a end_rpm

  HIGH_rpm:
    incl %ebx                    # Incremento contatore file output.txt
    movl $72, (%ebx, %edx, 1)    # Stampo "H"
    incl %ebx                    # Incremento contatore file output.txt
    movl $73, (%ebx, %edx, 1)    # Stampo "I"
    incl %ebx                    # Incremento contatore file output.txt
    movl $71, (%ebx, %edx, 1)    # Stampo "G"
    incl %ebx                    # Incremento contatore file output.txt
    movl $72, (%ebx, %edx, 1)    # Stampo "H"

  end_rpm:
    incl %ebx                    # Incremento contatore file output.txt
    movl $44, (%ebx, %edx, 1)    # Stampo ","

    # Aggiorno offset output
    movl %ebx, offset_output
    
    # Se gli rpm correnti sono minori o uguali degli rpm massimi
    cmp rpm_max, %eax

    # Salto al prossimo controllo
    jle temperatura
    
    # Altrimenti aggiorno il valore degli rpm massimi
    movl %eax, rpm_max

  temperatura:
# ################################################################################# #
    # Azzero il registro ebx prima dell'utilizzo
    xorl %eax, %eax
    # Azzero il registro edx prima dell'utilizzo
    xorl %ebx, %ebx
    # Azzero il registro eax prima dell'utilizzo
    xorl %edx, %edx
    # Base 10 per le moltiplicazioni conversione ASCII --> INT
    movl $10, %ebx
# ################################################################################# #

  ciclo_temperatura:
    # Incremento ecx per scorrere alla posizione successiva
    incl %ecx

    # Acquisisco carattere da input.txt
    movb (%ecx, %esi, 1), %dl
    
    # Controllo \n
    cmp $10, %dl

    # Se sono alla fine della riga allora passo a verifica_temperatura
    je check_temperatura
    
    # Conversione ASCII --> INT
    subl $48, %edx

    # Salvo il valore intero dallo stack
    pushl %edx

    # eax = eax * ebx ( = 10), shift SX cifre in eax
    mull %ebx

    # A questo punto il valore intero si trova in eax

    # Azzero il registro edx prima dell'utilizzo
    xorl %edx, %edx

    # Recupero il valore intero dallo stack
    popl %edx

    # Aggiungo il valore intero corrente a quello precedente
    addl %edx, %eax

    # Continuo a ciclare
    jmp ciclo_temperatura

# # # # Essential Registers Status # # # #
# esi -> address input                   #
# ecx -> offset input                    #
# eax -> valore temperatura              #
# # # # # # # # # #  # # # # # # # # # # #

# # # # Stack Status # # # #
# > id pilota              #
# # # # # # #  # # # # # # #

  check_temperatura:
    # Azzero il registro ebx prima dell'utilizzo
    xorl %ebx, %ebx

    # Azzero il registro edx prima dell'utilizzo
    xorl %edx, %edx

    # Copio offset output nel registro ebx
    movl offset_output, %ebx

    # Copio addres output nel registro edx
    movl address_output, %edx

    # Eseguo il confronto per soglia inferiore o uguale
    cmp $90, %eax

    # Se è minore di 90 stampo stringa "LOW"
    jle LOW_temp

    # Altrimenti eseguo il confronto per soglia superiore
    cmp $110, %eax

    # Se è maggiore di 100 stampo stringa "HIGH"
    jg HIGH_temp

    # Altrimenti stampo stringa "MEDIUM"

  MEDIUM_temp:
    incl %ebx                    # Incremento contatore file output.txt
    movl $77, (%ebx, %edx, 1)    # Stampo "M"
    incl %ebx                    # Incremento contatore file output.txt
    movl $69, (%ebx, %edx, 1)    # Stampo "E"
    incl %ebx                    # Incremento contatore file output.txt
    movl $68, (%ebx, %edx, 1)    # Stampo "D"
    incl %ebx                    # Incremento contatore file output.txt
    movl $73, (%ebx, %edx, 1)    # Stampo "I"
    incl %ebx                    # Incremento contatore file output.txt
    movl $85, (%ebx, %edx, 1)    # Stampo "U"
    incl %ebx                    # Incremento contatore file output.txt
    movl $77, (%ebx, %edx, 1)    # Stampo "M"

    jmp end_temp                 # Fine stampa --> passo a end_temp

  LOW_temp:
    incl %ebx                    # Incremento contatore file output.txt
    movl $76, (%ebx, %edx, 1)    # Stampo "L"
    incl %ebx                    # Incremento contatore file output.txt
    movl $79, (%ebx, %edx, 1)    # Stampo "O"
    incl %ebx                    # Incremento contatore file output.txt
    movl $87, (%ebx, %edx, 1)    # Stampo "W"

    jmp end_temp                 # Fine stampa --> passo a end_temp

  HIGH_temp:
    incl %ebx                    # Incremento contatore file output.txt
    movl $72, (%ebx, %edx, 1)    # Stampo "H"
    incl %ebx                    # Incremento contatore file output.txt
    movl $73, (%ebx, %edx, 1)    # Stampo "I"
    incl %ebx                    # Incremento contatore file output.txt
    movl $71, (%ebx, %edx, 1)    # Stampo "G"
    incl %ebx                    # Incremento contatore file output.txt
    movl $72, (%ebx, %edx, 1)    # Stampo "H"

  end_temp:
    incl %ebx                    # Incremento contatore file output.txt
    movl $44, (%ebx, %edx, 1)    # Stampo ","

    # Aggiorno il valore di offset output
    movl %ebx, offset_output

    # Se la temperatura corrente è minore o uguale della temperatura masima
    cmp temp_max, %eax

    # Salto al prossimo controllo
    jle check_velocita

    # Altrimenti aggiorno il valore della temperatura massima
    movl %eax, temp_max

  check_velocita:
    # Azzero il registro eax prima dell'utilizzo
    xorl %eax, %eax

    # Azzero il registro ebx prima dell'utilizzo
    xorl %ebx, %ebx

    # Azzero il registro edx prima dell'utilizzo
    xorl %edx, %edx

    # Copio offset output nel registro ebx
    movl offset_output, %ebx

    # Copio addres output nel registro edx
    movl address_output, %edx
    
    # Copio il valore della velocità in eax
    movl velocita, %eax

    # Eseguo il confronto per soglia inferiore o uguale
    cmp $100, %eax

    # Se minore o uguale a 100 stampo stringa "LOW"               
    jle LOW_vel                  

    # Altirmenti eseguo il confronto per soglia superiore
    cmp $250, %eax

    # Se è maggiore di 250 stampo stringa "HIGH"
    jg HIGH_vel

    # Altrimenti stampo stringa "MEDIUM"

  MEDIUM_vel:
    incl %ebx                    # Incremento contatore file output.txt
    movl $77, (%ebx, %edx, 1)    # Stampo "M"
    incl %ebx                    # Incremento contatore file output.txt
    movl $69, (%ebx, %edx, 1)    # Stampo "E"
    incl %ebx                    # Incremento contatore file output.txt
    movl $68, (%ebx, %edx, 1)    # Stampo "D"
    incl %ebx                    # Incremento contatore file output.txt
    movl $73, (%ebx, %edx, 1)    # Stampo "I"
    incl %ebx                    # Incremento contatore file output.txt
    movl $85, (%ebx, %edx, 1)    # Stampo "U"
    incl %ebx                    # Incremento contatore file output.txt
    movl $77, (%ebx, %edx, 1)    # Stampo "M"

    jmp end_vel                  # Fine stampa --> passo a end_vel

  LOW_vel:
    incl %ebx                    # Incremento contatore file output.txt
    movl $76, (%ebx, %edx, 1)    # Stampo "L"
    incl %ebx                    # Incremento contatore file output.txt
    movl $79, (%ebx, %edx, 1)    # Stampo "O"
    incl %ebx                    # Incremento contatore file output.txt
    movl $87, (%ebx, %edx, 1)    # Stampo "W"

    jmp end_vel                  # Fine stampa --> passo a end_vel

  HIGH_vel:
    incl %ebx                    # Incremento contatore file output.txt
    movl $72, (%ebx, %edx, 1)    # Stampo "H"
    incl %ebx                    # Incremento contatore file output.txt
    movl $73, (%ebx, %edx, 1)    # Stampo "I"
    incl %ebx                    # Incremento contatore file output.txt
    movl $71, (%ebx, %edx, 1)    # Stampo "G"
    incl %ebx                    # Incremento contatore file output.txt
    movl $72, (%ebx, %edx, 1)    # Stampo "H"

  end_vel:
    incl %ebx                    # Incremento contatore file output.txt
    movl $10, (%ebx, %edx, 1)    # Stampo "\n"
    incl %ebx                    # Incremento contatore file output.txt

    # Aggiorno offset output
    movl %ebx, offset_output

    # Inizializzazione registri #
    #
    # Azzero il registro ebx prima dell'utilizzo (conterrà il contatore di stringa tempo)
    xorl %ebx, %ebx
    
    # ecx contiene già l'offset di input.txt aggiornato

    # id pilota (edx) già nello stack da etichetta virgola 

    # Azzero il registro edx prima dell'utilizzo
    xorl %edx, %edx

    # Salvo l'indirizzo della stringa tempo in edx
    leal tempo, %edx

    # esi contiene già l'indirizzo di input.txt
    #

    jmp ciclo_tempo

# ############################################################################### #
# Formato stringa finale --> <rpm max>,<temp max>,<velocità max>,<velocità media> #
# ############################################################################### #

# # # # Stack Status # # # #
# > id pilota              #
# # # # # # #  # # # # # # #

stampa_finale:

  # Se op è un long, il valore ottenuto concatenando il contenuto di EDX e EAX viene diviso per l’operando (i 32 bit più significativi del dividendo sono memorizzati nel registro EDX), il quoziente viene memorizzato nel registro EAX e il resto in EDX.

  # Azzero il registro eax prima dell'utilizzo
  xorl %eax, %eax

  # Azzero il registro edx prima dell'utilizzo
  xorl %edx, %edx

  # Sposto il dividendo in eax
  movl sum_velocita, %eax

  # Divido il dividendo per counter_velocita
  divl counter_velocita

  # Salvo il valore della velocità media
  movl %eax, velocita_media

# #################### # STAMPA RPM_MAX # #################### #

  print_rpm_max:
    # Azzero registri general purpose
    #
    xorl %eax, %eax
    xorl %ebx, %ebx
    xorl %ecx, %ecx
    xorl %edx, %edx
    #

    # Salvo rpm_max in eax
    movl rpm_max, %eax

    itoa_rpm_max:
      # Confronto il valore con 10
      cmp $10, %eax

      # Salto se il valore è maggiore o uguale a 10
      jge dividi_rpm_max

      # Salvo il valore di %eax nello stack
      pushl %eax

      # Incremento %ecx (contatore push eseguite)
      incl %ecx

      # Copio il valore di %ecx in %ebx
      # Ad ogni push salvo una cifra nello stack (a partire dalla meno significativa)
      movl %ecx, %ebx

      # Salto all'etichetta di stampa
      jmp stampa_rpm_max

      dividi_rpm_max:
        # Azzero il registro ebx prima dell'utilizzo
        xorl %ebx, %ebx

        # Carico il valore 0 in %edx
        movl $0, %edx

        # Carico il valore 10 in %ebx
        movl $10, %ebx

        # Eseguo la divisione per 10 = (%edx %eax)/%ebx
        divl %ebx

        # Salvo il resto della divisione nello stack
        pushl %edx

        # Incremento il contatore delle cifre
        incl %ecx

        # Continuo a dividere il valore in %eax
        jmp itoa_rpm_max

      stampa_rpm_max:
        # Controllo se ci sono ancora caratteri da stampare
        cmp $0, %ebx

        # Se %ebx = 0 ho stampato tutte le cifre e procedo alla stampa di temp_max
        je print_temp_max

        # Recupero la cifra da stampare dallo stack
        popl %eax

        # Convesione INT --> ASCII
        addb $48, %al

        # Decremento il numero di cifre da stampare
        decl %ebx

        # Salvo %ebx nello stack (numero di cifre da stampare)
        pushl %ebx

        # Azzero il registro ebx prima dell'utilizzo
        xorl %ebx, %ebx

        # Sposto offset_output in %ebx per la stampa in output.txt
        movl offset_output, %ebx

        # Sposto address_output in %edx per la stampa in output.txt
        movl address_output, %edx

        # Stampo ","
        movb %al, (%ebx, %edx, 1)

        # Incremento contatore file output.txt
        incl %ebx

        # Aggiorno offset output
        movl %ebx, offset_output

        # Azzero il registro ebx prima dell'utilizzo
        xorl %ebx, %ebx

        # Recupero %ebx dallo stack (numero di cifre da stampare)
        popl %ebx

        # Stampo il prossimo carattere
        jmp stampa_rpm_max


# #################### # STAMPA TEMP_MAX # #################### #

  print_temp_max:
    # Azzero registri general purpose
    #
    xorl %eax, %eax
    xorl %ebx, %ebx
    xorl %ecx, %ecx
    xorl %edx, %edx
    #

    # Sposto offset_output in %ebx per la stampa in output.txt
    movl offset_output, %ebx

    # Sposto address_output in %edx per la stampa in output.txt
    movl address_output, %edx
    
    # Stampo ","
    movl $44, (%ebx, %edx, 1)

    # Incremento contatore file output.txt
    incl %ebx

    # Aggiorno offset output
    movl %ebx, offset_output

    # Salvo temp_max in eax
    movl temp_max, %eax

    itoa_temp_max:
      # Confronto il valore con 10
      cmp $10, %eax

      # Salto se il valore è maggiore o uguale a 10
      jge dividi_temp_max

      # Salvo il valore di %eax nello stack
      pushl %eax

      # Incremento %ecx (contatore push eseguite)
      incl %ecx
        
      # Azzero il registro ebx prima dell'utilizzo
      xorl %ebx, %ebx

      # Copio il valore di %ecx in %ebx
      # Ad ogni push salvo una cifra nello stack (a partire dalla meno significativa)
      movl %ecx, %ebx

      # Salto all'etichetta di stampa
      jmp stampa_temp_max

      dividi_temp_max:
        # Azzero il registro ebx prima dell'utilizzo
        xorl %ebx, %ebx

        # Carico il valore 0 in %edx
        movl $0, %edx

        # Carico il valore 10 in %ebx
        movl $10, %ebx

        # Eseguo la divisione per 10 = (%edx %eax)/%ebx
        divl %ebx

        # Salvo il resto della divisione nello stack
        pushl %edx

        # Incremento il contatore delle cifre
        incl %ecx

        # Continuo a dividere il valore in %eax
        jmp itoa_temp_max

      stampa_temp_max:
        # Controllo se ci sono ancora caratteri da stampare
        cmp $0, %ebx

        # Se %ebx = 0 ho stampato tutte le cifre e procedo alla stampa di velocita_max
        je print_velocita_max

        # Recupero la cifra da stampare dallo stack
        popl %eax

        # Convesione INT --> ASCII
        addb $48, %al

        # Decremento il numero di cifre da stampare
        decl %ebx

        # Salvo %ebx nello stack (numero di cifre da stampare)
        pushl %ebx

        # Azzero il registro ebx prima dell'utilizzo
        xorl %ebx, %ebx

        # Sposto offset_output in %ebx per la stampa in output.txt
        movl offset_output, %ebx

        # Sposto address_output in %edx per la stampa in output.txt
        movl address_output, %edx

        # Stampo ","
        movb %al, (%ebx, %edx, 1)

        # Incremento contatore file output.txt
        incl %ebx

        # Aggiorno offset output
        movl %ebx, offset_output

        # Azzero il registro ebx prima dell'utilizzo
        xorl %ebx, %ebx

        # Recupero %ebx dallo stack (numero di cifre da stampare)
        popl %ebx

        # Stampo il prossimo carattere
        jmp stampa_temp_max


# #################### # STAMPA VELOCITA_MAX # #################### #

  print_velocita_max:
    # Azzero registri general purpose
    #
    xorl %eax, %eax
    xorl %ebx, %ebx
    xorl %ecx, %ecx
    xorl %edx, %edx
    #

    # Sposto offset_output in %ebx per la stampa in output.txt
    movl offset_output, %ebx

    # Sposto address_output in %edx per la stampa in output.txt
    movl address_output, %edx
    
    # Stampo ","
    movl $44, (%ebx, %edx, 1)

    # Incremento contatore file output.txt
    incl %ebx

    # Aggiorno offset output
    movl %ebx, offset_output

    # Ripristino address output
    movl %edx, address_output

    # Salvo temp_max in eax
    movl velocita_max, %eax

    itoa_velocita_max:
      # Confronto il valore con 10
      cmp $10, %eax

      # Salto se il valore è maggiore o uguale a 10
      jge dividi_velocita_max

      # Salvo il valore di %eax nello stack
      pushl %eax

      # Incremento %ecx (contatore push eseguite)
      incl %ecx

      # Azzero il registro ebx prima dell'utilizzo
      xorl %ebx, %ebx
      
      # Copio il valore di %ecx in %ebx
      # Ad ogni push salvo una cifra nello stack (a partire dalla meno significativa)
      movl %ecx, %ebx

      # Salto all'etichetta di stampa
      jmp stampa_velocita_max

      dividi_velocita_max:
        # Azzero il registro ebx prima dell'utilizzo
        xorl %ebx, %ebx

        # Carico il valore 0 in %edx
        movl $0, %edx

        # Carico il valore 10 in %ebx
        movl $10, %ebx

        # Eseguo la divisione per 10 = (%edx %eax)/%ebx
        divl %ebx

        # Salvo il resto della divisione nello stack
        pushl %edx

        # Incremento il contatore delle cifre
        incl %ecx

        # Continuo a dividere il valore in %eax
        jmp itoa_velocita_max

      stampa_velocita_max:
        # Controllo se ci sono ancora caratteri da stampare
        cmp $0, %ebx

        # Se %ebx = 0 ho stampato tutte le cifre e procedo alla stampa di velocita_media
        je print_velocita_media

        # Recupero la cifra da stampare dallo stack
        popl %eax

        # Convesione INT --> ASCII
        addb $48, %al

        # Decremento il numero di cifre da stampare
        decl %ebx

        # Salvo %ebx nello stack (numero di cifre da stampare)
        pushl %ebx

        # Sposto offset_output in %ebx per la stampa in output.txt
        movl offset_output, %ebx

        # Sposto address_output in %edx per la stampa in output.txt
        movl address_output, %edx

        # Stampo ","
        movb %al, (%ebx, %edx, 1)

        # Incremento contatore file output.txt
        incl %ebx

        # Aggiorno offset output
        movl %ebx, offset_output
        
        # Azzero il registro ebx prima dell'utilizzo
        xorl %ebx, %ebx

        # Recupero %ebx dallo stack (numero di cifre da stampare)
        popl %ebx

        # Stampo il prossimo carattere
        jmp stampa_velocita_max


# #################### # STAMPA VELOCITA_MEDIA # #################### #

  print_velocita_media:
    # Azzero registri general purpose
    #
    xorl %eax, %eax
    xorl %ebx, %ebx
    xorl %ecx, %ecx
    xorl %edx, %edx
    #

    # Sposto offset_output in %ebx per la stampa in output.txt
    movl offset_output, %ebx
    
    # Sposto address_output in %edx per la stampa in output.txt
    movl address_output, %edx
    
    # Stampo ","
    movl $44, (%ebx, %edx, 1)

    # Incremento contatore file output.txt
    incl %ebx

    # Aggiorno offset output
    movl %ebx, offset_output

    # Ripristino address output
    movl %edx, address_output

    # Salvo temp_max in eax
    movl velocita_media, %eax

    itoa_velocita_media:
      # Confronto il valore con 10
      cmp $10, %eax

      # Salto se il valore è maggiore o uguale a 10
      jge dividi_velocita_media

      # Salvo il valore di %eax nello stack
      pushl %eax

      # Incremento %ecx (contatore push eseguite)
      incl %ecx

      # Azzero il registro ebx prima dell'utilizzo
      xorl %ebx, %ebx

      # Copio il valore di %ecx in %ebx
      # Ad ogni push salvo una cifra nello stack (a partire dalla meno significativa)
      movl %ecx, %ebx

      # Salto all'etichetta di stampa
      jmp stampa_velocita_media

      dividi_velocita_media:
        # Azzero il registro ebx prima dell'utilizzo
        xorl %ebx, %ebx

        # Carico il valore 0 in %edx
        movl $0, %edx

        # Carico il valore 10 in %ebx
        movl $10, %ebx

        # Eseguo la divisione per 10 = (%edx %eax)/%ebx
        divl %ebx

        # Salvo il resto della divisione nello stack
        pushl %edx

        # Incremento il contatore delle cifre
        incl %ecx

        # Continuo a dividere il valore in %eax
        jmp itoa_velocita_media

      stampa_velocita_media:
        # Controllo se ci sono ancora caratteri da stampare
        cmp $0, %ebx

        # Se %ebx = 0 ho stampato tutte le cifre termino l'esecuzione di verifica_riga
        je end

        # Recupero la cifra da stampare dallo stack
        popl %eax

        # Convesione INT --> ASCII
        addb $48, %al

        # Decremento il numero di cifre da stampare
        decl %ebx

        # Salvo %ebx nello stack (numero di cifre da stampare)
        pushl %ebx

        # Sposto offset_output in %ebx per la stampa in output.txt
        movl offset_output, %ebx

        # Sposto address_output in %edx per la stampa in output.txt
        movl address_output, %edx

        # Stampo ","
        movb %al, (%ebx, %edx, 1)

        # Incremento contatore file output.txt
        incl %ebx

        # Aggiorno offset output
        movl %ebx, offset_output
    
        # Ripristino address output
        movl %edx, address_output

        # Azzero il registro ebx prima dell'utilizzo
        xorl %ebx, %ebx

        # Recupero %ebx dallo stack (numero di cifre da stampare)
        popl %ebx

        # Stampo il prossimo carattere
        jmp stampa_velocita_media

end:
  # Arrivato qui ho già address_output in edx #
  # Sposto offset_output in %ebx per la stampa in output.txt
  movl offset_output, %ebx
  
  # Stampo "\n"
  movl $10, (%ebx, %edx, 1)

  # Recupero dallo stack ID pilota se ciclo_tempo trova \0
  popl %edx

  ret

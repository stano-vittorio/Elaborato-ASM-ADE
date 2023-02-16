.section .data

ebp_value:
  .long 0

.section .text
  .global telemetry

telemetry:
  movl %ebp, ebp_value         # Salvo ebp nella variabile ebp_value
  movl %esp, %ebp              # Imposto il nuovo base pointer

  pushl %eax                   # Salvo eax nello stack
  pushl %ebx                   # Salvo ebx nello stack
  pushl %ecx                   # Salvo ecx nello stack
  pushl %edx                   # Salvo edx nello stack

  xorl %eax, %eax              # Azzero registro eax
  xorl %ebx, %ebx              # Azzero registro ebx
  xorl %ecx, %ecx              # Azzero registro ecx
  xorl %edx, %edx              # Azzero registro edx

  call controllo_piloti         # Chiamo funzione controllo_piloti
  
  # # # # Essential Registers Status # # # #
  # esi -> address input                   #
  # ecx -> offset input                    #
  # edx -> id pilot                        #
  # # # # # # # # # #  # # # # # # # # # # #

  # ID pilota verificato è in edx, se edx = 20 --> Invalid = nessun pilota trovato

  cmp $20, %dl                 # Se ID = 20 (valore non valido)
  je printInvalid              # Stampo "Invalid"

  xorl %eax, %eax              # Azzero registro eax
  xorl %ebx, %ebx              # Azzero registro ebx

  call verifica_riga           # Chiamo funzione verifica_riga
  jmp exit                     # Salto all'etichetta exit

printInvalid:
  xorl %ecx, %ecx              # Azzero registro ecx
  xorl %esi, %esi              # Azzero registro esi

  movl 8(%ebp), %esi           # Salvo in esi il puntatore al file output.txt

  movl $73, (%ecx, %esi, 1)    # Stampo "I"
  incl %ecx                    # Incremento contatore file output.txt
  movl $110, (%ecx, %esi, 1)   # Stampo "n"
  incl %ecx                    # Incremento contatore file output.txt
  movl $118, (%ecx, %esi, 1)   # Stampo "v"
  incl %ecx                    # Incremento contatore file output.txt
  movl $97, (%ecx, %esi, 1)    # Stampo "a"
  incl %ecx                    # Incremento contatore file output.txt
  movl $108, (%ecx, %esi, 1)   # Stampo "l"
  incl %ecx                    # Incremento contatore file output.txt
  movl $105, (%ecx, %esi, 1)   # Stampo "i"
  incl %ecx                    # Incremento contatore file output.txt
  movl $100, (%ecx, %esi, 1)   # Stampo "d"
  incl %ecx                    # Incremento contatore file output.txt
  movl $10, (%ecx, %esi, 1)    # Stampo "\n"

exit:
  xorl %edx, %edx              # Azzero registro edx
  xorl %ecx, %ecx              # Azzero registro ecx
  xorl %ebx, %ebx              # Azzero registro ebx
  xorl %eax, %eax              # Azzero registro eax
  
  popl %edx                    # Recupero edx dallo stack
  popl %ecx                    # Recupero ecx dallo stack
  popl %ebx                    # Recupero ebx dallo stack
  popl %eax                    # Recupero eax dallo stack

  movl ebp_value, %ebp         # Ripristino ebp

ret                            # Esco dalla funzione telemetry.s

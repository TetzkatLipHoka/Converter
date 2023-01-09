{$IFDEF EFLAGS_BACKUP}
  {$IFDEF Win64}
    PUSH RCX
    PUSHFQ
    POP RAX // RAX = EFLAGS
    MOV RCX, RAX // Save the original EFLAGS value

    XOR RAX, RAX // EFLAGS=0
    PUSH RAX
    POPFQ // Set the new EFLAGS value
  {$ELSE}
    PUSH ECX
    push eax // Store A
    PUSHFD
    POP EAX // EAX = EFLAGS
    MOV ECX, EAX // Save the original EFLAGS value

    XOR EAX, EAX // EFLAGS=0
    PUSH EAX
    POPFD // Set the new EFLAGS value
  {$ENDIF}
{$ENDIF}

{$IFDEF EFLAGS_RESTORE}
  {$IFDEF Win64}
    PUSHFQ
    POP RAX // Read EFLAGS
    PUSH RCX
    POPFQ // Restore original EFLAGS value
    POP RCX
  {$ELSE}
    PUSHFD
    POP EAX { Read EFLAGS }
    PUSH ECX
    POPFD // Restore original EFLAGS value
    POP ECX
  {$ENDIF}
{$ENDIF}

PROCESS BEFORE OUTPUT.
  MODULE status_0400.
  MODULE modify_screen.
*
PROCESS AFTER INPUT.
  MODULE user_command_0400.
  FIELD zeway_bill-reason MODULE require_field.


PROCESS ON VALUE-REQUEST.
  FIELD zeway_bill-fromstatecode MODULE input_help_state_code.

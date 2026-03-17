*&---------------------------------------------------------------------*
*& Report ZGATEOUT_CHANGE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZGATEOUT_CHANGE.

INCLUDE ZGATEOUT_CHANGE_SS.
INCLUDE ZGATEOUT_CHANGE_TOP.
INCLUDE ZGATEOUT_CHANGE_PBO.
INCLUDE ZGATEOUT_CHANGE_PAI.
INCLUDE ZGATEOUT_CHANGE_DATA.

START-OF-SELECTION.

SELECT SINGLE ZNUMBER_01, ZDELETE_IND FROM ZGATE_OUT INTO @DATA(WA_X) WHERE ZNUMBER_01 = @p_number.
IF WA_X-zdelete_ind IS NOT INITIAL  .
  MESSAGE |Allready deleted Gateout entry | && WA_X-znumber_01 type 'E' .
ENDIF.

PERFORM GET_ENTRY.

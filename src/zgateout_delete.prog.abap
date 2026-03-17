*&---------------------------------------------------------------------*
*& Report ZGATEOUT_DELETE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZGATEOUT_DELETE.

INCLUDE ZGATEOUT_DELETE_SS.
INCLUDE ZGATEOUT_DELETE_TOP.
INCLUDE ZGATEOUT_DELETE_PBO.
INCLUDE ZGATEOUT_DELETE_PAI.
INCLUDE ZGATEOUT_DELETE_DATA.


START-OF-SELECTION.

SELECT SINGLE ZNUMBER_01, ZDELETE_IND FROM ZGATE_OUT INTO @DATA(WA_X) WHERE ZNUMBER_01 = @p_number.
IF WA_X-zdelete_ind IS NOT INITIAL  .
  MESSAGE |Allready deleted Gateout entry | && WA_X-znumber_01 type 'E' .
ENDIF.

PERFORM GET_DATA.

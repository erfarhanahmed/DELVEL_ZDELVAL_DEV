*---------------------------------------------------------------------*
*    program for:   TABLEFRAME_ZSU_CHALLANNO
*---------------------------------------------------------------------*
FUNCTION TABLEFRAME_ZSU_CHALLANNO      .

  PERFORM TABLEFRAME TABLES X_HEADER X_NAMTAB DBA_SELLIST DPL_SELLIST
                            EXCL_CUA_FUNCT
                     USING  CORR_NUMBER VIEW_ACTION VIEW_NAME.

ENDFUNCTION.

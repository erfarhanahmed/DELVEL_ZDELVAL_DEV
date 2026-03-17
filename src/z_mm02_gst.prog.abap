report Z_MM02_GST
       no standard page heading line-size 255.

*include bdcrecx1.

TYPES : BEGIN OF ty_final,
          matnr TYPE string,
          ccode TYPE string,
          werks TYPE string,
          sorg  TYPE string,
          dch   TYPE string,
          steuc TYPE string,
          tax1 TYPE string,
          tax2 TYPE string,
          tax3 TYPE string,
          tax4 TYPE string,
          tax5 TYPE string,
          tax6 TYPE string,
          tax7 TYPE string,
        END OF ty_final.


 DATA: LT_FINAL TYPE TABLE OF ty_FINAL ,
       LS_FINAL TYPe ty_FINAL ,
       LT_BDCDATA TYPE TABLE OF BDCDATA ,
       LT_message TYPE TABLE OF BDcmsgcoll,
       ls_message TYPE BDcmsgcoll,
       LS_BDCDATA TYPE  BDCDATA ,
       TEXT(4096) TYPE C OCCURS 0.


  PARAMETERS: P_FILE TYPE RLGRAP-FILENAME,
              p_mode TYPE ctu_params-dismode default 'E',
              R_CODE RADIOBUTTON GROUP RD1,
              R_EXTEN RADIOBUTTON GROUP RD1.

  AT SELECTION-SCREEN ON VALUE-REQUEST FOR P_FILE.

    CALL FUNCTION 'F4_FILENAME'
*     EXPORTING
*       PROGRAM_NAME        = SYST-CPROG
*       DYNPRO_NUMBER       = SYST-DYNNR
*       FIELD_NAME          = ' '
     IMPORTING
       FILE_NAME           = P_FILE
              .

*include bdcrecx1.

start-of-selection.


CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
  EXPORTING
*   I_FIELD_SEPERATOR          =
   I_LINE_HEADER              = 'X'
    I_TAB_RAW_DATA             = TEXT[]
    I_FILENAME                 = P_FILE
  TABLES
    I_TAB_CONVERTED_DATA       = lT_FINAL[]
 EXCEPTIONS
   CONVERSION_FAILED          = 1
   OTHERS                     = 2
          .
IF SY-SUBRC <> 0.
* Implement suitable error handling here
ENDIF.

data: ls_mara TYPE mara,
      ls_makt TYPE makt,
      ls_mvke TYPE mvke.


LOOP AT LT_FINAL INTO LS_FINAL.
REFRESH lt_bdcdata .

*CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
*  EXPORTING
*    input         = LS_FINAL-MATNR
* IMPORTING
*   OUTPUT        = LS_FINAL-MATNR
          .

       CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
         EXPORTING
           input              = LS_FINAL-MATNR
        IMPORTING
          OUTPUT             = LS_FINAL-MATNR
        EXCEPTIONS
          LENGTH_ERROR       = 1
          OTHERS             = 2
                 .
       IF sy-subrc <> 0.
* Implement suitable error handling here
       ENDIF.



SELECt SINGLE *
  FROM mara
  INTO ls_mara
  WHERE matnr =  ls_final-matnr.



SELECT SINGLE *
  FROM makt
  INTO ls_makt
  WHERE matnr = ls_final-matnr.

IF R_CODE = 'X'.
***********UPDATE CONTROL CODE*******************

IF LS_MARA-MTART = 'ROH' OR LS_MARA-MTART = 'HALB' .

perform bdc_dynpro      using 'SAPLMGMM' '0060'.
perform bdc_field       using 'BDC_CURSOR'
                              'RMMG1-MATNR'.
perform bdc_field       using 'BDC_OKCODE'
                              '=ENTR'.
perform bdc_field       using 'RMMG1-MATNR'
                              ls_final-matnr .
perform bdc_dynpro      using 'SAPLMGMM' '0070'.
perform bdc_field       using 'BDC_CURSOR'
                              'MSICHTAUSW-DYTXT(09)'.
perform bdc_field       using 'BDC_OKCODE'
                              '=ENTR'.
perform bdc_field       using 'MSICHTAUSW-KZSEL(09)'
                              'X'.
perform bdc_dynpro      using 'SAPLMGMM' '0080'.
perform bdc_field       using 'BDC_CURSOR'
                              'RMMG1-WERKS'.
perform bdc_field       using 'BDC_OKCODE'
                              '=ENTR'.
perform bdc_field       using 'RMMG1-WERKS'
                              ls_final-werks.
perform bdc_dynpro      using 'SAPLMGMM' '4004'.
perform bdc_field       using 'BDC_OKCODE'
                              '/00'.
*perform bdc_field       using 'MAKT-MAKTX'
*                              'Decimal ROH 2'.
perform bdc_field       using 'BDC_CURSOR'
                              'MARC-STEUC'.
perform bdc_field       using 'MARC-STEUC'
                              ls_final-steuc.
perform bdc_dynpro      using 'SAPLSPO1' '0300'.
perform bdc_field       using 'BDC_OKCODE'
                              '=YES'.
ELSEIF ls_mara-mtart = 'FERT'.


perform bdc_dynpro      using 'SAPLMGMM' '0060'.
perform bdc_field       using 'BDC_CURSOR'
                              'RMMG1-MATNR'.
perform bdc_field       using 'BDC_OKCODE'
                              '=AUSW'.
perform bdc_field       using 'RMMG1-MATNR'
                              LS_FINAL-matnr.
perform bdc_dynpro      using 'SAPLMGMM' '0070'.
perform bdc_field       using 'BDC_CURSOR'
                              'MSICHTAUSW-DYTXT(06)'.
perform bdc_field       using 'BDC_OKCODE'
                              '=ENTR'.
perform bdc_field       using 'MSICHTAUSW-KZSEL(06)'
                              'X'.
perform bdc_dynpro      using 'SAPLMGMM' '0080'.
perform bdc_field       using 'BDC_CURSOR'
                              'RMMG1-VTWEG'.
perform bdc_field       using 'BDC_OKCODE'
                              '=ENTR'.
perform bdc_field       using 'RMMG1-WERKS'
                              LS_FINAL-WERKS. "'pl01'.
perform bdc_field       using 'RMMG1-VKORG'
                              '1000'.
perform bdc_field       using 'RMMG1-VTWEG'
                              LS_FINAL-dch. "'10'.
perform bdc_dynpro      using 'SAPLMGMM' '4004'.
perform bdc_field       using 'BDC_OKCODE'
                              '/00'.
*perform bdc_field       using 'MAKT-MAKTX'
*                              'FG - Butterfly Valve'.
perform bdc_field       using 'BDC_CURSOR'
                              'MARC-STEUC'.
perform bdc_field       using 'MARC-STEUC'
                              LS_FINAL-steuc.
perform bdc_dynpro      using 'SAPLSPO1' '0300'.
perform bdc_field       using 'BDC_OKCODE'
                              '=YES'.
**-----------------------------------------------------
ELSE .
perform bdc_dynpro      using 'SAPLMGMM' '0060'.
perform bdc_field       using 'BDC_CURSOR'
                              'RMMG1-MATNR'.
perform bdc_field       using 'BDC_OKCODE'
                              '=ENTR'.
perform bdc_field       using 'RMMG1-MATNR'
                              ls_final-matnr.
perform bdc_dynpro      using 'SAPLMGMM' '0070'.
perform bdc_field       using 'BDC_CURSOR'
                              'MSICHTAUSW-DYTXT(09)'.
perform bdc_field       using 'BDC_OKCODE'
                              '=ENTR'.
perform bdc_field       using 'MSICHTAUSW-KZSEL(09)'
                              'X'.
perform bdc_dynpro      using 'SAPLMGMM' '0080'.
perform bdc_field       using 'BDC_CURSOR'
                              'RMMG1-WERKS'.
perform bdc_field       using 'BDC_OKCODE'
                              '=ENTR'.
perform bdc_field       using 'RMMG1-WERKS'
                              ls_final-werks.
perform bdc_dynpro      using 'SAPLMGMM' '4000'.
perform bdc_field       using 'BDC_OKCODE'
                              '/00'.
*perform bdc_field       using 'MAKT-MAKTX'
*                              'EXPORT WOODEN BOXES IN INCH 30 X 46 X'
*                            & '20'.
perform bdc_field       using 'BDC_CURSOR'
                              'MARC-STEUC'.
perform bdc_field       using 'MARC-STEUC'
                              ls_final-steuc.
perform bdc_dynpro      using 'SAPLSPO1' '0300'.
perform bdc_field       using 'BDC_OKCODE'
                              '=YES'.

endif.

call transaction 'MM02' USING LT_BDCDATA MESSAGES INTO lt_message
      MODE p_mode
      UPDATE 'S'.

     READ TABLE lt_message INTO LS_MESSAGE
     WITH KEY MSGTyP = 'S'.

     IF SY-subrc IS INITIAL.
        write :/ '--------------------------'.
       Write:/  'Material ', ls_final-matnr, ' Updated'.

      ELSE.
      LOOP AT lt_message INTO ls_message.
       write :/ '--------------------------'.
        WRITE: / ls_message-MSGV1, ls_message-MSGV2, ls_message-MSGV3, ls_message-MSGV4 .
      ENDLOOP.
    ENDif.

ELSEIF R_EXTEN = 'X'.

*  REFRESH lt_bdcdata.

*SELECT SINGLE *
*  FROM mvke
*  INTO ls_mvke
*  WHERE matnr =  ls_final-matnr.
 if ls_mara-MTART = 'FERT'.

perform bdc_dynpro      using 'SAPLMGMM' '0060'.
perform bdc_field       using 'BDC_CURSOR'
                              'RMMG1-MATNR'.
perform bdc_field       using 'BDC_OKCODE'
                              '=ENTR'.
perform bdc_field       using 'RMMG1-MATNR'
                              LS_FINAL-matnr .".'CON123-COTTON'.
*perform bdc_field       using 'RMMG1-MBRSH'
*                              LS_MARA-'M'.
*perform bdc_field       using 'RMMG1-MTART'
*                              'ROH'.
*perform bdc_field       using 'RMMG1_REF-MATNR'
*                              ''.
perform bdc_dynpro      using 'SAPLMGMM' '0070'.
perform bdc_field       using 'BDC_CURSOR'
                              'MSICHTAUSW-DYTXT(06)'.
perform bdc_field       using 'BDC_OKCODE'
                              '=ENTR'.
perform bdc_field       using 'MSICHTAUSW-KZSEL(04)'
                              'X'.
perform bdc_field       using 'MSICHTAUSW-KZSEL(05)'
                              'X'.
perform bdc_field       using 'MSICHTAUSW-KZSEL(06)'
                              'X'.
perform bdc_dynpro      using 'SAPLMGMM' '0080'.
perform bdc_field       using 'BDC_CURSOR'
                              'RMMG1-VTWEG'.
perform bdc_field       using 'BDC_OKCODE'
                              '=ENTR'.
perform bdc_field       using 'RMMG1-WERKS'
                              LS_FINAL-WERKS." "'pl01'.
perform bdc_field       using 'RMMG1-VKORG'
                              '1000'.
perform bdc_field       using 'RMMG1-VTWEG'
                              LS_FINAL-dch ."'10'.
perform bdc_dynpro      using 'SAPLMGMM' '4000'.
perform bdc_field       using 'BDC_OKCODE'
                              '/00'.
perform bdc_field       using 'BDC_CURSOR'
                              'MAKT-MAKTX'.
*perform bdc_field       using 'MAKT-MAKTX'
*                              LS_MAKT-MAKTX. "'Cotton cloth'.
**perform bdc_field       using 'MVKE-SKTOF'
*                              ls_mvke-sktof ."'X'.
perform bdc_dynpro      using 'SAPLMGMM' '4200'.
perform bdc_field       using 'BDC_OKCODE'
                              '/00'.
*perform bdc_field       using 'MAKT-MAKTX'
*                              LS_MAKT-MAKTX. "'Cotton cloth'.
perform bdc_field       using 'BDC_CURSOR'
                              'MG03STEUER-TAXKM(07)'.
perform bdc_field       using 'MG03STEUER-TAXKM(01)'
                              LS_FINAL-tax1.
perform bdc_field       using 'MG03STEUER-TAXKM(02)'
                              LS_FINAL-tax2. "'0'.
perform bdc_field       using 'MG03STEUER-TAXKM(03)'
                              LS_FINAL-tax3. "'0'.
perform bdc_field       using 'MG03STEUER-TAXKM(04)'
                              LS_FINAL-tax4. "'0'.
perform bdc_field       using 'MG03STEUER-TAXKM(05)'
                              LS_FINAL-tax5. "'0'.
perform bdc_field       using 'MG03STEUER-TAXKM(06)'
                              LS_FINAL-tax6. "'0'.
perform bdc_field       using 'MG03STEUER-TAXKM(07)'
                              LS_FINAL-tax7. "'0'.
perform bdc_dynpro      using 'SAPLMGMM' '4000'.
perform bdc_field       using 'BDC_OKCODE'
                              '/00'.
*perform bdc_field       using 'MAKT-MAKTX'
*                              LS_MAKT-maktx ."'Cotton cloth'.
*perform bdc_field       using 'MVKE-SKTOF'
*                              ls_mvke-sktof . "'X'.
perform bdc_field       using 'BDC_CURSOR'
                              'MG03STEUER-TAXKM(01)'.
perform bdc_dynpro      using 'SAPLMGMM' '4000'.
perform bdc_field       using 'BDC_OKCODE'
                              '/00'.
*perform bdc_field       using 'MAKT-MAKTX'
*                              LS_MAKT-maktx ."'Cotton cloth'.
perform bdc_field       using 'BDC_CURSOR'
                              'MVKE-MTPOS'.
perform bdc_field       using 'MVKE-KTGRM'
                              '03'.
perform bdc_field       using 'MVKE-MTPOS'
                              'NORM'.
perform bdc_dynpro      using 'SAPLMGMM' '4000'.
perform bdc_field       using 'BDC_OKCODE'
                              '/00'.
*perform bdc_field       using 'MAKT-MAKTX'
*                              LS_MAKT-maktx ."'Cotton cloth'.
*perform bdc_field       using 'MARA-GEWEI\'
*                              'KG'.
perform bdc_field       using 'BDC_CURSOR'
                              'MARC-LADGR'.
perform bdc_field       using 'MARA-TRAGR'
                              '0001'.
perform bdc_field       using 'MARC-LADGR'
                              '0001'.
perform bdc_dynpro      using 'SAPLSPO1' '0300'.
perform bdc_field       using 'BDC_OKCODE'
                              '=YES'.

ELSEIF ls_mara-MTARt = 'ROH' or ls_mara-MTARt = 'HALB'.

perform bdc_dynpro      using 'SAPLMGMM' '0060'.
perform bdc_field       using 'BDC_CURSOR'
                              'RMMG1-MATNR'.
perform bdc_field       using 'BDC_OKCODE'
                              '=ENTR'.
perform bdc_field       using 'RMMG1-MATNR'
                              LS_FINAL-MATNR .
*perform bdc_field       using 'RMMG1-MBRSH'
*                              'M'.
*perform bdc_field       using 'RMMG1-MTART'
*                              'ROH'.
perform bdc_dynpro      using 'SAPLMGMM' '0070'.
perform bdc_field       using 'BDC_CURSOR'
                              'MSICHTAUSW-DYTXT(06)'.
perform bdc_field       using 'BDC_OKCODE'
                              '=ENTR'.
perform bdc_field       using 'MSICHTAUSW-KZSEL(04)'
                              'X'.
perform bdc_field       using 'MSICHTAUSW-KZSEL(05)'
                              'X'.
perform bdc_field       using 'MSICHTAUSW-KZSEL(06)'
                              'X'.
perform bdc_dynpro      using 'SAPLMGMM' '0080'.
perform bdc_field       using 'BDC_CURSOR'
                              'USRM1-ASCHL'.
perform bdc_field       using 'BDC_OKCODE'
                              '=ENTR'.
perform bdc_field       using 'RMMG1-WERKS'
                              LS_FINAL-WERKS. "'PL01'.
perform bdc_field       using 'RMMG1-VKORG'
                              '1000'.
perform bdc_field       using 'RMMG1-VTWEG'
                              LS_FINAL-dch. "'10'.
perform bdc_dynpro      using 'SAPLMGMM' '4000'.
perform bdc_field       using 'BDC_OKCODE'
                              '/00'.
perform bdc_field       using 'BDC_CURSOR'
                              'MAKT-MAKTX'.
*perform bdc_field       using 'MAKT-MAKTX'
*                              'Decimal ROH 2'.
*perform bdc_field       using 'MVKE-SKTOF'
*                              'X'.
perform bdc_dynpro      using 'SAPLMGMM' '4200'.
perform bdc_field       using 'BDC_OKCODE'
                              '/00'.
*perform bdc_field       using 'MAKT-MAKTX'
*                              'Decimal ROH 2'.
perform bdc_field       using 'BDC_CURSOR'
                              'MG03STEUER-TAXKM(07)'.
perform bdc_field       using 'MG03STEUER-TAXKM(01)'
                              LS_FINAL-TAX1. "'0'.
perform bdc_field       using 'MG03STEUER-TAXKM(02)'
                              LS_FINAL-TAX2."'0'.
perform bdc_field       using 'MG03STEUER-TAXKM(03)'
                              LS_FINAL-TAX3."'0'.
perform bdc_field       using 'MG03STEUER-TAXKM(04)'
                              LS_FINAL-TAX4."'0'.
perform bdc_field       using 'MG03STEUER-TAXKM(05)'
                              LS_FINAL-TAX5."'0'.
perform bdc_field       using 'MG03STEUER-TAXKM(06)'
                              LS_FINAL-TAX6."'0'.
perform bdc_field       using 'MG03STEUER-TAXKM(07)'
                              LS_FINAL-TAX7."'0'.
perform bdc_dynpro      using 'SAPLMGMM' '4000'.
perform bdc_field       using 'BDC_OKCODE'
                              '/00'.
*perform bdc_field       using 'MAKT-MAKTX'
*                              'Decimal ROH 2'.
*perform bdc_field       using 'MVKE-SKTOF'
*                              'X'.
perform bdc_field       using 'BDC_CURSOR'
                              'MG03STEUER-TAXKM(01)'.
perform bdc_dynpro      using 'SAPLMGMM' '4000'.
perform bdc_field       using 'BDC_OKCODE'
                              '/00'.
*perform bdc_field       using 'MAKT-MAKTX'
*                              'Decimal ROH 2'.
perform bdc_field       using 'BDC_CURSOR'
                              'MVKE-MTPOS'.
perform bdc_field       using 'MVKE-KTGRM'
                              '02'.
perform bdc_field       using 'MVKE-MTPOS'
                              'NORM'.
perform bdc_dynpro      using 'SAPLMGMM' '4000'.
perform bdc_field       using 'BDC_OKCODE'
                              '/00'.
*perform bdc_field       using 'MAKT-MAKTX'
*                              'Decimal ROH 2'.
*perform bdc_field       using 'MARA-GEWEI'
*                              'KG'.
perform bdc_field       using 'MARC-MTVFP'
                              '01'.
perform bdc_field       using 'BDC_CURSOR'
                              'MARC-LADGR'.
perform bdc_field       using 'MARA-TRAGR'
                              '0001'.
perform bdc_field       using 'MARC-LADGR'
                              '0001'.
perform bdc_dynpro      using 'SAPLSPO1' '0300'.
perform bdc_field       using 'BDC_OKCODE'
                              '=YES'.
endif.

call transaction 'MM01' USING LT_BDCDATA MESSAGES INTO lt_message
      MODE p_mode
      UPDATE 'S'.


        READ TABLE lt_message INTO LS_MESSAGE
     WITH KEY MSGTyP = 'S'.

     IF SY-subrc IS INITIAL.
        write :/ '--------------------------'.
       Write:/  'Material ', ls_final-matnr, ' Updated'.

      ELSE.
      LOOP AT lt_message INTO ls_message.
       write :/ '--------------------------'.
        WRITE: / ls_message-MSGV1, ls_message-MSGV2, ls_message-MSGV3, ls_message-MSGV4 .
      ENDLOOP.
    ENDif.

ENDIF.

*perform bdc_transaction using 'MM02'.
***********UPDATE CONTROL CODE*******************
******************************


endloop.


*----------------------------------------------------------------------*
*        Start new screen                                              *
*----------------------------------------------------------------------*
FORM BDC_DYNPRO USING PROGRAM DYNPRO.
  CLEAR ls_BDCDATA.
  ls_BDCDATA-PROGRAM  = PROGRAM.
  ls_BDCDATA-DYNPRO   = DYNPRO.
  ls_BDCDATA-DYNBEGIN = 'X'.
  APPEND ls_BDCDATA TO lt_BDCDATA.
ENDFORM.

*----------------------------------------------------------------------*
*        Insert field                                                  *
*----------------------------------------------------------------------*
FORM BDC_FIELD USING FNAM FVAL.
*  IF FVAL <> NODATA.
    CLEAR ls_BDCDATA.
    ls_BDCDATA-FNAM = FNAM.
    ls_BDCDATA-FVAL = FVAL.
    APPEND ls_BDCDATA to lt_BDCDATA.
*  ENDIF.
ENDFORM.




*perform close_group.

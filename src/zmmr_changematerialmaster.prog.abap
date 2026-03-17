*&---------------------------------------------------------------------*
*& Report  ZMMR_CHANGEMATERIALMASTER
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT zmmr_changematerialmaster.
TABLES sscrfields.
TYPE-POOLS truxs.
*-----------------------------------------------------------------*
* Data Decleration                                                *
*-----------------------------------------------------------------*
TYPES : BEGIN OF ty_list,
          matnr TYPE string,
          ccode TYPE string,
          werks TYPE string,
          sorg  TYPE string,
          dch   TYPE string,
          steuc TYPE string,
          taxim TYPE string,
          tax_type_1 TYPE string,
          taxclass_1 TYPE string,
          tax_type_2 TYPE string,
          taxclass_2 TYPE string,
          tax_type_3 TYPE string,
          taxclass_3 TYPE string,
          tax_type_4 TYPE string,
          taxclass_4 TYPE string,
          tax_type_5 TYPE string,
          taxclass_5 TYPE string,
          tax_type_6 TYPE string,
          taxclass_6 TYPE string,
          tax_type_7 TYPE string,
          taxclass_7 TYPE string,
          tax_type_8 TYPE string,
          taxclass_8 TYPE string,
        END OF ty_list.

DATA : it_type TYPE truxs_t_text_data.

DATA : lt_list TYPE STANDARD TABLE OF ty_list,
       ls_list TYPE ty_list.

DATA: clidainp            LIKE  bapi_mara_ga,
      plantdata           type  bapi_marc_ga, "BAPI_MARC_GA
      plantdata1          LIKE  bapi_marc,
      forecastparameters  LIKE  bapi_mpop_ga,
      planningdata        LIKE  bapi_mpgd_ga,
      storagelocationdata LIKE  bapi_mard_ga,
      valuationdata       LIKE  bapi_mbew_ga,
      warehousenumberdata LIKE  bapi_mlgn_ga,
      salesdata           LIKE  bapi_mvke_ga,
      storagetypedata     LIKE  bapi_mlgt_ga,
      prtdata             LIKE  bapi_mfhm_ga,
      lifovaluationdata   LIKE  bapi_myms_ga,
      is_mp_clientdata    LIKE  /sapmp/bapi_mara.

DATA : materialdescription  LIKE  bapi_makt_ga OCCURS 0 WITH HEADER LINE,
       unitsofmeasure       LIKE  bapi_marm_ga OCCURS 0 WITH HEADER LINE,
       internationalartnos  LIKE  bapi_mean_ga OCCURS 0 WITH HEADER LINE,
       materiallongtext     LIKE  bapi_mltx_ga OCCURS 0 WITH HEADER LINE,
       taxclassifications   LIKE  bapi_mlan_ga OCCURS 0 WITH HEADER LINE,
       taxclassifications1  LIKE  bapi_mlan    OCCURS 0 WITH HEADER LINE,
       extensionout         LIKE  bapiparex OCCURS 0 WITH HEADER LINE.

*DATA:  plantdata LIKE  bapi_marc,
*       taxclassifications LIKE bapi_mlan OCCURS 0 WITH HEADER LINE.

DATA: xdmlan LIKE xdmlan OCCURS 0 WITH HEADER LINE,
      marc   LIKE marc OCCURS 0 WITH HEADER LINE.

DATA: "plantdata  LIKE bapi_marc,
      plantdata1x LIKE bapi_marcx,

      headdata  LIKE  bapimathead,
      return    LIKE  bapiret2,
      returnmes LIKE bapi_matreturn2 OCCURS 0 WITH HEADER LINE.

* Get Material Number to be processed
*DATA: material TYPE  string,"bapi_mara_ga-material,
*      plant    TYPE  string,"bapi_marc_ga-plant,
*      ccode    TYPE  string,"bapi0002_1-comp_code,
*      sorg     TYPE  string, " bapi_mvke_ga-sales_org,
*      dch      TYPE  string. "bapi_mvke_ga-distr_chan.

DATA: material like  bapi_mara_ga-material,
      plant    like  bapi_marc_ga-plant,
      ccode    like  bapi0002_1-comp_code,
      sorg     like  bapi_mvke_ga-sales_org,
      dch      like  bapi_mvke_ga-distr_chan.


*LIKE
*LIKE
*LIKE
*LIKE
*LIKE
*-----------------------------------------------------------------*
* Selection Screen                                                *
*-----------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
PARAMETERS:  p_file LIKE rlgrap-filename.
*PARAMETERS:  p_mode LIKE ibipparms-callmode OBLIGATORY DEFAULT 'A'.
"A: show all dynpros
"E: show dynpro on error only
"N: do not display dynpro
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN FUNCTION KEY 1.
INITIALIZATION.
  MOVE 'Excel' TO sscrfields-functxt_01.


AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
  PERFORM get_filename.

AT SELECTION-SCREEN.
  IF sscrfields-ucomm = 'FC01'.
    SUBMIT zmmi_mm02_excel_upload.
  ENDIF.

*-----------------------------------------------------------------*
* Start of Selection                                              *
*-----------------------------------------------------------------*
START-OF-SELECTION.
  PERFORM upload_data.

  LOOP AT lt_list INTO ls_list.
    material = ls_list-matnr.
    plant    = ls_list-werks.
    ccode    = ls_list-ccode.
    sorg     = ls_list-sorg.
    dch      = ls_list-dch.

CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
  EXPORTING
    input         = material
 IMPORTING
   OUTPUT        = material.
          .

translate  material to UPPER CASE .
TRanslate  plant to UPPER CASE .
   .

   CALL FUNCTION 'BAPI_MATERIAL_GET_ALL'
    EXPORTING
      MATERIAL                   = material
      COMP_CODE                  = ccode
*      VAL_AREA                   =
*      VAL_TYPE                   =
      PLANT                      =  plant
*      STGE_LOC                   =
      SALESORG                   =  sorg
      DISTR_CHAN                 =  dch
*      WHSENUMBER                 =
*      STGE_TYPE                  =
*      LIFO_VALUATION_LEVEL       =
*      KZRFB_ALL                  =
*      MATERIAL_LONG              =
    IMPORTING
      CLIENTDATA                 = clidainp
      PLANTDATA                  = plantdata
*      FORECASTPARAMETERS         =
*      PLANNINGDATA               =
*      STORAGELOCATIONDATA        =
*      VALUATIONDATA              =
*      WAREHOUSENUMBERDATA        =
*      SALESDATA                  =
*      STORAGETYPEDATA            =
*      PRTDATA                    =
*      LIFOVALUATIONDATA          =
    TABLES
*      MATERIALDESCRIPTION        =
*      UNITSOFMEASURE             =
*      INTERNATIONALARTNOS        =
*      MATERIALLONGTEXT           =
      TAXCLASSIFICATIONS         = taxclassifications
*      EXTENSIONOUT               =
      RETURN                     = returnmes
             .

* Header Data: Material and View to maintain
    headdata-material    = ls_list-matnr.
*    headdata-purchase_view  = 'X'.

    MOVE-CORRESPONDING plantdata TO plantdata1.
    plantdata1x-plant = plantdata1-plant.

    plantdata1-ctrl_code  = ls_list-steuc.                           "  Check
    plantdata1x-ctrl_code = 'X'.

*    LOOP AT taxclassifications.                 "xdmlan.
*      CASE sy-tabix.
*        WHEN '1'.
*          taxclassifications1-tax_type_1      =  taxclassifications-tax_type_1. "xdmlan-TATYP.
*          taxclassifications1-taxclass_1      =  taxclassifications-taxclass_1. "xdmlan-TAXKM.
*
*        WHEN '2'.
*          taxclassifications1-tax_type_2      =  taxclassifications-tax_type_1. "xdmlan-TATYP.
*          taxclassifications1-taxclass_2      =  taxclassifications-taxclass_1. "xdmlan-TAXKM.
*
*        WHEN '3'.
*          taxclassifications1-tax_type_3      =  taxclassifications-tax_type_1. "xdmlan-TATYP.
*          taxclassifications1-taxclass_3      =  taxclassifications-taxclass_1. "xdmlan-TAXKM.
*
*        WHEN '4'.
*          taxclassifications1-tax_type_4      =  taxclassifications-tax_type_1. "xdmlan-TATYP.
*          taxclassifications1-taxclass_4      =  taxclassifications-taxclass_1. "xdmlan-TAXKM.
*
*        WHEN '5'.
*          taxclassifications1-tax_type_5      =  taxclassifications-tax_type_1. "xdmlan-TATYP.
*          taxclassifications1-taxclass_5      =  taxclassifications-taxclass_1. "xdmlan-TAXKM.
*
*        WHEN '6'.
*          taxclassifications1-tax_type_6      =  taxclassifications-tax_type_1. "xdmlan-TATYP.
*          taxclassifications1-taxclass_6      =  taxclassifications-taxclass_1. "xdmlan-TAXKM.
*
*        WHEN '7'.
*          taxclassifications1-tax_type_7      =  taxclassifications-tax_type_1. "xdmlan-TATYP.
*          taxclassifications1-taxclass_7      =  taxclassifications-taxclass_1. "xdmlan-TAXKM.
*
*        WHEN '8'.
*          taxclassifications1-tax_type_8      =  taxclassifications-tax_type_1. "xdmlan-TATYP.
*          taxclassifications1-taxclass_8      =  taxclassifications-taxclass_1. "xdmlan-TAXKM.
*
*        WHEN '9'.
*          taxclassifications1-tax_type_9      =  taxclassifications-tax_type_1. "xdmlan-TATYP.
*          taxclassifications1-taxclass_9      =  taxclassifications-taxclass_1. "xdmlan-TAXKM.
*
*      ENDCASE.
*      taxclassifications1-depcountry      =  taxclassifications-depcountry. "XDMLAN-ALAND.
**      taxclassifications-depcountry_iso  =  XDMLAN-ALAND.
*      CLEAR: taxclassifications. "xdmlan.
*    ENDLOOP.

    taxclassifications1-depcountry = 'IN'.

    taxclassifications1-tax_type_1      =  ls_list-tax_type_1.
    taxclassifications1-taxclass_1      =  ls_list-taxclass_1.

    taxclassifications1-tax_type_2      =  ls_list-tax_type_2.
    taxclassifications1-taxclass_2      =  ls_list-taxclass_2.

    taxclassifications1-tax_type_3      =  ls_list-tax_type_3.
    taxclassifications1-taxclass_3      =  ls_list-taxclass_3.

    taxclassifications1-tax_type_4      =  ls_list-tax_type_4.
    taxclassifications1-taxclass_4      =  ls_list-taxclass_4.

    taxclassifications1-tax_type_5      =  ls_list-tax_type_5.
    taxclassifications1-taxclass_5      =  ls_list-taxclass_5.

    taxclassifications1-tax_type_6      =  ls_list-tax_type_6.
    taxclassifications1-taxclass_6      =  ls_list-taxclass_6.

*    taxclassifications1-tax_type_7      =  ls_list-tax_type_7.
*    taxclassifications1-taxclass_7      =  ls_list-taxclass_7.
*
*    taxclassifications1-tax_type_8      =  ls_list-tax_type_8.
*    taxclassifications1-taxclass_8      =  ls_list-taxclass_8.
*
    taxclassifications1-tax_ind = ls_list-taxim.
*    MODIFY taxclassifications1 FROM taxclassifications1 INDEX 1.
    APPEND taxclassifications1.

* Call the BAPI
    CALL FUNCTION 'BAPI_MATERIAL_SAVEDATA'
      EXPORTING
        headdata           = headdata
        plantdata          = plantdata1
        plantdatax         = plantdata1x
      IMPORTING
        return             = return
      TABLES
*        taxclassifications = taxclassifications1
        returnmessages     = returnmes.

* Commit to release the locks
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.

* RETURN-TYPE is 'E' in case of error, else 'S'.
    IF return-type = 'E'.
      LOOP AT returnmes.
        WRITE: / returnmes-message.
      ENDLOOP.
    ELSEIF return-type = 'S'..
      WRITE: / 'material ', material, 'Sucessfully Updated'.
    ENDIF.
    CLEAR: return, plantdata1, plantdata1x, headdata.
    REFRESH: taxclassifications1, returnmes.

  ENDLOOP.
*&---------------------------------------------------------------------*
*&      Form  GET_FILENAME
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_filename .
  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
*     PROGRAM_NAME  = SYST-CPROG
*     DYNPRO_NUMBER = SYST-DYNNR
      field_name    = 'P_FILE'
    IMPORTING
      file_name     = p_file.

ENDFORM.                    " GET_FILENAME
*&---------------------------------------------------------------------*
*&      Form  UPLOAD_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM upload_data .
  CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
    EXPORTING
*     I_FIELD_SEPERATOR    =
      i_line_header        = 'X'
      i_tab_raw_data       = it_type
      i_filename           = p_file
    TABLES
      i_tab_converted_data = lt_list[]
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.

  IF sy-subrc NE 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
*  DELETE lt_list INDEX 1.

ENDFORM.                    " UPLOAD_DATA

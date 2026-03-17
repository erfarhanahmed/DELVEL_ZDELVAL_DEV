report ZDEV_AS02_BDC1
       no standard page heading line-size 255.

include bdcrecx1.

parameters: dataset(132) lower case.
***    DO NOT CHANGE - the generated data section - DO NOT CHANGE    ***
*
*   If it is nessesary to change the data section use the rules:
*   1.) Each definition of a field exists of two lines
*   2.) The first line shows exactly the comment
*       '* data element: ' followed with the data element
*       which describes the field.
*       If you don't have a data element use the
*       comment without a data element name
*   3.) The second line shows the fieldname of the
*       structure, the fieldname must consist of
*       a fieldname and optional the character '_' and
*       three numbers and the field length in brackets
*   4.) Each field must be type C.
*
*** Generated data section with specific formatting - DO NOT CHANGE  ***
data: begin of record,
* data element: ANLN1
        ANLN1_001(012),
* data element: ANLN2
        ANLN2_002(004),
* data element: BUKRS
        BUKRS_003(004),
* data element: TXA50_ANLT
        TXT50_004(050),
* data element: TXA50_MORE
        TXA50_005(050),
* data element: ANLHTXT
        ANLHTXT_006(050),
* data element: INVNR_ANLA
        INVNR_007(025),
* data element: AM_MENGE
        MENGE_008(018),
* data element: MEINS
        MEINS_009(003),
* data element: XHIST_AM
        XHIST_010(001),
* data element: AKTIVD
        AKTIV_011(010),
* data element: WERKS_D
        WERKS_012(004),
* data element: STORT
        STORT_013(010),
* data element: ADATU
        ADATU_014(010),
* data element: MSFAK
        MSFAK_01_015(004),
* data element: WERKS_D
        WERKS_016(004),
* data element: STORT
        STORT_017(010),
* data element: MSFAK
        MSFAK_018(004),
* data element: AFASL
        AFASL_019(004),
* data element: NDJAR
        NDJAR_020(003),
* data element: NDABP
        NDABP_021(003),
* data element: AFABG
        AFABG_022(010),
* data element: APROP
        APROP_023(008),
      end of record.

*** End generated data section ***

start-of-selection.

perform open_dataset using dataset.
perform open_group.

do.

read dataset dataset into record.
if sy-subrc <> 0. exit. endif.

perform bdc_dynpro      using 'SAPLAIST' '0100'.
perform bdc_field       using 'BDC_CURSOR'
                              'ANLA-BUKRS'.
perform bdc_field       using 'BDC_OKCODE'
                              '/00'.
perform bdc_field       using 'ANLA-ANLN1'
                              record-ANLN1_001.
perform bdc_field       using 'ANLA-ANLN2'
                              record-ANLN2_002.
perform bdc_field       using 'ANLA-BUKRS'
                              record-BUKRS_003.
perform bdc_dynpro      using 'SAPLAIST' '1000'.
perform bdc_field       using 'BDC_OKCODE'
                              '=TAB02'.
perform bdc_field       using 'BDC_CURSOR'
                              'ANLA-TXT50'.
perform bdc_field       using 'ANLA-TXT50'
                              record-TXT50_004.
perform bdc_field       using 'ANLA-TXA50'
                              record-TXA50_005.
perform bdc_field       using 'ANLH-ANLHTXT'
                              record-ANLHTXT_006.
perform bdc_field       using 'ANLA-INVNR'
                              record-INVNR_007.
perform bdc_field       using 'ANLA-MENGE'
                              record-MENGE_008.
perform bdc_field       using 'ANLA-MEINS'
                              record-MEINS_009.
perform bdc_field       using 'RA02S-XHIST'
                              record-XHIST_010.
perform bdc_field       using 'ANLA-AKTIV'
                              record-AKTIV_011.
perform bdc_dynpro      using 'SAPLAIST' '1000'.
perform bdc_field       using 'BDC_OKCODE'
                              '=TIME'.
perform bdc_field       using 'BDC_CURSOR'
                              'ANLZ-KOSTL'.
perform bdc_field       using 'ANLZ-WERKS'
                              record-WERKS_012.
perform bdc_field       using 'ANLZ-STORT'
                              record-STORT_013.
perform bdc_dynpro      using 'SAPLAIST' '3000'.
perform bdc_field       using 'BDC_CURSOR'
                              'ANLZ-KOSTL(01)'.
perform bdc_field       using 'BDC_OKCODE'
                              '=CINV'.
perform bdc_dynpro      using 'SAPLAIST' '3010'.
perform bdc_field       using 'BDC_CURSOR'
                              'ANLZ-ADATU'.
perform bdc_field       using 'BDC_OKCODE'
                              '=ENTE'.
perform bdc_field       using 'ANLZ-ADATU'
                              record-ADATU_014.
perform bdc_dynpro      using 'SAPLAIST' '3000'.
perform bdc_field       using 'BDC_CURSOR'
                              'ANLZ-MSFAK(01)'.
perform bdc_field       using 'BDC_OKCODE'
                              '=RW'.
perform bdc_field       using 'ANLZ-MSFAK(01)'
                              record-MSFAK_01_015.
perform bdc_dynpro      using 'SAPLAIST' '1000'.
perform bdc_field       using 'BDC_OKCODE'
                              '=TAB08'.
perform bdc_field       using 'BDC_CURSOR'
                              'ANLZ-KOSTL'.
perform bdc_field       using 'ANLZ-WERKS'
                              record-WERKS_016.
perform bdc_field       using 'ANLZ-STORT'
                              record-STORT_017.
perform bdc_field       using 'ANLZ-MSFAK'
                              record-MSFAK_018.
perform bdc_dynpro      using 'SAPLAIST' '1000'.
perform bdc_field       using 'BDC_OKCODE'
                              '=SELZ'.
perform bdc_field       using 'BDC_CURSOR'
                              'ANLB-AFASL(01)'.
perform bdc_dynpro      using 'SAPLAIST' '0195'.
perform bdc_field       using 'BDC_OKCODE'
                              '=BUCH'.
perform bdc_field       using 'BDC_CURSOR'
                              'ANLB-APROP'.
perform bdc_field       using 'ANLB-AFASL'
                              record-AFASL_019.
perform bdc_field       using 'ANLB-NDJAR'
                              record-NDJAR_020.
perform bdc_field       using 'ANLC-NDABP'
                              record-NDABP_021.
perform bdc_field       using 'ANLB-AFABG'
                              record-AFABG_022.
perform bdc_field       using 'ANLB-APROP'
                              record-APROP_023.
perform bdc_transaction using 'AS02'.

enddo.

perform close_group.
perform close_dataset using dataset.

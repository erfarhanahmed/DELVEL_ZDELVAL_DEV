
APPEND INITIAL LINE TO gt_dummy.

DATA:ibr    TYPE char10,
     ul     TYPE char10,
     sil    TYPE char10,
     ce     TYPE char10,
     api6d  TYPE char10,
     api6   TYPE char10,
     atex   TYPE char10,
     trcu   TYPE char10,
     crn    TYPE char10,
     marine TYPE char10.
CLEAR:ibr,ul,sil,ce,api6d,api6,atex,trcu,crn,marine,wa_vbap.
SELECT SINGLE * FROM vbap INTO wa_vbap
  WHERE vbeln = header-vbeln
    AND posnr = header-vbelp.

IF wa_vbap-zibr = 'X'.
*  ibr = 'IBR'.
CONCATENATE cert 'IBR' INTO cert SEPARATED BY ','  .
ENDIF.

IF wa_vbap-zul = 'X'.
*  ul = 'UL'.
  CONCATENATE cert 'UL' INTO cert SEPARATED BY ','  .
ENDIF.

IF wa_vbap-zsl = 'X'.
*  sil = 'SIL3'.
 CONCATENATE cert 'SIL3' INTO cert SEPARATED BY ','  .
ENDIF.

IF wa_vbap-zce = 'X'.
*  ce = 'CE'.
 CONCATENATE cert 'CE' INTO cert SEPARATED BY ','  .
ENDIF.

IF wa_vbap-zapi6d = 'X'.
*  api6d = 'API 6D'.
  CONCATENATE cert 'API 6D' INTO cert SEPARATED BY ','  .
ENDIF.

IF wa_vbap-zapi60 = 'X'.
*  api6 = 'API 609'.
  CONCATENATE cert 'API 609' INTO cert SEPARATED BY ','  .
ENDIF.

IF wa_vbap-zatex = 'X'.
*  atex = 'ATEX'.
  CONCATENATE cert 'ATEX' INTO cert SEPARATED BY ','  .
ENDIF.

IF wa_vbap-ztrcu = 'X'.
*  trcu = 'TRCU'.
  CONCATENATE cert 'TRCU' INTO cert SEPARATED BY ','  .
ENDIF.

IF wa_vbap-zcrn = 'X'.
*  crn = 'CRN'.
  CONCATENATE cert 'CRN' INTO cert SEPARATED BY ','  .
ENDIF.

IF wa_vbap-zmarine = 'X'.
*  marine = 'MARINE'.
  CONCATENATE cert 'MARINE Application' INTO cert SEPARATED BY ','  .
ENDIF.
CONDENSE cert.
*CONCATENATE ibr
*            ul
*            sil
*            ce
*            api6d
*            api6
*            atex
*            trcu
*            crn
*            marine INTO cert SEPARATED BY ','.

*CONCATENATE 'Certificates' cert INTO cert SEPARATED BY ':'.














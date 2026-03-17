CLEAR gv_date.
*CONCATENATE gs_likp-fkdat+6(2)
*  gs_likp-fkdat+4(2)
*  gs_likp-fkdat+0(4)
*  INTO gv_date
*  SEPARATED BY '-'.


CONCATENATE gs_likp-fkdat+0(4)
            gs_likp-fkdat+4(2)
            gs_likp-fkdat+6(2)
INTO gv_date SEPARATED BY '.'.




















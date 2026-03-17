*BREAK-POINT.

*READ TABLE GT_T157E INTO gs_t157e
*           with KEY grund =  WA_MSEG01-grund.

SELECT SINGLE GRTXT FROM T157E
                INTO LV_GRTXT
                WHERE grund =  WA_MSEG01-grund
                AND SPRAS = 'EN'
                AND BWART = '161'.




















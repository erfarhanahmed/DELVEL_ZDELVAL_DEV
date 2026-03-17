FUNCTION zeinv_unit_convert.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(VRKME) TYPE  VRKME
*"  EXPORTING
*"     REFERENCE(UNIT) TYPE  ANY
*"----------------------------------------------------------------------

  CASE vrkme .
    WHEN 'BAG'.                  "BAG-BAGS"       "SAP UOM"
      unit = 'BAG'.                               "IRP UOM"
    WHEN 'BAL'.                  "   BALE
      unit = 'BAL'.
    WHEN 'BDL'.                  "   BUNDLES
      unit = 'BDL'.
    WHEN 'BKL'.                  "   BUCKLES
      unit ='BKL'.
    WHEN 'BOU'.                  "   BILLION OF UNITS
      unit ='BOU'.
    WHEN 'BOX'.                  "   BOX
      unit ='BOX'.
    WHEN 'BT'.                   "BT-BOTTLES"
      unit ='BTL'.
    WHEN 'BHN'.                  "BHN-BUNCHES"
      unit ='BUN'.
    WHEN 'CAN'.                  "CAN-CANS"
      unit ='CAN'.
    WHEN 'M3'.                   "M3-CUBIC METERS"
      unit ='CBM'.
    WHEN 'CCM'.                  "CCM-CUBIC CENTIMETERS"
      unit ='CCM'.
    WHEN 'CM'.                   "CM-CENTIMETERS"
      unit ='CMS'.
    WHEN 'CAR'.                  "CAR-CARTONS"
      unit ='CTN'.
    WHEN 'DZ'.                   "DZ-DOZENS"
      unit ='DOZ'.
    WHEN 'DR'.                   "DR-DRUMS"
      unit ='DRM'.
    WHEN 'GGK'.                  "   GREAT GROSS
      unit ='GGK'.
    WHEN 'G'.                    "G-GRAMMES"
      unit ='GMS'.
    WHEN 'GRO'.                  "GRO-GROSS"
      unit ='GRS'.
    WHEN 'GYD'.                  "    GROSS YARDS
      unit ='GYD'.
    WHEN 'KG'.                   "KG  Kilogram
      unit ='KGS'.
    WHEN 'KL'.                   "KL  KILOLITRE
      unit ='KLR'.
    WHEN 'KM'.                   "KM  Kilometer
      unit ='KME'.
    WHEN 'L'.                    "L	Liter
      unit ='LTR'.
    WHEN 'M'.                    "M	Meter
      unit ='MTR'.
    WHEN 'ML'.                   "ML  Milliliter
      unit ='MLT'.
*    WHEN 'TO'.                   "TO  Tonne
*      unit ='MTS'.
    WHEN 'EA'.                   "EA  each
      unit ='NOS'.
    WHEN 'OTH'.                  "    OTHERS
      unit ='OTH'.
    WHEN 'PAC'.                  "PAC	Pack
      unit ='PAC'.
    WHEN 'ST'.                   "ST  items
      unit ='PCS'.
    WHEN 'PAA'.                  "PAA	Pair
      unit ='PRS'.
    WHEN 'QTL'.                  "   QUINTAL
      unit ='QTL'.
    WHEN 'ROL'.                  "ROL	Role
      unit ='ROL'.
    WHEN 'SET'.                  "SET	SET
      unit ='SET'.
    WHEN 'FT2'.                  "FT2	Square foot
      unit ='SQF'.
    WHEN 'M2'.                   "M2  Square meter
      unit ='SQM'.
    WHEN 'YD2'.                  "YD2	Square Yard
      unit ='SQY'.
    WHEN 'TBS'.                  "    TABLETS
      unit ='TBS'.
    WHEN 'TGM'.                  "    TEN GROSS
      unit ='TGM'.
    WHEN 'TS'.                   "TS  Thousands
      unit ='THD'.
    WHEN 'TO'.                   "TO  Tonne
      unit ='TON'.
    WHEN 'TUB'.                  "    TUBES
      unit ='TUB'.
    WHEN 'GAL'.                  "GAL  US gallon
      unit ='UGS'.
    WHEN 'AU'.                   "AU  Activity unit
      unit ='UNT'.
    WHEN 'YD'.                   "YD  Yards
      unit ='YDS'.
    WHEN 'NOS'.
      unit ='NOS'.
    WHEN 'D'.
      unit ='OTH'.
     WHEN '10'.
      unit ='OTH'.
    WHEN OTHERS.
  ENDCASE.




ENDFUNCTION.

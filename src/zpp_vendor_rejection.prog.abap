*&---------------------------------------------------------------------*
*& Report  ZPP_VENDOR_REJECTION
*&
*&---------------------------------------------------------------------*
*&  Created By : Atul Yadav
*&  Created on : 29 Aug. 2012
*&  Transaction Code : NA
*&  Transport Request No.:
*&  Description : New Report is needed to display data of inspection lot
*&                of typ = 1 mblnr with vendor and diff. quantity
*&                based on storage loc. of typ = 3 mblnr and for the
*&                input fields as select-option on material doc. date
*&                mandatoy and vendor.
*&---------------------------------------------------------------------*

REPORT  zpp_vendor_rejection.
*Include for data deceleration
INCLUDE zpp_ven_rej_data_decleration.

AT SELECTION-SCREEN.
*Perform for selection screen validation
  PERFORM screen_validation.

*Iinclude for selection of data
  INCLUDE zpp_ven_rej_data_selection.

START-OF-SELECTION.
*Perform for data selection statments
  PERFORM select_statments.
*Perform for filtring data.
  PERFORM filter_data.
*Perform for fetching material description
  PERFORM material_description.
*Perform for filling Final Table
  PERFORM populate_final.
*Perform for filling summary final table
  PERFORM populate_final2.
*Perform for converting date formate of header in alv
  PERFORM date_format.

END-OF-SELECTION.
*ALV DISPLAY

*Perform for Fieldcatlog of alv
  PERFORM build_fieldcat.
*Perform for layout of alv
  PERFORM build_layout.
*Perform for events in alv
  PERFORM alv_events.
*Perform for alv display
  PERFORM alv_display.

types : begin of t_bseg,
        belnr   type bseg-belnr,
        GJAHR	  TYPE GJAHR, "	Fiscal Year
        BUZEI	  TYPE BUZEI, "	Number of Line Item Within Accounting Document
        AUGDT	  TYPE AUGDT, "	Clearing Date
        AUGBL	  TYPE AUGBL, "	Document Number of the Clearing Document
        KOART	  TYPE KOART, "	Account Type
        SHKZG   type bseg-SHKZG,
        dmbtr   type bseg-dmbtr,
        qsshb	  TYPE QSSHB, "	Withholding Tax Base Amount
        kostl   type bseg-kostl,
        REBZG   TYPE REBZG, " Invoice No. the Transaction Belongs to
        REBZJ   TYPE REBZJ, " Fiscal Year of the Relevant Invoice (for Credit Memo)
        REBZZ   TYPE REBZZ, " Line Item in the Relevant Invoice
        AUGGJ   TYPE AUGGJ, " Fiscal Year of Clearing Document
        bldat   type bldat,
        budat   type budat,
        xblnr   type bkpf-xblnr,
        tdsamt  type dmbtr,
        netamt  type dmbtr,
        clramt  type dmbtr,
        prebal  type dmbtr,
        balanc  type dmbtr,
  end of t_bseg,

  tt_bseg type STANDARD TABLE OF t_bseg,

  begin of t_prof_cost_cntr, " Profit/ Cost Center
    cntrcd type char10,
    KTEXT	 TYPE KTEXT, " General Name
  end of t_prof_cost_cntr,

  tt_prof_cost_cntr type table of t_prof_cost_cntr.


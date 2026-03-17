TYPES: BEGIN OF S_ALLDATA,
bstdk like vbkd-bstdk, "PO Number
bstkd like vbkd-bstkd, "PO Date
kunnr like vbpa-kunnr, "Ship-to-party
kunag like vbpa-kunnr, "Sold-to-party
mobile like kna1-telf2, "Mobile Number
adrnr1 like kna1-adrnr, "ship-to-party address
adrnr2 like kna1-adrnr,"sold-to-party address
landx2 like t005t-landx, "Ship-to Country text
landx1 like t005t-landx, "Sold-to Country text
name1 like knvk-name1, "Contact Person
pafkt like knvk-pafkt, "Contact Person Role
vtext like tpfkt-vtext, "Designation
email like adr6-smtp_addr, "Email Addrss
J_1IEXCD like J_1IMOCUST-J_1IEXCD, "ECC Number
J_1ICSTNO like J_1IMOCUST-J_1ICSTNO, "Central Sales Tax Number
J_1ILSTNO like J_1IMOCUST-J_1ILSTNO, "Local Sales Tax Number
J_1IPANNO like J_1IMOCUST-J_1IPANNO, "Permanent Account Number
taxkd     like knvi-taxkd,           "Tax classification for customer
tatyp     like knvi-tatyp,           "Tax Category
vtext1    like tskdt-vtext,          "Description
END OF S_ALLDATA.




























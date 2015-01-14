unit Agumentation;

interface
Uses msbu;
Var
  subID,WIID,LSIID,GSIID,GSCount : integer;
  Procedure SetAgValue(CID,sID,WObjID,LObjID,GObjID,Count:integer);
  Procedure Augment(CID:integer);
implementation
Uses AAction,Other_Func;
Procedure SetAgValue(CID,sID,WObjID,LObjID,GObjID,Count:integer);
Begin
  subID:=sID;
  WIID:=user[CID].IList.Itemo[WObjID].ID;
  LSIID:=user[CID].IList.Itemo[LObjID].ID;
  GSIID:=user[CID].IList.Itemo[GObjID].ID;
  GSCount:=Count;
  say(CID,'Елементы для агюментации заданы');
End;
Procedure Augment(CID:integer);
Begin
  with user[CID] do Begin
    if (WIID<>0) and (IList.Itemi[WIID].AugmentationBonus<>0) then sts(CID,'D04600'+anti4HEX(IList.Itemi[WIID].OID));
    if (WIID<>0) and (IList.Itemi[WIID].AugmentationBonus=0) Then if (IList.Itemi[LSIID].Count>0)
      and (IList.Itemi[GSIID].Count>=GSCount) then
      sts(CID,'D04400'+anti4HEX(IList.Itemi[WIID].OID)+anti4HEX(IList.Itemi[LSIID].OID)+anti4HEX(IList.Itemi[GSIID].OID)+anti4HEX(GSCount))
      else say(CID,'Недостаточно елементов для агюментации');
  End;
End;

end.

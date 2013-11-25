trigger LeadTrigger on Lead (after insert, before update, before delete) {

  // array to store HOLs for bulk insertion
  Hot_Open_Lead__c[] hols = new List<Hot_Open_Lead__c>();


  // create HOLs records with appropriate Action__c (Add, Update, Remove) based
  // on changes to Lead records
  if (Trigger.isInsert) {
    for (Lead l : Trigger.new) {
      if ((l.Status == 'Open - Not Contacted') && (l.Rating == 'Hot')) {
        hols.add(new Hot_Open_Lead__c(Action__c = 'Add', Name = l.Id, Lead__c = l.Id));
      }
    }
  }

  if (Trigger.isUpdate) {
    for (Integer i=0; i < Trigger.new.size(); i++){
      if (((Trigger.old[i].Status != Trigger.new[i].Status) ||
           (Trigger.old[i].Rating != Trigger.new[i].Rating)) && 
          ((Trigger.new[i].Status == 'Open - Not Contacted') &&
           (Trigger.new[i].Rating == 'Hot'))){
        hols.add(new Hot_Open_Lead__c(Action__c = 'Add', Name = Trigger.new[i].Id, Lead__c = Trigger.new[i].Id));
      }
      else if ((Trigger.old[i].Status == Trigger.new[i].Status) &&
               (Trigger.old[i].Rating == Trigger.new[i].Rating)){
        hols.add(new Hot_Open_Lead__c(Action__c = 'Update', Name = Trigger.new[i].Id, Lead__c = Trigger.new[i].Id));
      }
      else if (((Trigger.old[i].Status != Trigger.new[i].Status) ||
           (Trigger.old[i].Rating != Trigger.new[i].Rating)) && 
          ((Trigger.new[i].Status != 'Open - Not Contacted') ||
           (Trigger.new[i].Rating != 'Hot'))){
        hols.add(new Hot_Open_Lead__c(Action__c = 'Remove', Name = Trigger.new[i].Id, Lead__c = Trigger.new[i].Id));
      }
    }
  }

  if (Trigger.isDelete){
    for (Lead l : Trigger.old) {
      if ((l.Status == 'Open - Not Contacted') && (l.Rating == 'Hot')) {
        hols.add(new Hot_Open_Lead__c(Action__c = 'Remove', Name = l.Id, Lead__c = l.Id));
      }      
    }
  }

  if (!hols.isEmpty()) {insert(hols);}

}
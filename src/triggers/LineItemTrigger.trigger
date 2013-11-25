trigger LineItemTrigger on Line_Item__c (before insert, before update) {    
    
    if(Trigger.isBefore) { //separate before and after  
        
        if(Trigger.isInsert || Trigger.isUpdate) { //separate events
            
            //Map data from most unique points.
            //Invoice (KEY)
                //Merchandise (KEY)
                //Line Item
            //Any invoice to merchandise relationship should only have one result.  
            Map<Id,Map<Id,Line_Item__c>> invoiceToMerchandise = new Map<Id,Map<Id,Line_Item__c>>();
            for(Line_Item__c li : Trigger.new) {
                if(!invoiceToMerchandise.containsKey(li.Invoice__c)) { //New Invoice, create new map
                    Map<Id,Line_Item__c> newMap = new Map<Id,Line_Item__c>();
                    invoiceToMerchandise.put(li.Invoice__c,newMap);
                    Map<Id,Line_Item__c> myMap = invoiceToMerchandise.get(li.Invoice__c);
                    myMap.put(li.Merchandise__c,li);        //add merch and line item   
                } else {
                    for(Id i : invoiceToMerchandise.keySet()) {
                        if(invoiceToMerchandise.get(li.Invoice__c).containsKey(li.Merchandise__c)) { //check existing map for Merchandise
                            li.addError('Duplicate Merchandise for Invoice'); //add error message
                        }
                    }
                
                }
            }
            
            //Now we need to check existing line items in the system.
            //This will be only DML statement called
            Set<Id> inids = invoiceToMerchandise.keySet();
            Map<ID, Line_Item__c> relatedLineItems = new Map<ID, Line_Item__c>([SELECT Id, Merchandise__c, Quantity__c FROM Line_Item__c WHERE Invoice__c IN :inids]);
            
            //Compare the existing Merchandise to our previously created data map
            for(Id i : relatedLineItems.keySet()) {
                for(Line_Item__c li : Trigger.new) {
                    if(invoiceToMerchandise.get(li.Invoice__c).containsKey(relatedLineItems.get(i).Merchandise__c) &&
                       invoiceToMerchandise.get(li.Invoice__c).get(relatedLineItems.get(i).Merchandise__c).Id != i
                    ) {
                        li.addError('Duplicate Merchandise for Invoice'); //if they match invoice and merchandise, add error
                    }
                    
                }
            }
    
        }
    
    }

}
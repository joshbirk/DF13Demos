@RestResource(urlMapping='/WarehouseREST/*')
global with sharing class WarehouseREST {

    global WarehouseREST() {}
    
    @HttpGet
    global static List<AggregateResult> getMerchandiseForInvoice() {
        String id = RestContext.request.requestURI.substring(RestContext.request.requestURI.lastIndexOf('/')+1);
        List<AggregateResult> lis = [SELECT SUM(Line_Item_Total__c), Merchandise__r.Name from Line_Item__c where Invoice__c = :id Group By Merchandise__r.Name];
        return lis;
    }
    
    @HttpPost 
    global static RESTMessage postMerchandiseToInvoice(Id invoiceID, List<Id> merchids) {
        List<Line_Item__c> line_items = new List<Line_Item__c>();
        
        for(Id m : merchids) {
            Line_Item__c li = new Line_Item__c(Invoice__c = invoiceID, Merchandise__c=m, Quantity__c=1);
            line_items.add(li);
        }
        try {
            insert line_items;
            return new RESTMEssage(line_items.size() +' item(s) added','Completed', invoiceId);
        } catch (DMLException e) {
            return new RESTMEssage(e.getMessage(),'Error', invoiceId);
        }       
    }

    
    @HttpDelete
    global static String deleteMerchandiseFromInvoice() {
        Id merchId = RestContext.request.params.get('mid');
        Id invoiceId = RestContext.request.params.get('iid');
        List<Line_Item__c> line_items = [SELECT ID from Line_Item__c WHERE Merchandise__c = :merchID AND Invoice__c = :invoiceId];
        
        try {
            delete line_items;
            return 'Done';
        } catch (DMLException e) {
            return 'Error';
        }
    }
    
    global class RESTMessage {
        public String message {get; set;}
        public String status {get; set;}
        public String info {get; set;}
        public RESTMessage(String m, String s, String i) {
            this.message = m;
            this.status = s;
            this.info = i;
        }
    }


}
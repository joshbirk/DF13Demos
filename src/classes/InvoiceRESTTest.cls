@IsTest
global class InvoiceRESTTest {
    @IsTest
    global static void testInvoiceREST() {    
        Merchandise__c m = new Merchandise__c(Name='Test Rack Server',Price__c=1245.99,Quantity__c=500);
        insert m;
        
        List<Merchandise__c> items = new List<Merchandise__c>();
        Merchandise__c item = new Merchandise__c();
        item.Name = 'Test';
        item.Quantity__c = 1;
        item.Price__c = 1.99;        
        insert item;
        items.add(item);
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        WarehouseREST.RESTMessage r = InventoryControlREST.createNewInvoice(items);
        System.assertEquals(r.status,'Completed');
        
    }
}
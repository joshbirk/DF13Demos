@RestResource(urlMapping='/InventoryControl/*')
global with sharing class InventoryControlREST {

	global InventoryControlREST() {}
		
	@HttpPost 
    global static WarehouseREST.RESTMessage createNewInvoice(List<Merchandise__c> items) {
        Invoice__c invoice = new Invoice__c();
		insert invoice;
		List<Line_Item__c> line_items = new List<Line_Item__c>();
		for(Merchandise__c item : items) {
            Line_Item__c line_item = new Line_Item__c(Invoice__c = invoice.Id,
					Name=item.Name + '('+item.Quantity__c+')',
					Merchandise__c=item.Id,
					Quantity__c=item.Quantity__c,
					Unit_Price__c=item.Price__c);
			line_items.add(line_item);
        }
        try {           
			insert line_items;
            return new WarehouseREST.RESTMEssage(items.size() +' item(s) added','Completed',String.valueOf(items));
        } catch (DMLException e) {
            return new WarehouseREST.RESTMEssage(e.getMessage(),'Error',String.valueOf(items));
        }       
    }

}
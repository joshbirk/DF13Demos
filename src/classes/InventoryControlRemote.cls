global with sharing class InventoryControlRemote {

	global InventoryControlRemote() {}
		
	@RemoteAction
	static global List<Merchandise__c> getRecords() {
		List<Merchandise__c> merchandise = [SELECT Id, Name, Price__c, Quantity__c, Description__c, Price_Reduction__c from Merchandise__c];
		return merchandise;
	}
	
	@RemoteAction
	static global Boolean updateMerchandise(Merchandise__c m) {
		update m;
		m = [SELECT ID, Price_Reduction__c From Merchandise__c WHERE Id =: m.Id];
		return m.Price_Reduction__c;
	}
	
	@RemoteAction
	static global Merchandise__c newMerchandise(String item_name) {
		Merchandise__c m = new Merchandise__c(Name=item_name,Price__c=0.99,Quantity__c=0);
		insert m;
		
		return m;
	}
	
	@RemoteAction
	static global void removeMerchandise(Id item_id) {
		Merchandise__c m = new Merchandise__c(Id=item_id);
		delete m;
	}

}
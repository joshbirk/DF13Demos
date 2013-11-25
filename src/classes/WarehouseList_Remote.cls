global with sharing class WarehouseList_Remote {

	public transient List<Merchandise__c> merchandise {get; set;}
	
	global WarehouseList_Remote() {
		merchandise = [SELECT Name, Quantity__c, Price__c FROM Merchandise__c LIMIT 10000];
	}

	@RemoteAction
	static global List<Merchandise__c> getMerchandise() {
		return [SELECT Name, Quantity__c, Price__c FROM Merchandise__c LIMIT 10000];
	}

	@RemoteAction
	static global String updateQuantity(Id recordId, Integer quantity) {
		Merchandise__c m = new Merchandise__c(Id=recordId,Quantity__c=quantity);
		update m;
		
		return 'Record '+recordId+' has been updated to '+quantity;
	}

}
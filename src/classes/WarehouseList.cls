public with sharing class WarehouseList {

	public transient List<Merchandise__c> merchandise {get; set;}
	public Id recordId {get; set;}
	public Integer quantity {get; set;}
	public String output {get; set;}
	
	public WarehouseList() {
		merchandise = [SELECT Name, Quantity__c, Price__c FROM Merchandise__c LIMIT 1000];
	}
	
	
	public PageReference updateQuantity() {
		if(recordId == null) {
			return null;
		}
		
		Merchandise__c m = new Merchandise__c(Id=recordId,Quantity__c=quantity);
		update m;
		
		output = 'Record '+recordId+' has been updated to '+quantity;
		
		return null;
	}

}
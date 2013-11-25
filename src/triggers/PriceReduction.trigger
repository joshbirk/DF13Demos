trigger PriceReduction on Merchandise__c (before update) {

	for(Merchandise__c so : Trigger.new) {
		if(so.Price__c < Trigger.oldMap.get(so.Id).Price__c) {
			so.Price_Reduction__c = true;
		}
		if(so.Price__c > Trigger.oldMap.get(so.Id).Price__c) {
			so.Price_Reduction__c = false;
		}
 	}


}
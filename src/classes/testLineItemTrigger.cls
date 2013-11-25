public class testLineItemTrigger {
    @isTest
    static public void testLineItemTrigger() {
        Merchandise__c m = new Merchandise__c(Name='Rack Server',Price__c=3245.99,Quantity__c=500);
        insert m;
        
        Invoice__c i = new Invoice__c();
        insert i;
        
        Line_Item__c old_item = new Line_Item__c(Name='1',Quantity__c=10,Merchandise__c=m.Id,Invoice__c=i.Id);
        insert old_item;
        
        List<Line_Item__c> duplicateItems = new List<Line_Item__c>();
                duplicateItems.add(new Line_Item__c(Name='1',Quantity__c=10,Merchandise__c=m.Id,Invoice__c=i.Id));
                duplicateItems.add(new Line_Item__c(Name='1',Quantity__c=20,Merchandise__c=m.Id,Invoice__c=i.Id));
        try {
                    Line_Item__c li2 = new Line_Item__c(Name='1',Quantity__c=10,Merchandise__c=m.Id,Invoice__c=i.Id);
                    insert duplicateItems;
                } catch(DMLException e) {
                    System.assertEquals(e.getMessage().contains('Duplicate'),true);
                }
        
        List<Line_Item__c> lis = [SELECT ID, Merchandise__c from Line_Item__c];
        System.assertEquals(1,lis.size());  
    }
}
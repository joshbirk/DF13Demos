@isTest
private class TestHandleProductPriceChange {
     static testMethod void testPriceChange() {
         Invoice__c invoice = new Invoice__c(Status__c = 'Negotiating');
         insert invoice;
         Merchandise__c[] products = new Merchandise__c[]{
             new Merchandise__c(Name = 'item 1', Price__c = 10, Quantity__c = 10),
             new Merchandise__c(Name = 'item 2', Price__c = 11, Quantity__c = 10)
         };
         insert products;
         Line_Item__c[] lineItems = new Line_Item__c[] {
             new Line_Item__c(Invoice__c = invoice.id,
       Merchandise__c = products[0].id, Unit_Price__c = 10, Quantity__c = 3),
              new Line_Item__c(Invoice__c = invoice.id,
     Merchandise__c = products[1].id, Unit_Price__c = 11, Quantity__c = 6)
         };
         insert lineItems;

     products[0].price__c = 20;
       Test.startTest();
       update products;
       Test.stopTest();
lineItems = [SELECT id, unit_price__c FROM Line_Item__c WHERE id IN :lineItems];
       system.assert(lineItems[0].unit_price__c == 10);
   }
}
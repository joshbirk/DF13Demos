@isTest
global class InvoiceTests{
    @isTest(seeAllData=true)
    global static void testDataInstall() {
        WarehouseDataInstall.insertLotsOfRows();
        WarehouseDataInstall.deleteExtraRows();
        WarehouseDataInstall wl1 = new WarehouseDataInstall();
        wl1.createData();
        InventoryControlREST wl = new InventoryControlREST();
        List<Merchandise__c> m = InventoryControlRemote.getRecords();
        System.assertNotEquals(0,m.size());
        InventoryControlRemote.updateMerchandise(m[0]);
        InventoryControlRemote.newMerchandise('Test');
        
        WarehouseList wl2 = new WarehouseList();
        wl2.updateQuantity();
        wl2.recordId = m[0].Id;
        wl2.quantity = 0;
        wl2.updateQuantity();
        List<Invoice__c> invoices = [SELECT Id From Invoice__c];
        List<Id> invoice_ids = new List<Id>();
        invoice_ids.add(invoices[0].Id);
        WarehouseList_Remote wlr = new WarehouseList_Remote();
        WarehouseList_Remote.getMerchandise();
        WarehouseList_Remote.updateQuantity(m[0].Id,0);
        
        
        InventoryControlRemote.removeMerchandise(m[0].Id);
        
    }
    
}
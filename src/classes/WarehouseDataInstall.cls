public with sharing class WarehouseDataInstall {

    public WarehouseDataInstall() {}
    public WarehouseDataInstall(ApexPages.StandardController stc) {}
    public WarehouseDataInstall(WarehouseList stc) {}
    public WarehouseDataInstall(WarehouseList_Remote stc) {}

    public static void deleteAllData() {
        List<Invoice__c> ii = [SELECT ID from Invoice__c];
        delete ii;
        
        List<Merchandise__c> mm = [SELECT ID from Merchandise__c];
        delete mm;
    }

    public static boolean getHasData() {
        return [SELECT Id from Merchandise__c].size() > 0;
    }
    
    public PageReference createData() {
        List<Merchandise__c> m = new List<Merchandise__c>();
        m.add(new Merchandise__c(Name='Laptop',Price__c=500,Quantity__c=1000));
        m.add(new Merchandise__c(Name='Desktop',Price__c=1000,Quantity__c=500));
        m.add(new Merchandise__c(Name='Tablet',Price__c=300,Quantity__c=5000));
        m.add(new Merchandise__c(Name='Rack Server',Price__c=3245.99,Quantity__c=500));
        m.add(new Merchandise__c(Name='Old Laptop',Price__c=345.99,Quantity__c=50));
        m.add(new Merchandise__c(Name='Deluxe Desktop',Price__c=1399.99,Quantity__c=250));
        m.add(new Merchandise__c(Name='Work Desktop',Price__c=1145.99,Quantity__c=750));        
        insert m;
        
        for (Integer i=0; i<=6; i++) {
            Invoice__c inv = new Invoice__c(Status__c=(i < 3 ? 'Closed' : 'Open'));
            insert inv;
            
            Line_Item__c li = new Line_Item__c
              (Quantity__c=1, Merchandise__c=m[i].Id,Invoice__c=inv.Id);
            insert li;       
        }
        
        List<PushTopic> pts = [SELECT Id, Name FROM PushTopic WHERE Name = 'ReducedPrices'];
        delete pts;
        PushTopic pushTopic = new PushTopic();
        pushTopic.Name = 'ReducedPrices';
        pushTopic.Description = 'Items which have reduced in price';
        pushtopic.Query =
            'SELECT Id, Name, Quantity__c, Price__c, Price_Reduction__c FROM Merchandise__c WHERE Price_Reduction__c = TRUE';
        pushTopic.ApiVersion = 26.0;
        pushTopic.NotifyForOperations = 'All';
        pushTopic.NotifyForFields = 'Referenced';
        insert pushTopic;
        System.debug('Created new PushTopic: ' + pushTopic.Id);
        
        return null;
    }
    
    
    @isTest(seeAllData=true)
    public static void testWarehouseDataInstall() {
        WarehouseDataInstall wdi = new WarehouseDataInstall();
        if(!WarehouseDataInstall.getHasData()) {
            wdi.createData();
        }
        System.assertEquals(true,WarehouseDataInstall.getHasData());
        WarehouseDataInstall.deleteAllData();
        System.assertEquals(false,WarehouseDataInstall.getHasData());
        
    }

    @RemoteAction
    public static void insertLotsOfRows() {
        List<Merchandise__c> allMerchandise = new List<Merchandise__c>();
                    for(Integer x = 0; x < 500; x++) {
                        Merchandise__c m = new Merchandise__c(Name='Widget '+String.valueOf(x), Quantity__c=100, Price__c=49.99);
                        allMerchandise.add(m);
                    }
        insert allMerchandise; 
    }
    
    @RemoteAction 
    public static void deleteExtraRows() {
        LIST<Merchandise__c> m = [SELECT ID from Merchandise__c WHERE Name LIKE 'Widget%' LIMIT 9999];
        delete m;
    }

}
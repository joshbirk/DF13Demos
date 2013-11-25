public with sharing class MoogleController {
	
	public transient User invoiceOwner { get; set; }
	public Id userId { get; set; }

	public MoogleController() {
		invoiceOwner = new User();
	}


	public PageReference getUser() {
		invoiceOwner = [SELECT Id, Name, Phone, Email from USER where Id = :userId];

		return null;
	}

	public PageReference clearUser() {
		invoiceOwner = new User();

		return null;
	}

	@RemoteAction
	public static List<Invoice__c> searchInvoices(String keyword) {
		String keywordLike = '%' + keyword + '%';
		
		List<Line_Item__c> line_items = [SELECT ID, Name, Merchandise__r.Name, Invoice__c from Line_Item__c WHERE Merchandise__r.Name LIKE :keywordLike AND Invoice__r.Status__c != 'Negotiating' AND Invoice__r.Status__c != 'Closed'];
		List<Id> invoiceIds = new List<Id>();
		for(Line_Item__c li : line_items) {
			invoiceIds.add(li.Invoice__c);
		}
		List<Invoice__c> invoices = [SELECT Id, OwnerId, Owner.Name, Name, Status__c, Invoice_Total__c from Invoice__c WHERE Id IN :invoiceIds];
		return invoices;

		//List<Case> cases = [SELECT ID, Subject from CASE Where Subject LIKE :keywordLike AND Status != 'Closed'];
		//return cases;
	}

	@RemoteAction
	public static void updateInvoice(Id invoiceId) {
		Invoice__c invoice = new Invoice__c(Id=invoiceId,Status__c='Negotiating');
		update invoice;
	}
}
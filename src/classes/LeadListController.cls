public with sharing class LeadListController {

  Transient Lead[] leads;
  String query = 'SELECT Id, Name, State, Company, Email, LastModifiedDate FROM Lead WHERE Status = \'Open - Not Contacted\' AND Rating = \'Hot\' ORDER BY LastModifiedDate DESC';

  public Lead[] getLeads() {
    leads = Database.query(query);
    return leads;
  }

  public PageReference pollAction() {
    leads = Database.query(query);
    return null;
  }

  @RemoteAction
  static public Lead[] getHotLeads() {
    String query = 'SELECT Id, Name, State, Company, Email, LastModifiedDate FROM Lead WHERE Status = \'Open - Not Contacted\' AND Rating = \'Hot\' ORDER BY LastModifiedDate DESC';
    Lead[] leads = Database.query(query);
    return leads;
  }
}
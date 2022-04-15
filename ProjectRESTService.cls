@RestResource(urlMapping='/Project__c/*')
global with sharing class ProjectRESTService {
    @HttpPost
    global static String postProjectData(String ProjectRef, String ProjectName,String OpportunityId, Date StartDate, Date EndDate,
                                         Decimal Amount, String Status) {
      List<Project__c> projects = [SELECT Billable_Amount__c,End_Date__c,Id,Name,Opportunity__c,ProjectRef__c,Start_Date__c,Status__c FROM Project__c WHERE ProjectRef__c = :ProjectRef];
      Project__c p = new Project__c();
      if(projects.size() > 0)
      p = projects.get(0);                                        
       Savepoint sp = Database.setSavepoint();
      try{  
          p.Billable_Amount__c = Amount;
          p.End_Date__c = EndDate;
          p.Name = ProjectName;
          p.Opportunity__c = OpportunityId;
          p.ProjectRef__c = ProjectRef;
          p.Start_Date__c = StartDate;
          p.Status__c = Status;
          upsert p;
          Opportunity o=[Select Id, DeliveryInstallationStatus__c FROM Opportunity Where Id =: OpportunityId];
          o.DeliveryInstallationStatus__c='In progress';
          update o;
          return 'OK';
      }
catch(exception ex){
          Database.rollback(sp);
          return ex.getMessage();
      }
   }
}

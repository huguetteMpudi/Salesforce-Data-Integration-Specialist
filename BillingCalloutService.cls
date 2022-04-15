/*
Created by Huguette Mpudi 04/18/2022
*/
public With Sharing class BillingCalloutService {
    //Implement business and callout logic methods here
    
    public static void callBillingService(list<Project__c> mList) {
         //List<String[]> pList = new List<String[]>();
         List<Project__c> projectList = [SELECT Id, status__c,ProjectRef__c,Billable_Amount__c FROM Project__c WHERE Id IN :mList  AND status__c =:'Billable' WITH SECURITY_ENFORCED ];
  
    // Iterate over the returned Projects   
        if(projectList.Size()!=0) {
       	ServiceCredentials__c credentials = ServiceCredentials__c.getInstance('BillingServiceCredential');
            for (Project__c a :projectList){
                callBillingCallOut(credentials.Username__c, credentials.Password__c,a.ProjectRef__c,double.valueOf(a.Billable_Amount__c));         
            }	      
        }

    }
    @future(callout=true)
    public static void callBillingCallOut(String params1,String params2,String params3,Double params4) {
  	BillingServiceProxy.project p = new BillingServiceProxy.project();
        p.username = params1;
        p.password = params2;
        p.projectid = params3;
        p.billAmount = params4;
	BillingServiceProxy.InvoicesPortSoap11 outboundCall = new BillingServiceProxy.InvoicesPortSoap11();
        // Make the callout and update the Status if callout is successful
        String response = outboundCall.billProject(p);

        if (response =='ok' || response =='OK') {
        
         Project__c o=[Select Id, status__c FROM Project__c Where ProjectRef__c =: params3  WITH SECURITY_ENFORCED ];
          o.status__c='Billed';
          update o;    
            
        }
      
    }
}

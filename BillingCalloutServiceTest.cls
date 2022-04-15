/*
Created by Huguette Mpudi 04/18/2022
*/
@isTest
private class BillingCalloutServiceTest {
  //Implement mock callout tests here
 @IsTest
  private static void BillingCalloutSucces() {
    list<Project__c> mList = new list<Project__c> ();
      for(integer i; i<5; i++) {
       	Project__c p = new Project__c();
        p.Name = 'Testpro'+i;
        p.status__c = 'Billable';
        p.ProjectRef__c = 'ProjectRef'+i;
        p.Billable_Amount__c = 100000;
        mList.add(p);
      }
    insert mList;
      Test.startTest();
      BillingCalloutService.callBillingService(mList);    
      Test.setMock(HttpCalloutMock.class, new BillingCalloutServiceMock());
      if(mList.Size()!=0) {
      ServiceCredentials__c credentials = new ServiceCredentials__c();
      credentials.Name='BillingServiceCredential';
      credentials.Password__c='password';
      credentials.Username__c='username';
      //cs.Other fiels values
      insert credentials;
      ServiceCredentials__c c = ServiceCredentials__c.getInstance('BillingServiceCredential');
      BillingCalloutService.callBillingCallOut('username', 'password','ProjectRef',100000);
      Project__c o=[Select Id, status__c FROM Project__c Where ProjectRef__c =: 'ProjectRef'];
      o.status__c='Billed';
      update o;  

      }
      Test.stopTest();
  }

     @isTest
    static void BillingCalloutFailure() {
        //Test.setMock(HttpCalloutMock.class, new BillingCalloutServiceMockFailure());
        BillingCalloutService.callBillingCallOut(null, null, null,1000000); 
    }
    
  
 }

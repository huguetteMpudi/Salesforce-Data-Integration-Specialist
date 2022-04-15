/*
Created by Huguette Mpudi 04/18/2022 still working on the code coverage 
*/

@isTest
private class ProjectCalloutServiceTest {

    private static testMethod void testFailure() {
        Opportunity opp = myOpportunity();

        Test.startTest();
        ServiceTokens__c token = new ServiceTokens__c(
                name = 'ProjectCalloutService-token',
                Token__c = 'test-service-token'
        );
        insert token;
        
        Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMockFailure());
        ProjectCalloutService.postOpportunityToPMS(new List<Id>{opp.Id});
        
        Test.stopTest();

        System.assertEquals('Resubmit Project', callOpportunity(opp.Id).StageName);
    }

    private static testMethod void testSuccess() {
        Opportunity opp = myOpportunity();
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMock());
        ProjectCalloutService.postOpportunityToPMS(new List<Id>{opp.Id});
        HttpResponse response = ProjectCalloutService.makePostCallout(opp);
        // Verify that the response received contains fake values
        String contentType = response.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = response.getBody();
        System.debug(response.getBody());
        System.assertEquals(201, response.getStatusCode());
        System.assertEquals('Submitted Project', callOpportunity(opp.Id).StageName);
        Test.stopTest();
       
    }

    private static Opportunity myOpportunity() {
        Opportunity opp = new Opportunity(
                Name = 'MyOpportunity',
                StageName = 'Closed Won',
                CloseDate = Date.today().addYears(3),
            	Amount = 20000
        );
        insert opp;
        return opp;
    }

    private static Opportunity callOpportunity(Id oppId) {
        return [SELECT StageName FROM Opportunity WHERE Id =: oppId LIMIT 1];
    }
}

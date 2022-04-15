public with sharing class ProjectCalloutService {
    @InvocableMethod(label='PostOpportunityToPMS' description='Make a callout to PMS' category='Opportunity')
    //Complete the implementation for business and callout logic
    public static void postOpportunityToPMS(list<id> opportunityids){
        //create a queueable job
        Opportunity opp=[Select Id,Name, closeDate,amount,Account.Name FROM Opportunity Where Id =: opportunityids WITH SECURITY_ENFORCED];
        ID jobID = System.enqueueJob(new QueueablePMSCall(opp)); 
        
    }
    
    private class QueueablePMSCall implements Queueable,Database.AllowsCallouts {
       
        private Opportunity opportunityObject;
        
        public QueueablePMSCall(Opportunity op)
        {
            opportunityObject=op;    
        }
        
        public void execute(QueueableContext context) {
          
            makePostCallout(opportunityObject);
         
        }
        
    }
    
    public static HttpResponse makePostCallout(Opportunity op) {
        	String jsonOp;
        	JSONGenerator generator  = JSON.createGenerator(true);
            generator.writeStartObject();
            generator.writeStringField('opportunityId', op.Id);
            generator.writeStringField('opportunityName', op.Name);
            generator.writeStringField('accountName', op.account.Name);
            //generator.writeDateField('closeDate', op.CloseDate);
            //generator.writeNumberField('amount', op.Amount);
            generator.writeEndObject();            
            jsonOp= generator.getAsString();
            
     // perform other processing or callout
            ServiceTokens__c token= ServiceTokens__c.getValues('ProjectServiceToken');
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            //endpoint http link
            request.setEndpoint('callout:ProjectService/'+ token.Token__c);
            //request method GET,POST,PUT,DELETE
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json;charset=UTF-8');
            // Set the body as a JSON object
            request.setBody(jsonOp);
            HttpResponse response = http.send(request);
            
            // Parse the JSON response
            if(response.getStatusCode() == 201) {
                
                Opportunity o=[Select Id, StageName FROM Opportunity Where Id =: op.Id];
                o.StageName='Submitted Project';
                update o;
                
            } else {
                
                Opportunity o=[Select Id, StageName FROM Opportunity Where Id =: op.Id];
                o.StageName='Resubmit Project';
                update o;
                
            }
            
        return response;
    }        
    
}

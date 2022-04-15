/*
Created by Huguette Mpudi 04/18/2022
*/
public class BillingCalloutServiceMockFailure {
   //Implement http mock callout failure here 
      //Implement http mock callout here
    public HttpResponse respond(HttpRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"status":"Failure"}');
        res.setStatusCode(500);
        res.setStatus('Bad Request');
        return res;
    }
}

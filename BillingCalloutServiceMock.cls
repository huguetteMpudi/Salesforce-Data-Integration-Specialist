/*
Created by Huguette Mpudi 04/18/2022
*/
@isTest
public class BillingCalloutServiceMock implements HttpCalloutMock {
   //Implement http mock callout here
    public HttpResponse respond(HttpRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"status":"success"}');
        res.setStatusCode(201);
        res.setStatus('OK');
        return res;
    }
}

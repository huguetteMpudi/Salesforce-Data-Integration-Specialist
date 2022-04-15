@isTest
global class ProjectCalloutServiceMockFailure implements HttpCalloutMock{
    //Implement http mock callout here
    public HttpResponse respond(HttpRequest req) {
        HttpResponse resp = new HttpResponse();
        resp.setHeader('Content-Type', 'application/json');
        resp.setStatusCode(500);
        resp.setStatus('Bad Request');
        return resp;
    }
    
}

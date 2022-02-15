public class WebCallout {
    
    public static void call(){
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:My_CredentialFake');
        req.setMethod('GET');
        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug(res.getBody());
    }

}
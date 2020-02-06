@RestResource(urlMapping='/uuid/*')
global with sharing class uuidRESTApi {
  
    @HttpGet
    global static String doGet() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
      //String accountId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        result = uuid();
        return result;
    }
}

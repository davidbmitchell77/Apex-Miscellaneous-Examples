@RestResource(urlMapping='/uuid/*')
global with sharing class uuidRESTApi {
  //https://dbmlightning-dev-ed.my.salesforce.com/services/data/v61.0/uuid
    @HttpGet
    global static String doGet() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
      //String accountId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        result = uuid();
        return result;
    }
}

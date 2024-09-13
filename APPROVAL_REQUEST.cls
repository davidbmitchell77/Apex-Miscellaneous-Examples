public class ApprovalRequest {

    public ApprovalRequest() {
    }

    public List<Id> submit(String processNameOrId, Id objectId, Id submitterId) {
        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
        req.setProcessDefinitionNameOrId(processNameOrId);
        req.setObjectId(objectId);
        req.setSubmitterId(submitterId);
        req.setSkipEntryCriteria(false);
        req.setComments('Approval request for record Id: ' + objectId);
        Approval.ProcessResult result = Approval.process(req);
        System.assertEquals(true, result.isSuccess());
        System.assertEquals('Pending', result.getInstanceStatus());
        return result.getNewWorkitemIds();
    }

    public Boolean approve(List<Id> workItemIds) {
        Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
        req.setNextApproverIds(new List<Id>{ UserInfo.getUserId() });
        req.setWorkitemId(workItemIds.get(0));
        req.setAction('Approve');
        req.setComments('Approving request for record Id: ' + workItemIds.get(0));
        Approval.ProcessResult result = Approval.process(req);
        return result.isSuccess();
    }
}

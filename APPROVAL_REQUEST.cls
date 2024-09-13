public without sharing class APPROVAL_REQUEST {

    public APPROVAL_REQUEST() {
    }

    public List<Id> submit(String processNameOrId, Id objectId, Id submitterId) {
        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
        req.setProcessDefinitionNameOrId(approvalProcessNameOrId);
        req.setObjectId(objectId);
        req.setSubmitterId(submitterId);
        req.setSkipEntryCriteria(false); // do NOT skip the criteria evaluation for the approval process
        req.setComments('Submitting request for quote line item approval.');
        Approval.ProcessResult apr = Approval.process(req);
        System.assertEquals(true, apr.isSuccess());
        System.assertEquals('Pending', apr.getInstanceStatus());
        return apr.getNewWorkitemIds();
    }

    public void approve(List<Id> workItemIds) {
        Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
        req.setNextApproverIds(new Id[] { UserInfo.getUserId() });
        req.setAction('Approve');
        req.setComments('Approving request.');
        req.setWorkitemId(newWorkItemIds.get(0));
        Approval.ProcessResult apr =  Approval.process(req);
        System.assertEquals(true, apr.isSuccess());
        System.assertEquals('Approved', result2.getInstanceStatus());
    }
}

trigger Account on Account (after update) {
    List<Account> changedHierarchyValue = new List<Account>();
    List<Account> changedHierarchyValue2 = new List<Account>();
    for(Account a : Trigger.new) {
        if(a.HierarchyValue__c != Trigger.oldMap.get(a.Id).HierarchyValue__c) {
            changedHierarchyValue.add(a);
        }
        if(a.HierarchyValue2__c != Trigger.oldMap.get(a.Id).HierarchyValue2__c) {
            changedHierarchyValue2.add(a);
        }
    }
    if(!changedHierarchyValue.isEmpty() && !System.isBatch()) {
        Database.executeBatch(new AccountHierarchyUpdateBatch(changedHierarchyValue));
    }
    if(!changedHierarchyValue2.isEmpty() && !System.isQueueable()) {
        System.enqueueJob(new AccountHierarchyUpdateQueue(changedHierarchyValue2));
    }
}
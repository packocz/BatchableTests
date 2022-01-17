public with sharing class AccountHierarchyUpdateQueue implements Queueable {
    private List<Account> accs;
    public AccountHierarchyUpdateQueue(List<Account> accs) {
        System.debug('contruct q ' + accs.size());
        this.accs = accs;
    }

    public void execute(QueueableContext context) {
        System.debug('exec q ' + this.accs.size());
        Map<Id, String> hierarchyValues = new Map<Id, String>();
        Set<Id> parentIds = new Set<Id>();
        for(Account a : this.accs) {
            hierarchyValues.put(a.Id, a.HierarchyValue2__c);
            parentIds.add(a.Id);
        }
        List<Account> children = [SELECT Id, ParentId, HierarchyValue2__c FROM Account WHERE ParentId IN :parentIds];
        for(Account c : children) {
            c.HierarchyValue2__c = hierarchyValues.get(c.ParentId);
        }
        if(!children.isEmpty()) {
            update children;
            System.enqueueJob(new AccountHierarchyUpdateQueue(children));
        }
    }
}

public with sharing class AccountHierarchyUpdateBatch implements Database.Batchable<SObject>, Database.Stateful{
    private List<Account> accs;
    private List<Account> children;
    public AccountHierarchyUpdateBatch(List<Account> accs) {
        System.debug('contruct b ' + accs.size());
        this.accs = accs;
    }
    public Iterable<SObject> start(Database.BatchableContext BC) {
        System.debug('start b ' + accs.size());
        return this.accs;
    }

    public void execute(Database.BatchableContext info, List<Account> scope) {
        System.debug('exec b ' + scope.size());
        Map<Id, String> hierarchyValues = new Map<Id, String>();
        Set<Id> parentIds = new Set<Id>();
        for(Account a : scope) {
            hierarchyValues.put(a.Id, a.HierarchyValue__c);
            parentIds.add(a.Id);
        }
        this.children = [SELECT Id, ParentId, HierarchyValue__c FROM Account WHERE ParentId IN :parentIds];
        for(Account c : this.children) {
            c.HierarchyValue__c = hierarchyValues.get(c.ParentId);
        }
        if(!this.children.isEmpty()) {
            update children;
        }
    }

    public void finish(Database.BatchableContext bc) {
        System.debug('finish b');
        if(!this.children.isEmpty()) {
            Database.executeBatch(new AccountHierarchyUpdateBatch(this.children));
        }
    }
}

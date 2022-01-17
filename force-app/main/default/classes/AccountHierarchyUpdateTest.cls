@IsTest
private class AccountHierarchyUpdateTest {
    private static final Integer SIZE = 50;

    private static List<Account> createAccounts(String name, String value) {
        List<Account> accs = new List<Account>();
        for (Integer i = 0; i < SIZE; i++) {
            accs.add(new Account(Name = name + i, HierarchyValue__c = value, HierarchyValue2__c = value));
        }
        return accs;
    }
    @TestSetup
    static void generateTestData() {
        List<Account> hierarchy = createAccounts('Hierarchy', 'A');

        insert hierarchy;

        for (Integer i = SIZE-1; i > 0; i--) {
            hierarchy[i].ParentId = hierarchy[i - 1].Id;
        }

        update hierarchy;

        for (Account acc : [
            SELECT Id, Name, HierarchyValue__c, HierarchyValue2__c
            FROM Account
            ORDER BY Name
        ]) {
            System.debug(acc);
        }
    }

    /**
     * Works fine
     */
    @IsTest
    static void testBatch() {
        System.debug('start test method');
        for (Account acc : [
            SELECT Id, Name, HierarchyValue__c
            FROM Account
            ORDER BY Name
        ]) {
            System.debug(acc);
        }

        Account a = [SELECT Id, HierarchyValue__c FROM Account WHERE Name = 'Hierarchy0']; 

        Test.startTest();

        a.HierarchyValue__c = 'B';
        update a;

        System.debug('Stop Test');
        Test.stopTest();

        for (Account acc : [
            SELECT Id, Name, HierarchyValue__c
            FROM Account
            ORDER BY Name
        ]) {
            System.debug(acc);
        }
    }

    /**
     * FAILS due to Queueable chaining
     */
    @IsTest
    static void testQueueable() {
        System.debug('start test method');
        for (Account acc : [
            SELECT Id, Name,  HierarchyValue2__c
            FROM Account
            ORDER BY Name
        ]) {
            System.debug(acc);
        }

        Account a = [SELECT Id, HierarchyValue2__c FROM Account WHERE Name = 'Hierarchy0']; 

        Test.startTest();

        a.HierarchyValue2__c = 'B';
        update a;

        System.debug('Stop Test');
        Test.stopTest();

        for (Account acc : [
            SELECT Id, Name, HierarchyValue2__c
            FROM Account
            ORDER BY Name
        ]) {
            System.debug(acc);
        }
    }
}

# Trying out Batch vs Queueable chaining in Unit tests

While Queueable chaining has to be prevented in Unit tests (otherwise exception is thown) Batch is happy to go round 50 times

## Test Scenario

Account custom field HierarchyValue should be updated for all children of an updated Account. The approach to demonstrate is to use Batch/Queueabe to update immediate Child Accounts of the changed Accounts and re-trigger the same job one level lower.

While this works fine for both situations, in Unit Tests it only works for Batch. 

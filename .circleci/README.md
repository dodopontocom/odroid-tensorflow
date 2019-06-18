# Circleci Integration  

We have set up a consolidate model of github and circleci integration  
A commit to an especific branch will trigger the whole workflow  

### Branch master  

Triggers: (not used yet, as the solution is not in production)
- [ ] the production development regarding python script for tensorflow training scripts

### Branch develop  

Triggers:  
- [x] test the solution with the previous deployed docker image  
- [x] Initialize and deploy the solution to GCP compute instance  

### Branch docker  

Triggers:  
- [x] build the currently code to update the docker image in dockerhub
- [x] test the solution with the new deployed docker image  

### Branch terraform  

Triggers:
- [ ] Run complete flow to have the solution deployed and maintained into GCP

### Other branches

Triggers:
- [ ] Run tests

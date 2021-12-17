public class SRM_GeneratePackageListViewConttroller {
    
    private ApexPages.StandardSetController stdSetController;
    public List<SRM_Jira_Ticket__c> selectedJiraTickets;
    
    public SRM_GeneratePackageListViewConttroller(ApexPages.StandardSetController stdSetController){
        this.stdSetController = stdSetController;
    }
    
    public PageReference generatePackage(){
   
        if(stdSetController.getSelected().size() > 0){
                      
            Set<Id> jiraIds = new Set<Id>();
            
            for(SRM_Jira_Ticket__c jiraTicket : (List<SRM_Jira_Ticket__c>) stdSetController.getSelected()){
                jiraIds.add(jiraTicket.Id);
            }
            
            selectedJiraTickets = [SELECT Id,Rebased_By__c FROM SRM_Jira_Ticket__c WHERE Id IN :jiraIds];
            
            List<SRM_Metadata__c> mdItems = [SELECT Type__c,Name__c FROM SRM_Metadata__c WHERE Jira_Ticket__c IN :jiraIds
                                            AND Type__c != 'Profile'];
            
            Document doc = createDocument(mdItems);
            
            String folderId = String.valueOf(doc.FolderId).substring(0,15);
            
            PageReference docPage = new PageReference('/015');
            docPage.getParameters().put('fcf',folderId);
            
            updateRebasedBy();
            
            return docPage;
            
        }else{
            
            return null;
            
        }    
    }
    
    private Document createDocument(List<SRM_Metadata__c> mdItems){
        
        String packageXML = new SRM_PackageXML().generate(mdItems);
        Blob documentBlob = Blob.valueOf(packageXML);
        
        Folder folder = [SELECT Id FROM Folder WHERE DeveloperName = 'SRM_Packages' LIMIT 1];
        
        Date todayDate = Date.today();
        String stringDate = todayDate.day()+'-'+todayDate.month()+'-'+'-'+todayDate.year();
        
        Document doc = new Document();
        doc.Body = documentBlob;
        doc.Name = UserInfo.getFirstName()+'-Rebase-'+stringDate+'-package.xml';
        doc.FolderId = folder.Id;
        
        insert doc;   
        return doc;
        
    }
    
    private void updateRebasedBy(){
        
        String userFirstName = UserInfo.getFirstName();
        
        for(SRM_Jira_Ticket__c ticket : selectedJiraTickets){
            if(ticket.Rebased_By__c == null){
                ticket.Rebased_By__c = userFirstName+',';
            }else{
                ticket.Rebased_By__c = ticket.Rebased_By__c+userFirstName;
            }    
        }
        
        update selectedJiraTickets;
        
    }
    
    
}
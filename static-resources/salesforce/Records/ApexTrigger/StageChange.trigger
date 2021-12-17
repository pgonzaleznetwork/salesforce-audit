trigger StageChange on Opportunity (before insert) {
    
    List<Opportunity> opps = (List<Opportunity>)trigger.new;
    
    for(Opportunity o : opps){
        if(o.StageName != ''){
            System.debug('yay');
        }
    }
}
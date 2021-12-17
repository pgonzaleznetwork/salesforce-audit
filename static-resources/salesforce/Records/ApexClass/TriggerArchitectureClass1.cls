/*Copyright (c) 2018, Daniel Appleman

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, 
this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, 
this list of conditions and the following disclaimer in the documentation 
and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its contributors 
may be used to endorse or promote products derived from this software without 
specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. 
IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, 
INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES 
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; 
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND 
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF 
THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

public with sharing class TriggerArchitectureClass1  implements TriggerDispatcher.ITriggerEntry{
	
    public void mainEntry(TriggerOperation triggerType, Schema.SObjectType objectType,
             List<SObject> newObjlist, Map<ID, SObject> newObjMap, 
             List<SObject> oldObjList, Map<ID,SObject> oldObjMap)
	{
        if(objectType!= Opportunity.SObjectType) return;
        List<Opportunity> newList = (List<Opportunity>)newObjList;
        List<Opportunity> oldList = (List<Opportunity>)oldObjList;
        Map<ID, Opportunity> newMap = TriggerDispatcher.castMapToOpportunities(newObjMap);
        Map<ID, Opportunity> oldMap = TriggerDispatcher.castMapToOpportunities(oldObjMap);

        List<OpportunityStage> opStages = [Select ID, DefaultProbability, MasterLabel from OpportunityStage Order By SortOrder Asc];
        Map<String, Integer> opLabelsToPosition = new Map<String,Integer>();
        for(Integer x = 0; x< opStages.size(); x++)
            opLabelsToPosition.put(opStages[x].MasterLabel, x);

        Map<ID, Opportunity> updateableMap;
        List<Opportunity> opsToUpdate;
        if(triggertype == TriggerOperation.AFTER_INSERT || triggertype == TriggerOperation.AFTER_UPDATE)
        {
            System.debug('TriggerArchitectureClass1 being executed after insert or after update, getting updatable objects');
           updateableMap = TriggerDispatcher.castMapToOpportunities(TriggerDMLSupport.getUpdatableObjects(Opportunity.SObjectType, newMap.keyset()));
            opsToUpdate = new List<Opportunity>();
        }

        switch on triggerType {
            when BEFORE_INSERT
            {
                System.debug('TriggerArchitectureClass1 being executed before insert');
                for(Opportunity op:newlist)
                {
                    // Do some processing here
                    // No need to add entries to the objectstoupdate map in before triggers
                    System.debug('TriggerArchitectureClass1 initial oppty stage is '+op.stageName );
                    op.stageName = opStages[1].MasterLabel;
                    System.debug('TriggerArchitectureClass1 set the stage to '+opStages[1].MasterLabel+' on before insert');
                }
            }
            When AFTER_INSERT, AFTER_UPDATE
            {
                 System.debug('TriggerArchitectureClass1 being executed before after insert or after update, doing actual processing');
                String targetStage = (triggerType== TriggerOperation.AFTER_INSERT)? 
                    opStages[2].MasterLabel:opStages[3].MasterLabel;
                for(Opportunity op:newlist)
                {
                    if(op.stageName!= targetStage && opLabelsToPosition.get(op.stageName) < opLabelsToPosition.get(targetStage) )
                    {
                        System.debug('TriggerArchitectureClass1 after insert or after update, original stage value is '+op.StageName);
                        Opportunity updateableOp = updateableMap.get(op.id);
                        updateableOp.stageName = targetStage;
                        // Mark for update if changed
                        System.debug('TriggerArchitectureClass1 marking the following oppty for update '+updateableOp);
                        opsToUpdate.add(updateableOp);
                    }
                }  
            }
        }

        System.debug('TriggerArchitectureClass1 queing the following objects for update '+opsToUpdate);
        TriggerDMLSupport.queueForUpdates(opsToUpdate);

	}

    public void inProgressEntry(TriggerOperation triggerType, Schema.SObjectType objectType,
             List<SObject> newObjlist, Map<ID, SObject> newObjMap, 
             List<SObject> oldObjList, Map<ID,SObject> oldObjMap)
	{
        System.debug('TriggerArchitectureClass1 executring the inProgressEntry');
    }

    public void inDmlEntry(TriggerOperation triggerType, Schema.SObjectType objectType,
             List<SObject> newObjlist, Map<ID, SObject> newObjMap, 
             List<SObject> oldObjList, Map<ID,SObject> oldObjMap)
	{
         System.debug('TriggerArchitectureClass1 executring the inDmlEntry');
    }



}
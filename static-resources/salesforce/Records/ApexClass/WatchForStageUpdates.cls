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
/*
    This class watches for the opportunity probability to go over 20%. If so, it creates a task
*/
public with sharing class WatchForStageUpdates  implements TriggerDispatcher.ITriggerEntry {

   	private static Map<ID, Double> probabilityOverrides = null;

    public void mainEntry(TriggerOperation triggerType, Schema.SObjectType objectType,
             List<SObject> newObjlist, Map<ID, SObject> newObjMap, 
             List<SObject> oldObjList, Map<ID,SObject> oldObjMap)
    {
        processStageUpdate(triggerType, objectType,
             newObjlist, newObjMap, 
             oldObjList, oldObjMap);
    }

    public void processStageUpdate(TriggerOperation triggerType, Schema.SObjectType objectType,
             List<SObject> newObjlist, Map<ID, SObject> newObjMap, 
             List<SObject> oldObjList, Map<ID,SObject> oldObjMap)
	{
        if(objectType!= Opportunity.SObjectType) return;
        List<Opportunity> newList = (List<Opportunity>)newObjList;
        List<Opportunity> oldList = (List<Opportunity>)oldObjList;
        Map<ID, Opportunity> newMap = TriggerDispatcher.castMapToOpportunities(newObjMap);
        Map<ID, Opportunity> oldMap = TriggerDispatcher.castMapToOpportunities(oldObjMap);

		if(probabilityOverrides==null) probabilityOverrides = new Map<ID, Double>();

        switch on triggerType {
            When AFTER_INSERT, AFTER_UPDATE
            {
                System.debug('WatchForStageUpdates being called after insert or after update');
                List<Task> newTasks = new List<Task>();
                List<Opportunity> opsToUpdate = new List<Opportunity>();

                for(Opportunity op:newlist)
                {
        			Double oldProbability = (probabilityOverrides.containskey(op.id))? 
				                            probabilityOverrides.get(op.id) : 
				                            ((oldMap==null)? 0: oldMap.get(op.id).Probability);
                    system.debug('old probability ' + 
                                ((oldMap!=null)? String.valueOf(oldMap.get(op.id).Probability): 'n/a') + 
			                    ' new probability ' + op.Probability);
                    if((triggerType== TriggerOperation.AFTER_INSERT || oldProbability <=20) && op.Probability>50)
                    {
				        newTasks.add(
                            new Task(ownerId = op.OwnerID, 
                                WhatID = op.id, 
                                ActivityDate = Date.Today().addDays(2), 
                                Subject='Opportunity stage update', 
                                Type='Other'));
                        Opportunity updatingOp = new Opportunity(Id = op.id);
                        updatingOp.Description = ((op.Description==null)? '': op.Description) + ' Stage update task on ' + Date.Today().format();
                        //updatingOp.Internal_Update__c = 'WatchForStageUpdates - ' + String.ValueOf(DateTime.Now().getTime());
                        System.debug('WatchForStageUpdates adding the following object to update '+updatingOp);
                        opsToUpdate.add(updatingOp);
                        if(oldProbability != op.Probability) 
				            probabilityOverrides.put(op.id, op.Probability);
                    }
                }  
            if(newTasks.size()>0) insert newtasks;
            
            if(opsToUpdate.size()>0) {
                System.debug('WatchForStageUpdates about to do DML in opportunities');
                update opsToUpdate;
            }
            }
        }

	}

    public void inProgressEntry(TriggerOperation triggerType, Schema.SObjectType objectType,
             List<SObject> newObjlist, Map<ID, SObject> newObjMap, 
             List<SObject> oldObjList, Map<ID,SObject> oldObjMap)
	{
        System.debug('In progress entry for WatchForStageUpdates, calling the invokeMainEntry of TriggerArchitectureClass2');
        TriggerDispatcher.invokeMainEntry(new TriggerArchitectureClass2(), 
            triggerType, objectType, newObjList, newObjMap, oldObjList, oldObjMap);
    }

    public void inDmlEntry(TriggerOperation triggerType, Schema.SObjectType objectType,
             List<SObject> newObjlist, Map<ID, SObject> newObjMap, 
             List<SObject> oldObjList, Map<ID,SObject> oldObjMap)
	{
        System.debug('inDmlEntry for WatchForStageUpdates, calling processStageUpdate');
        processStageUpdate(triggerType, objectType,
             newObjlist, newObjMap, 
             oldObjList, oldObjMap);
    }


}
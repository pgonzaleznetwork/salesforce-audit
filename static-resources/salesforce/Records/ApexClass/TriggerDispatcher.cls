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
public with sharing class TriggerDispatcher {

	public static ITriggerEntry activeFunction = null;    

	public interface ITriggerEntry
	{
		void mainEntry(TriggerOperation triggerType, 
                        Schema.SObjectType objectType,
                        List<SObject> newList, Map<ID, SObject> newMap, 
						List<SObject> oldList, Map<ID,SObject> oldMap);

		void inProgressEntry(TriggerOperation triggerType,
                        Schema.SObjectType objectType,
						List<SObject> newList, 
						Map<ID, SObject> newMap, 
						List<SObject> oldList, Map<ID,SObject> oldMap);

		void inDmlEntry(TriggerOperation triggerType,
                        Schema.SObjectType objectType,
						List<SObject> newList, 
						Map<ID, SObject> newMap, 
						List<SObject> oldList, Map<ID,SObject> oldMap);

	}

    public static void handleTriggers(TriggerOperation triggerType, List<SObject> newList, 
			Map<ID, SObject> newMap, List<SObject> oldList, 
			Map<ID,SObject> oldMap)
    {

        SObject firstObject = (triggerType == TriggerOperation.AFTER_DELETE || triggerType== TriggerOperation.BEFORE_DELETE)? 
            oldList[0]: newList[0];
        
        if(activeFunction!=null)
        {
            // Active function always gets all triggers
            System.debug('active function is '+activeFunction+' so invoking the inProgressEntry');
            activeFunction.inProgressEntry(triggerType, firstObject.getSObjectType(), newList, newMap, oldList, oldMap);
            return;
        }

        if(TriggerDMLSupport.updatingPendingObjects)
        {
            // During internal DML update, forward only to those classes that need to see the trigger
            activeFunction = new WatchForStageUpdates();
            System.debug('internal dml, so forwarding to WatchForStageUpdates in the inDmlEntry');
            activeFunction.inDmlEntry(triggerType, firstObject.getSObjectType(), newList, newMap, oldList, oldMap);
            activeFunction = null;
            return;
        }

        switch on firstObject
        {
            when Opportunity obj
            {
                List<ITriggerEntry> opportunityHandlers = new List<ITriggerEntry>{ new TriggerArchitectureClass1(), new TriggerArchitectureClass2(), new WatchForStageUpdates()};

                for(ITriggerEntry handler: opportunityHandlers)
                {
                    invokeMainEntry(handler, triggerType, firstObject.getSObjectType(), newList, newMap, oldList, oldMap);
                }
            }
        }

        TriggerDMLSupport.updatePendingObjects();

    }

    public static void invokeMainEntry(
        ITriggerEntry handler, TriggerOperation triggerType, Schema.SObjectType objectType,
        List<SObject> newList, Map<ID, SObject> newMap, 
        List<SObject> oldList, Map<ID,SObject> oldMap)
    {

        ITriggerEntry oldActiveFunction = activeFunction;
        System.debug('invoking main entry for handler '+handler+' - active function is '+activeFunction);
        handler.mainEntry(triggerType, objectType, newList, newMap, oldList, oldMap);
        System.debug('completely out of the main entry');
        activeFunction = oldActiveFunction;
    }

    // Helper function, since we can't cast directly from a map of ID,SObject to a specific type
    public static Map<ID, Opportunity> castMapToOpportunities(Map<ID, SObject> sourceMap)
    {
        if(sourceMap==null) return null;
        return new Map<ID, Opportunity>((List<Opportunity>)sourceMap.values());
    }





}
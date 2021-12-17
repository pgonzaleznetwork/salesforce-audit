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
public with sharing class TriggerDMLSupport {
    
    public static Boolean updatingPendingObjects = false;
    private static Map<Schema.SObjectType, Map<ID, SObject>> objectsToUpdate = new Map<Schema.SObjectType, Map<ID, SObject>>();

    // Return a map of updatable SObject records
    public static Map<ID, SObject> getUpdatableObjects(Schema.SObjectType objType, Set<ID> objIds)
    {
        Map<ID, SObject> objMap = objectsToUpdate.get(objType);
        if(objMap==null)
        {
            objMap = new Map<ID, SObject>();
            objectsToUpdate.put(objType, objMap);
        }
        Map<ID, SObject> results = new Map<ID, SObject>();
        for(ID objId: objIds) results.put(objID, (objMap.containsKey(objId))? objMap.get(objId): objType.newSObject(objId));
        return results;
    }

    // We assume all objects are of the same type
    // You can add some error checking here just in case
    public static void queueForUpdates(List<SObject> toUpdate)
    {
        if(toUpdate==null || toUpdate.size()==0) return;
        Schema.SObjectType objType = toUpdate[0].id.getSobjectType();
        Map<ID, SObject> mapForSObjectType = objectsToUpdate.get(objType);
        mapForSObjectType.putAll(toUpdate);
    }

    private static Boolean updatesPending()
    {
        for(Schema.SObjectType objType: objectsToUpdate.keyset())
        {
            if(objectsToUpdate.get(objType).size()>0) return true;
        }
        return false;
    }

    public static void updatePendingObjects()
    {
        if(!updatingPendingObjects) 
        {
            while(updatesPending())
            {
                System.debug('pending objects to update about to be updated');
                System.debug('objects to update '+objectsToUpdate);
                for(Schema.SObjectType objType: objectsToUpdate.keyset())
                {
                    Map<ID, SObject> objectToUpdateMap = objectsToUpdate.get(objType);
                    if(objectToUpdateMap.size()==0) continue;
                    List<SObject> updatingList = objectToUpdateMap.values();
                    objectsToUpdate.put(objType, new Map<ID, SObject>());
                    updatingPendingObjects = true;
                    System.debug('about to do internal dml on '+updatingList);
                    update updatingList;
                    System.debug('completely out of the internal dml');
                    updatingPendingObjects = false;
                }
            }
        }
    }

}
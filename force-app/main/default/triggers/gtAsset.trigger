/**
 * Created by oputria on 27.10.2020.
 */

trigger gtAsset on Asset (after insert) {
    gcAssetHandler.triggerHandler(Trigger.oldMap,
            Trigger.newMap,
            Trigger.new,
            Trigger.isInsert,
            Trigger.isAfter);
}
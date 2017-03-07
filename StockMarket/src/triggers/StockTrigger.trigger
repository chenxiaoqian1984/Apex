trigger StockTrigger on Stock__c (before insert, after insert, 
 before update, after update, before delete, after delete, after undelete) {

	System.debug('Singleton Count:'+Singleton.instance().count());

 	new Triggers()
        .bind(Triggers.Evt.BeforeUpdate,new DuplicateStockHandler())
        .bind(Triggers.Evt.BeforeInsert,new DuplicateStockHandler())   
        .manage();

}
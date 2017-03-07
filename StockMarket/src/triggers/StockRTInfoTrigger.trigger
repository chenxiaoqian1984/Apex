trigger StockRTInfoTrigger on Stock_RTInfo__c(before insert, after insert, 
 before update, after update, before delete, after delete, after undelete) {
    new Triggers()
        .bind(Triggers.Evt.BeforeInsert,new StockRTInfoSetStockIdHandler())
        .manage();
}
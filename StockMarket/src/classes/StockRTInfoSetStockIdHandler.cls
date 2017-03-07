/**
 * 插入实时股票信息时，关联上股票信息
 */
public without sharing class StockRTInfoSetStockIdHandler implements Triggers.Handler {

	public void handle() {

		Set<String> nameset = new Set<String>();
		for(Stock_RTInfo__c item:(List<Stock_RTInfo__c>)Trigger.new){
            nameset.add(item.StockName__c);
        }

        StockDao sd = new StockDao();
        String []names = new List<String>(nameset);
        
        //根据股票名称查出所有的Stock信息。
        List<Stock__c> stockList = sd.getStockListByNames(names);
        Map<String,String> name_id_map = new Map<String,String>();
        for(Stock__c sto:stockList){
        	name_id_map.put(sto.Name, sto.Id);
        }

        for(Stock_RTInfo__c st:(List<Stock_RTInfo__c>)Trigger.new){
	        if(st.Stock__c == null){
	        	st.Stock__c = name_id_map.get(st.StockName__c);
	        }
	    }
	}
    
}
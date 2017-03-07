/**
 * 插入或更新Stock前，判断Stock Name不重复
 */
public without sharing class DuplicateStockHandler implements Triggers.Handler {

	public void handle() {

		Map<String,Stock__c> tmMap = new Map<String,Stock__c>();

		for(Stock__c item:(List<Stock__c>)Trigger.new){
            tmMap.put(item.Name, item);
        }

        StockDao sd = new StockDao();
        String []names = new List<String>(tmMap.keySet());
        List<Stock__c> stockList = sd.getStockListByNames(names);

        for(Stock__c st:(List<Stock__c>)Trigger.new){
	        for(Stock__c ost:stockList){
	        	if(st.Id==null){
		        	if(st.Name == ost.Name){
		        		st.addError('Stock Name already exists!');
		        	}
		        }else{
					if(st.Name == ost.Name && st.Id <> ost.Id){
		        		st.addError('Stock Name already exists!');
		        	}
		        }
	        }
	    }
	}
    
}
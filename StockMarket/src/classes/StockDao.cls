/**
 * Stock 对象CRUD操作类
 */
public without sharing class StockDao {


	/**
	  [getAllStockList 获取所有股票信息]
	 * @return [description]
	 */
	public List<Stock__c> getAllStockList(){
		List<Stock__c> stockList = [
			SELECT 
				Id,
				Name,
				isGrab__c,
				Stock_Code__c,
				Stock_Exchange__c,
				Stock_Full_Name__c,
				Stock_Market_Index__c
			FROM 
				Stock__c
		];
		return stockList;
	}

	/**
	  [getStockListByIds 根据传入的id列表获取股票列表]
	 * @return [description]
	 */
	public List<Stock__c> getStockListByIds(String[] Ids){

		if(Ids == null) return null;

		if(Ids.isEmpty()) return null;

		List<Stock__c> stockList = [
			SELECT 
				Id,
				Name,
				isGrab__c,
				Stock_Code__c,
				Stock_Exchange__c,
				Stock_Full_Name__c,
				Stock_Market_Index__c
			FROM 
				Stock__c
			WHERE Id IN:ids
		];
		return stockList;
	}

	/**
	 [getStockById 通过stockId获取某股票]
	 * @param  stockId [description]
	 * @return         [description]
	 */
	public Stock__c getStockById(String stockId){

		if(String.isBlank(stockId)) return null;

		List<Stock__c> stockList = getStockListByIds(new String[]{stockId});
		
		return stockList.isEmpty()?null:stockList.get(0);
	}

	private String sosql_all = 'SELECT Id,Name,isGrab__c,Stock_Code__c,Stock_Exchange__c,Stock_Full_Name__c,'
			+'Stock_Market_Index__c FROM Stock__c ';

	/**
     [getStockByCondition 自定义条件查询股票信息列表]
     * @param  condition [description]
     * @return           [description]
     */
    public List<Stock__c> getStockByCondition(String condition){
        if(String.isBlank(condition)){
            return null;
        }

        String queryStr = sosql_all +' '+condition;

        List<Stock__c> stockList = Database.query(queryStr);

        return stockList;
    }
	
	/**
	  [getStockListByNames 根据传入的Name列表获取股票列表]
	 * @return [description]
	 */
	public List<Stock__c> getStockListByNames(String[] names){

		if(names == null) return null;

		if(names.isEmpty()) return null;

		String queryStr = sosql_all +' WHERE Name IN:names';

		List<Stock__c> stockList = Database.query(queryStr);

		return stockList;
	}

	/**
	 [getStockByName 通过stock Name获取某股票]
	 * @param  stockName [description]
	 * @return         [description]
	 */
	public Stock__c getStockByName(String stockName){

		if(String.isBlank(stockName)) return null;

		List<Stock__c> stockList = getStockListByNames(new String[]{stockName});
		
		return stockList.isEmpty()?null:stockList.get(0);
	}


	/**
	 [getStockListByCodes 通过stock Code获取股票列表]
	 * @param  codes [description]
	 * @return       [description]
	 */
	public List<Stock__c> getStockListByCodes(String[] codes){

		if(codes == null) return null;

		if(codes.isEmpty()) return null;

		String queryStr = sosql_all +' WHERE Stock_Code__c IN:codes';

		List<Stock__c> stockList = Database.query(queryStr);

		return stockList;
	}

	/**
	 [getStockByName 通过stock Code获取某股票]
	 * @param  stockName [description]
	 * @return         [description]
	 */
	public Stock__c getStockByCode(String code){

		if(String.isBlank(code)) return null;

		List<Stock__c> stockList = getStockListByCodes(new String[]{code});
		
		return stockList.isEmpty()?null:stockList.get(0);
	}
}
/**
 * 重构示例，外观
 */
public without sharing class MyStockDao extends BaseDao {
    
    private StockDao sDao;
    
    public MyStockDao(){
    	this.sDao = new StockDao();
    	this.sosql_all = 'SELECT Id,Name,isGrab__c,Stock_Code__c,Stock_Exchange__c,Stock_Full_Name__c,'
			+'Stock_Market_Index__c FROM Stock__c ';
    }

	public List<Stock__c> getAllStockList(){
		return sDao.getAllStockList();
	}

	public List<Stock__c> getStockListByIds(String[] Ids){
		return sDao.getStockListByIds(Ids);
	}

	public Stock__c getStockById(String stockId){
		return sDao.getStockById(stockId);
	}

	public List<Stock__c> getStockByCondition(String condition){
		return sDao.getStockByCondition(condition);
	}

	public List<Stock__c> getStockListByNames(String[] names){
		return sDao.getStockListByNames(names);
	}
	
	public Stock__c getStockByName(String stockName){
		return sDao.getStockByName(stockName);
	}

	public List<Stock__c> getStockListByCodes(String[] codes){
		return sDao.getStockListByCodes(codes);
	}

	public Stock__c getStockByCode(String code){
		return sDao.getStockByCode(code);
	}

	/**
	 [removeByCodes 传入股票代码数组，删除对应股票]
	 * @param  codes [description]
	 * @return       [description]
	 */
	public List<String> removeByCodes(String [] codes){
		if(null == codes) return null;
		if(codes.isEmpty()) return null;
		return remove(this.getStockListByCodes(codes));
	}

	/**
	 [removeByCode 删除对应code的股票]
	 * @param  code [description]
	 * @return      [description]
	 */
	public List<String> removeByCode(String code){
		if(String.isBlank(code)) return null;
		return removeByCodes(new String[]{code});
	}

}
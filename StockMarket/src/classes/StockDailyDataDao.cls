/**
 * DailyData 对象CRUD操作类
 */
public with sharing class StockDailyDataDao extends BaseDao {

	public StockDailyDataDao(){
        this.sosql_all = 'SELECT Id,Name,'
                +'Close_Price__c, Current_Price__c, DT__c, High_Price__c,'
                +'Low_Price__c, Open_Price__c,AvgPrice__c,Quota__c,Volume__c,'
                +'Stock__c,Stock__r.Name,Stock__r.Stock_Code__c,Stock__r.Stock_Exchange__c,'
                +'Stock__r.Stock_Market_Index__c,Stock__r.isGrab__c '
                +'FROM DailyData__c ';
    }

    /**
     [getDailyDataByStockId 根据股票id列表,查询日线数据]
     * @param  []stockIds [description]
     * @return            [description]
     */
    public List<DailyData__c> getDailyDataByStockIds(String []stockIds){
    	if(stockIds == null) return null;

        if(stockIds.isEmpty()) return null;
        
        String queryStr = sosql_all +' WHERE Stock__c IN:stockIds order by DT__c DESC';

        List<DailyData__c> stockList = Database.query(queryStr);

        return stockList;
    }

    /**
     [getDailyDataByStockId 根据股票id,查询日线数据]
     * @param  stockId [description]
     * @return         [description]
     */
    public List<DailyData__c> getDailyDataByStockId(String stockId){
    	if(String.isBlank(stockId)) return null;
        return getDailyDataByStockIds(new String[]{stockId});
    }

    /**
     [update 更新日线数据]
     * @param  dailyDatas [description]
     * @return            [description]
     */
    public List<String> updateDailyData(List<DailyData__c> dailyDatas) {
        return super.save(dailyDatas, false);
    }

    /**
     [insert 插入日线数据]
     * @param  dailyDatas [description]
     * @return            [description]
     */
    public List<String> insertDailyData(List<DailyData__c> dailyDatas) {
        return super.save(dailyDatas, true);
    }
    
}
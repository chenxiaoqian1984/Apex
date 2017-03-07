/**
 * Stock_RTInfo__c 对象CRUD操作类
 */
public without sharing class StockRTInfoDao extends BaseDao{

    private String sosql_all = 'SELECT Id,Name,LongOrShort__c,Buy1_Price__c, Buy1_Volume__c, Buy2_Price__c, Buy2_Volume__c, '
                    +'Buy3_Price__c, Buy3_Volume__c, Buy4_Price__c, Buy4_Volume__c, Buy5_Price__c, '
                    +'Buy5_Volume__c, Buy_Price__c, Close_Price__c, Current_Price__c, DT__c, High_Price__c, '
                    +'Low_Price__c, Open_Price__c, Quota__c, Sell1_Price__c, Sell1_Volume__c, Sell2_Price__c, '
                    +'Sell2_Volume__c, Sell3_Price__c, Sell3_Volume__c, Sell4_Price__c, Sell4_Volume__c, '
                    +'Sell5_Price__c, Sell5_Volume__c, Sell_Price__c, Stock__c, StockName__c, Volume__c '
                    +'FROM Stock_RTInfo__c ';

    /**
     [getStockRTInfoByCondition 自定义条件查询实时股票列表]
     * @param  condition [description]
     * @return           [description]
     */
    public List<Stock_RTInfo__c> getStockRTInfoByCondition(String condition){
        if(String.isBlank(condition)){
            return null;
        }

        String queryStr = sosql_all +' '+condition;

        List<Stock_RTInfo__c> stockList = Database.query(queryStr);

        return stockList;
    }
    
    /**
     * [getStockRTInfoByStockIds 根据股票Id列表查询实时信息列表]
     * @param  []stockIds [description]
     * @return            [description]
     */
    public List<Stock_RTInfo__c> getTodayStockRTInfoByStockIds(String []stockIds){
        if(stockIds == null) return null;

        if(stockIds.isEmpty()) return null;

        String queryStr = sosql_all +' WHERE Stock__c IN:stockIds and DT__c = TODAY order by DT__c DESC';

        List<Stock_RTInfo__c> stockList = Database.query(queryStr);

        return stockList;
    }

    /**
     * [getMonthlyStockRTInfo 获取当月所有数据]
     * @return [description]
     */
    public List<Stock_RTInfo__c> getMonthlyStockRTInfo(){
        
        String queryStr = sosql_all +' WHERE DT__c = THIS_MONTH';

        List<Stock_RTInfo__c> stockList = Database.query(queryStr);

        return stockList;
    }

    /**
     [getStockRTInfoByStockId 根据股票Id查询实时信息列表]
     * @param  stockId [description]
     * @return            [description]
     */
    public List<Stock_RTInfo__c> getTodayStockRTInfoByStockId(String stockId){
        if(String.isBlank(stockId)) return null;
        return getTodayStockRTInfoByStockIds(new String[]{stockId});
    }


}
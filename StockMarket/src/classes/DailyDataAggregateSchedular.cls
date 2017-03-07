/**
 *
    每天定时将实时数据聚合到日线数据上
    DailyDataAggregateSchedular gs = new DailyDataAggregateSchedular();
    String sch1 = '0 10 15 ? * MON-FRI';
    system.schedule('DailyDataAggregateSchedular', sch1, gs);
 */
global class DailyDataAggregateSchedular implements Schedulable {

    global void execute(SchedulableContext sc) {
        //日开盘、收盘、最高、最低、均价价格，日成交额，日成交量
        StockRTInfoDao srtDao = new StockRTInfoDao();
        //查询实时股票的最后一次抓取数据
        List<Stock_RTInfo__c> srtInfos 
        	= srtDao.getStockRTInfoByCondition('WHERE DT__c = TODAY AND HOUR_IN_DAY(DT__c) = 7');
    	
      	Map<String,Stock_RTInfo__c> id_rt_map = new Map<String,Stock_RTInfo__c>();
      	for(Stock_RTInfo__c rt:srtInfos){
      		  id_rt_map.put(rt.Stock__c, rt);
      	}
    	
    	  StockDao sd = new StockDao();
        List<Stock__c> stockList = sd.getStockByCondition('WHERE isGrab__c=true');

        //设置均价
        AggregateResult[] groupedResults = [
            SELECT 
              Stock__c,
              Avg(Current_Price__c)
      			FROM 
              Stock_RTInfo__c 
      			WHERE DT__c = TODAY
      			GROUP BY StockName__c,Stock__c,DAY_ONLY(DT__c)
        ];

      	Map<String,Decimal> stockId_avgMap = new Map<String,Decimal>();

    		for (AggregateResult ar : groupedResults) {
    			 stockId_avgMap.put((String)ar.get('Stock__c'), (Decimal)ar.get('expr0'));
    		}

        List<DailyData__c> dds = new List<DailyData__c>();

        for(Stock__c stk:stockList){
            Stock_RTInfo__c rt = id_rt_map.get(stk.Id);
            DailyData__c ddc = new DailyData__c();

            ddc.Stock__c = stk.Id;
            ddc.Open_Price__c = rt.Open_Price__c;
            ddc.Close_Price__c = rt.Close_Price__c;
            ddc.High_Price__c = rt.High_Price__c;
            ddc.Low_Price__c = rt.Low_Price__c;
            ddc.Volume__c 	= rt.Volume__c;
            ddc.Quota__c = rt.Quota__c;
            ddc.Current_Price__c = rt.Current_Price__c;
            if(!stockId_avgMap.isEmpty())
            		ddc.AvgPrice__c = stockId_avgMap.get(stk.Id);
            ddc.DT__c = rt.DT__c.date();
            dds.add(ddc);
        }

        StockDailyDataDao dailyDataDao = new StockDailyDataDao();
        List<String> savedIds = dailyDataDao.insertDailyData(dds);
        System.debug('Saved Ids are '+savedIds);
    }
}
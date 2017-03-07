@isTest
private class StockRTInfoDaoTest {

	@testSetup
	static void setup(){

		List<Stock__c> slist = new List<Stock__c>();

		Stock__c stock = new Stock__c(
			Name='北方导航',
			Stock_Code__c='600435',
			isGrab__c=true,
			Stock_Exchange__c='sh',
			Stock_Market_Index__c=false);
		slist.add(stock);

		stock = new Stock__c(
			Name='上证指数',
			Stock_Code__c='000001',
			isGrab__c=true,
			Stock_Exchange__c='sh',
			Stock_Market_Index__c=true);
		slist.add(stock);

		insert slist;

		List<Stock_RTInfo__c> srtList = new List<Stock_RTInfo__c>();
		for(Integer i=0; i<10; i++){
			Stock_RTInfo__c src = new Stock_RTInfo__c();
			// src.LongOrShort__c = '平';
			src.Buy1_Price__c = Math.random()+15;
	        src.Buy1_Volume__c = Math.random()*1000;
	        src.Buy2_Price__c = Math.random()+15;
	        src.Buy2_Volume__c = Math.random()*1000;
	        src.Buy3_Price__c = Math.random()+15;
	        src.Buy3_Volume__c = Math.random()*1000;
	        src.Buy4_Price__c = Math.random()+15;
	        src.Buy4_Volume__c = Math.random()*1000;
	        src.Buy5_Price__c = Math.random()+15;
	        src.Buy5_Volume__c = Math.random()*1000;
	        src.Buy_Price__c = Math.random()+15;
	        src.Close_Price__c = Math.random()+15;
	        src.Current_Price__c = Math.random()+15;
	        src.DT__c = Datetime.now();
	        src.High_Price__c = Math.random()+16;
	        src.Low_Price__c = Math.random()+15;
	        src.Open_Price__c = Math.random()+15;
	        src.Quota__c = 2300458;
	        src.Sell1_Price__c = Math.random()+15;
	        src.Sell1_Volume__c = Math.random()*1000;
	        src.Sell2_Price__c = Math.random()+15;
	        src.Sell2_Volume__c = Math.random()*1000;
	        src.Sell3_Price__c = Math.random()+15;
	        src.Sell3_Volume__c = Math.random()*1000;
	        src.Sell4_Price__c = Math.random()+15;
	        src.Sell4_Volume__c = Math.random()*1000;
	        src.Sell5_Price__c = Math.random()+15;
	        src.Sell5_Volume__c = Math.random()*1000;
	        src.Sell_Price__c = Math.random()+15;
	        // src.Stock__c = f[0]; //交给trigger去设置
	        src.StockName__c = '北方导航';
	        src.Volume__c = Math.random()*1000909;
	        srtList.add(src);
	    }
        insert srtList;
	}

    static testMethod void testAllGet() {
        StockRTInfoDao srtDao = new StockRTInfoDao();
        System.assertEquals(null, srtDao.getStockRTInfoByCondition(''));
        System.assertEquals(10, srtDao.getStockRTInfoByCondition('Where StockName__c=\'北方导航\'').size());
        System.assertEquals(10, srtDao.getMonthlyStockRTInfo().size());

        StockDao sDao = new StockDao();
        Stock__c stock = sDao.getStockByName('北方导航');
        System.assertEquals(null, srtDao.getTodayStockRTInfoByStockId(null));
        System.assertEquals(10, srtDao.getTodayStockRTInfoByStockId(stock.Id).size());
        System.assertEquals(null, srtDao.getTodayStockRTInfoByStockIds(null));
        System.assertEquals(null, srtDao.getTodayStockRTInfoByStockIds(new String[]{}));
        System.assertEquals(10, srtDao.getTodayStockRTInfoByStockIds(new String[]{stock.Id}).size());
    }

    @isTest
    static void testRemove(){
    	StockRTInfoDao srtDao = new StockRTInfoDao();
    	System.assertEquals(null, srtDao.remove(null));
    	System.assertEquals(null, srtDao.remove(new List<Stock_RTInfo__c>()));
    	System.assertEquals(10, srtDao.remove(srtDao.getMonthlyStockRTInfo()).size());
    }
}
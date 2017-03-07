@isTest
private class StockDailyDataDaoTest {

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
	}


    static testMethod void testAllGet() {
    	StockDao sdao = new StockDao();
    	Stock__c stock = sdao.getStockByCode('600435');
    	System.assert(true, stock!=null);
        StockDailyDataDao sddao = new StockDailyDataDao();
    	System.assertEquals(null, sddao.getDailyDataByStockId(null));
    	System.assertEquals(0, sddao.getDailyDataByStockId(stock.Id).size());
    	System.assertEquals(null, sddao.getDailyDataByStockIds(null));
    	System.assertEquals(null, sddao.getDailyDataByStockIds(new String[]{}));
    	System.assertEquals(0, sddao.getDailyDataByStockIds(new String[]{stock.Id}).size());
    }

    @isTest
    static void testSave() {
    	StockDao sdao = new StockDao();
    	Stock__c stock = sdao.getStockByCode('600435');
    	List<DailyData__c> dds = new List<DailyData__c>();

    	//插入新数据
        for(Integer i=0;i<10;i++){
        	DailyData__c ddc = new DailyData__c();

        	ddc.Stock__c = stock.Id;
        	ddc.Open_Price__c = Math.random()+15;
	        ddc.Close_Price__c = Math.random()+15;
	        ddc.High_Price__c = Math.random()+15;
	        ddc.Low_Price__c = Math.random()+15;
	        ddc.Volume__c 	= Math.random()*20000;
	        ddc.Quota__c = Math.random()*20000;
	        ddc.Current_Price__c = Math.random()+15;
	        ddc.AvgPrice__c = Math.random()+15;
	        ddc.DT__c = DateTime.now().date();

	        dds.add(ddc);
        }

        StockDailyDataDao sddao = new StockDailyDataDao();

        List<String> sl = sddao.insertDailyData(dds);
        System.assertEquals(10, sl.size());

        //获取刚插入的数据
        System.assertEquals(10, sddao.getDailyDataByStockId(stock.Id).size());
        System.assertEquals(10, sddao.getDailyDataByStockIds(new String[]{stock.Id}).size());

        //更新操作
        dds = sddao.getDailyDataByStockId(stock.Id);
        System.assert(true, dds!=null);
        for(DailyData__c dd:dds){
        	dd.AvgPrice__c = Math.random()+18;
        }
        sl = sddao.updateDailyData(dds);
        System.assertEquals(10, sl.size());

        //Error
        sl = sddao.insertDailyData(dds);
        System.assertEquals(0, sl.size());

        System.assertEquals(null, sddao.updateDailyData(null));
        System.assertEquals(null, sddao.updateDailyData(new List<DailyData__c>()));

    }
}
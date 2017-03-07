@isTest
private class CleanStockRTInfoBatchableTest {



    static testMethod void testMethod1() {
    	System.assertEquals(200, [SELECT count() FROM Stock_RTInfo__c WHERE DT__c = THIS_MONTH]);
        Test.startTest();
        CleanStockRTInfoBatchable cleanBatch = new CleanStockRTInfoBatchable();
        Id batchId = Database.executeBatch(cleanBatch,200);
        Test.stopTest();
        // System.assertEquals(200, cleanBatch.count);
        System.assertEquals(0, [SELECT count() FROM Stock_RTInfo__c WHERE DT__c = THIS_MONTH]);
    }


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

		insert slist;

		List<Stock_RTInfo__c> srtList = new List<Stock_RTInfo__c>();
		Datetime lastMonth = Datetime.now();
		// lastMonth = lastMonth.addMonths(-1);
		for(Integer i=0; i<200; i++){
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
	        src.DT__c = lastMonth;
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
}
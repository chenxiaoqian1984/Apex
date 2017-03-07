@isTest
private class StockDaoTest {

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

	@isTest
	static void testInsertDuplicateStock(){
		Test.startTest();

		//插入同名stock报错
		try{
			Stock__c stock = new Stock__c(
				Name='北方导航',
				Stock_Code__c='600437',
				isGrab__c=true,
				Stock_Exchange__c='sh',
				Stock_Market_Index__c=false);
			insert stock;
		} catch (Exception e){
			System.assert(true, e.getMessage().contains('Stock Name already exists!'));
		}

		StockDao sd = new StockDao();
		Stock__c sc = sd.getStockByName('上证指数');

		//更改为其他同名stock报错
		try{
			sc.Name = '北方导航';
			update sc;
		}catch (Exception e){
			System.assert(true, e.getMessage().contains('Stock Name already exists!'));
		}
		Test.stopTest();
	}

	@isTest
    static void testAllGet() {
        StockDao sd = new StockDao();
        Test.startTest();
        List<Stock__c> slist = sd.getAllStockList();
        System.assert(true, slist!=null);
        System.assertEquals(2, slist.size());

        Stock__c sc = slist.get(0);
        System.assert(true, sc!=null);

        System.assertEquals(null, sd.getStockListByIds(null));
        System.assertEquals(null, sd.getStockListByIds(new String[]{}));
        System.assertEquals(1, sd.getStockListByIds(new String[]{sc.Id}).size());
        System.assertEquals(null, sd.getStockById(null));
        System.assert(true, sd.getStockById(sc.Id)!=null);

        System.assertEquals(null, sd.getStockListByNames(null));
        System.assertEquals(null, sd.getStockListByNames(new String[]{}));
        System.assertEquals(2, sd.getStockListByNames(new String[]{'上证指数','北方导航'}).size());
        System.assertEquals('上证指数', sd.getStockByName('上证指数').Name);
        System.assertEquals(null, sd.getStockByName('深成指数'));

        System.assertEquals(null, sd.getStockListByCodes(null));
        System.assertEquals(null, sd.getStockListByCodes(new String[]{}));
        System.assertEquals(2, sd.getStockListByCodes(new String[]{'000001','600435'}).size());
        System.assertEquals('000001', sd.getStockByCode('000001').Stock_Code__c);
        System.assertEquals(null, sd.getStockByCode('000002'));
        
        Test.stopTest();
    }
}
public with sharing class StockFuture {

	@Future(callout=true)
	public static void grabStockRealTimeInfo(){
		StockSpider ss = new StockSpider();
		ss.doAction();
	}
    
}
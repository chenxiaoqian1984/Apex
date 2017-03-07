@isTest
private class StockSpiderTest {

	public class SinaMock implements HttpCalloutMock{
		public HttpResponse respond(HTTPRequest req){
		    String ep = req.getEndpoint();
		    system.debug(ep);
		    HttpResponse res = new HTTPResponse();
	    	// res.setHeader('Content-Type', 'application/json');
	    	res.setBody('var hq_str_sh600435="北方导航,15.150,15.210,15.310,15.550,15.110,15.300,15.310,23398935,359708507.000,59800,15.300,22200,15.290,46000,15.280,33400,15.270,78000,15.260,3310,15.310,35700,15.320,17800,15.330,27200,15.340,32600,15.350,2017-03-03,15:00:00,00";'
	    		+'\nvar hq_str_sh000001="上证指数,3219.2019,3230.0281,3218.3118,3221.1553,3206.6127,0,0,157082368,192707923011,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2017-03-03,15:01:03,00";');
		    res.setStatusCode(200);
			res.setStatus('success'); 
		    return res;
		}
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

		stock = new Stock__c(
			Name='上证指数',
			Stock_Code__c='000001',
			isGrab__c=true,
			Stock_Exchange__c='sh',
			Stock_Market_Index__c=true);
		slist.add(stock);
		insert slist;

		GrabURL__c grabUrl = new GrabURL__c();
		grabUrl.Name='Sina';
		grabUrl.GrabUrl__c='http://hq.sinajs.cn';
		insert grabUrl;
	}

    static testMethod void testMethod1() {

    	Test.startTest();
    	Test.setMock(HttpCalloutMock.class, new SinaMock());
    	StockSpider spider = new StockSpider();
    	spider.doAction();
    	List<Stock_RTInfo__c> rtls =  [
    		SELECT 
    			ID,
    			Name
    		FROM 
    			Stock_RTInfo__c
    	];
    	System.assertEquals(2, rtls.size());
    	Test.stopTest();
    }
}
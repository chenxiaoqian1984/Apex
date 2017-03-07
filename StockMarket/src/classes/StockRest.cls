/**********************************************************************
 * 
 *
 * @url: /services/apexrest/Stock/
 * @data:
 *  {
        
    }
*************************************************************************/
@RestResource(urlMapping='/Stock/*')
global with sharing class StockRest {

	global class AppOut{
		public AppOut(){
			this(true,'success');
		}
		public AppOut(Boolean status,String message){
			this.status = status;
			this.message = message;
		}
		public Boolean status{set;get;}
		public String message{set;get;}
		public List<SObject> dataList{set;get;}
		public SObject data{set;get;}
	}


	/**
	 [doPost 添加股票]
	 * @param  name     [股票名称]
	 * @param  code     [股票代码]
	 * @param  exchange [交易所代码]
	 * @param  isIndex  [是否股指]
	 * @return          [description]
	 */
    @HttpPost
    global static AppOut doPost(String name,String code,String exchange,Boolean isIndex) {
    	
    	if(String.isBlank(name) || String.isBlank(code)){
    		return new AppOut(false,'Stock name or code must have values!');
    	}
    	exchange = String.isBlank(exchange)?'sh':exchange; //默认为上海交易所
    	isIndex = isIndex==null?false:true; //默认不是股指
    	AppOut output = new AppOut(true, 'Save ['+name+'] successfully!');

    	try{
			MyStockDao myDao = new MyStockDao();
			List<Stock__c> stocks = new List<Stock__c>();

			Stock__c stock = new Stock__c();
			stock.Name = name;
			stock.Stock_Code__c = code;
			stock.Stock_Exchange__c = exchange;
			stock.isGrab__c = false; //默认不抓取
			stock.Stock_Market_Index__c = isIndex;

			stocks.add(stock);

			List<String> result = myDao.save(stocks,true);
			if(null == result){
				return new AppOut(false,'Nothing saved!');
			}else{
				output.data = stock;
			}
    	}catch(Exception e){
    		return new AppOut(false,'Exception occured:'+e.getMessage());
    	}
        return output;
    }

    /**
     [doGet 根据股票code获取股票列表，code使用,或者;隔开]
     * @return [description]
     */
    @HttpGet
    global static AppOut doGet(){
    	RestRequest req = RestContext.request;
		// RestResponse res = RestContext.response;
		String pathParameters = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
		String[]codes = pathParameters.split(',|;');
		System.debug(codes);

    	AppOut output = new AppOut();
    	MyStockDao myDao = new MyStockDao();
		output.dataList = myDao.getStockListByCodes(codes);
    	return output;
    }

    /**
     [doPut 设置股票是否可以抓取]
     * @param  code [description]
     * @return      [description]
     */
    @HttpPut
    global static AppOut doPut(String code){
    	//改变股票是否可以抓取状态
    	if(String.isBlank(code)){
    		return new AppOut(false,'Stock code must have values!');
    	}

    	try{
			MyStockDao myDao = new MyStockDao();
			List<Stock__c> stocks = new List<Stock__c>();

			Stock__c stock = myDao.getStockByCode(code);
			if(null == stock){
				return new AppOut(false,'Stock ['+code+'] not found!');
			}
			stock.isGrab__c = !stock.isGrab__c;

			stocks.add(stock);

			List<String> result = myDao.save(stocks,false);
			if(null == result){
				return new AppOut(false,'Nothing updated!');
			}else{
				AppOut output = new AppOut(true, 'Update ['+code+'] successfully!');
				output.data = stock;
				return output;
			}
    	}catch(Exception e){
    		return new AppOut(false,'Exception occured:'+e.getMessage());
    	}
    }

    /**
     [doDelete 输入code，删除股票，code可以使用,或者;隔开]
     * @return [description]
     */
    @HttpDelete
    global static AppOut doDelete(){
    	RestRequest req = RestContext.request;
		// RestResponse res = RestContext.response;
		
		String pathParameters = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
		String[]codes = pathParameters.split(',|;');
		System.debug('input is: '+codes);

    	MyStockDao myDao = new MyStockDao();
    	List<String> sts = myDao.removeByCodes(codes);
    	if(null == sts){
    		return new AppOut(false,'Nothing removed for ['+ pathParameters +']!');
    	}
    	return new AppOut(true,'Removed ['+ sts +'] successfully!');
    }
}
/**
 * 抓取股票信息类
 * 将Stock表的股票全部读出，向指定网站发出请求，
 * 获取数据插入到StockRTInfo表
 */
public without sharing class StockSpider {

    public String web {set;get;}

    public String grabUrl{set;get;}

    public StockSpider(){
        this.web = 'Sina';
        this.grabUrl = GrabURL__c.getAll().get(this.web).GrabUrl__c;
    }

    public void doAction(){
        StockDao sd = new StockDao();
        List<Stock__c> stockList = sd.getAllStockList();

        String params = '';
        for(Stock__c stk:stockList){
            if(stk.isGrab__c){
                params+= stk.Stock_Full_Name__c+',';
            }
        }

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(this.grabUrl+'/list='+params);
        request.setMethod('GET');
        HttpResponse response = http.send(request);

        if (response.getStatusCode() == 200) {
            String resString = response.getBody();
            System.debug(resString);
            saveDataToDb(resString);
        }else{
            System.debug(response.getStatusCode());
        }
    }

    /**
     [saveDataToDb 保存数据到数据库]
     * @param  resString [description]
     * @return           [description]
     */
    public List<Stock_RTInfo__c> saveDataToDb(String resString){
        String []lines = resString.split('\n');
        System.debug(lines.size());

        List<Stock_RTInfo__c> srtlist = new List<Stock_RTInfo__c>();
        for(String line:lines){
            String line_clean = line.substringBetween('"');
            System.debug(line_clean);
            String [] f = line_clean.split(',');
            Stock_RTInfo__c src = new Stock_RTInfo__c();
            src.Buy1_Price__c = Decimal.valueOf(f[11]);
            src.Buy1_Volume__c = Decimal.valueOf(f[10]);
            src.Buy2_Price__c = Decimal.valueOf(f[13]);
            src.Buy2_Volume__c = Decimal.valueOf(f[12]);
            src.Buy3_Price__c = Decimal.valueOf(f[15]);
            src.Buy3_Volume__c = Decimal.valueOf(f[14]);
            src.Buy4_Price__c = Decimal.valueOf(f[17]);
            src.Buy4_Volume__c = Decimal.valueOf(f[16]);
            src.Buy5_Price__c = Decimal.valueOf(f[19]);
            src.Buy5_Volume__c = Decimal.valueOf(f[18]);
            src.Buy_Price__c = Decimal.valueOf(f[6]);
            src.Close_Price__c = Decimal.valueOf(f[2]);
            src.Current_Price__c = Decimal.valueOf(f[3]);
            src.DT__c = Datetime.valueOf(f[30]+' '+f[31]);
            src.High_Price__c = Decimal.valueOf(f[4]);
            src.Low_Price__c = Decimal.valueOf(f[5]);
            src.Open_Price__c = Decimal.valueOf(f[1]);
            src.Quota__c = Decimal.valueOf(f[9]);
            src.Sell1_Price__c = Decimal.valueOf(f[21]);
            src.Sell1_Volume__c = Decimal.valueOf(f[20]);
            src.Sell2_Price__c = Decimal.valueOf(f[23]);
            src.Sell2_Volume__c = Decimal.valueOf(f[22]);
            src.Sell3_Price__c = Decimal.valueOf(f[25]);
            src.Sell3_Volume__c = Decimal.valueOf(f[24]);
            src.Sell4_Price__c = Decimal.valueOf(f[27]);
            src.Sell4_Volume__c = Decimal.valueOf(f[26]);
            src.Sell5_Price__c = Decimal.valueOf(f[29]);
            src.Sell5_Volume__c = Decimal.valueOf(f[28]);
            src.Sell_Price__c = Decimal.valueOf(f[7]);
            // src.Stock__c = f[0]; //交给trigger去设置
            src.StockName__c = f[0];
            src.Volume__c = Decimal.valueOf(f[8]);
            srtlist.add(src);
        }
        if(srtlist.size()>0){
            insert srtlist;
        }
        return srtlist;
    }
}
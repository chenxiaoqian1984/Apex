global class ComputeLongOrShortBatchable implements Database.Batchable<sObject>,Database.Stateful {
    
    public String query;

    global Integer count = 0;//总记录数

    global Integer longCount=0;//看多个数
    global Integer shortCount=0;//看空个数
    global Integer equalCount=0;//看平个数

    global ComputeLongOrShortBatchable() {
        this.query = 'SELECT Id,Name,Buy1_Volume__c,Buy2_Volume__c,Buy3_Volume__c,'
                    + 'Buy4_Volume__c,Buy5_Volume__c,Sell1_Volume__c,Sell2_Volume__c,'
                    + 'Sell3_Volume__c,Sell4_Volume__c,Sell5_Volume__c,LongOrShort__c,'
                    + 'Stock__r.Stock_Market_Index__c '
                    + 'From Stock_RTInfo__c WHERE DT__c = LAST_MONTH ' //TODAY
                    + 'AND Stock__r.Stock_Market_Index__c=false';
    }

    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, list<Sobject> scope) {
        StockRTInfoDao srtDao = new StockRTInfoDao();
        List<Stock_RTInfo__c> rtlist = (List<Stock_RTInfo__c>) scope;
        for(Stock_RTInfo__c srt:rtlist){

            // srt.LongOrShort__c = null;

            Double buy = srt.Buy1_Volume__c
                        +srt.Buy2_Volume__c
                        +srt.Buy3_Volume__c
                        +srt.Buy4_Volume__c
                        +srt.Buy5_Volume__c;

            Double sell = srt.Sell1_Volume__c
                        +srt.Sell2_Volume__c
                        +srt.Sell3_Volume__c
                        +srt.Sell4_Volume__c
                        +srt.Sell5_Volume__c;

            Double absValue = Math.abs(buy-sell); //多空数相减绝对值

            if(absValue/(buy+sell) <= 0.05){ //绝对值占比多空总数的5%以内为看平
                srt.LongOrShort__c = '平';
                equalCount++;
            }else{
                if(buy > sell){
                    srt.LongOrShort__c = '多';
                    longCount++;
                }else{
                    srt.LongOrShort__c = '空';
                    shortCount++;
                }
            }

        }
        List<String> updatedId = srtDao.save(rtlist, false);
        count += updatedId.size();
    }

    global void finish(Database.BatchableContext BC) {
        System.debug('Computed total '+count+' records!');
        AsyncApexJob a = [
            SELECT 
                Id, 
                Status, 
                NumberOfErrors, 
                JobItemsProcessed,
                TotalJobItems, 
                CreatedBy.Email
            FROM 
                AsyncApexJob 
            WHERE Id = :BC.getJobId()];

        //发送邮件给创建者
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {a.CreatedBy.Email};
        mail.setToAddresses(toAddresses);
        mail.setSubject('今天多空对决计算结果状态 ' + a.Status+ '，共计算：'+count +' 条记录');

        mail.setPlainTextBody(
            '今天多空对决计算任务总批量：' 
            + a.TotalJobItems 
            + '，总记录数：'+count
            +'，出错记录数：'
            + a.NumberOfErrors + ' 条；'
            +'看多记录：'+longCount
            +'，看空记录：'+shortCount
            +'，看平记录：'+equalCount+'。'
            );
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

    }
}
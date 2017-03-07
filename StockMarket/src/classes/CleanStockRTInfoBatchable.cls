/**
 * 清理当月实时数据批处理
 */
global class CleanStockRTInfoBatchable implements Database.Batchable<sObject>,Database.Stateful{
    public String query;

    global Integer count=0;

    global CleanStockRTInfoBatchable() {
        this.query = 'SELECT Id,Name From Stock_RTInfo__c WHERE DT__c = THIS_MONTH';//THIS_MONTH
    }

    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, list<Sobject> scope) {
        StockRTInfoDao srtDao = new StockRTInfoDao();
        List<String> removedIds = srtDao.remove(scope);
        System.debug('Monthly removed data id is:'+removedIds);
        count += removedIds.size();
    }

    global void finish(Database.BatchableContext BC) {
        System.debug('Removed total '+count+' records!');
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
        mail.setSubject('当前月股票实时数据清理状态 ' + a.Status+ '，共清理：'+count +' 条记录');

        mail.setPlainTextBody(
            '当前月股票实时数据清理任务总批量：' 
            + a.TotalJobItems 
            +'，出错记录数：'
            + a.NumberOfErrors + ' 条.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}
/**
 *
每月定时将实时数据清除
CleanStockRTInfoSchedular gs = new CleanStockRTInfoSchedular();
String sch1 = '0 0 18 L * ?';//每月最后一天18点整执行
system.schedule('CleanStockRTInfoSchedular', sch1, gs);
 */
global class CleanStockRTInfoSchedular implements Schedulable {
    global void execute(SchedulableContext sc) {
        /*
        StockRTInfoDao srtDao = new StockRTInfoDao();
        List<String> removedIds = srtDao.remove(srtDao.getMonthlyStockRTInfo());
        System.debug('Monthly removed data id is:'+removedIds);
        */

        CleanStockRTInfoBatchable batch = new CleanStockRTInfoBatchable();
        Database.executeBatch(batch, 200);
    }
}
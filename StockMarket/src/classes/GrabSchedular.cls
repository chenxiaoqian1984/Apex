/**
 * 
GrabSchedular gs = new GrabSchedular();
String sch1 = '0 30 9,10,11 ? * MON-FRI';
String sch2 = '0 0 13,14,15 ? * MON-FRI';
String sch3 = '0 0 10,11 ? * MON-FRI';
String sch4 = '0 30 13,14 ? * MON-FRI';
system.schedule('GrabSinaStockMorningHalf', sch1, gs);
system.schedule('GrabSinaStockAfterNoon', sch2, gs);
system.schedule('GrabSinaStockMorning', sch3, gs);
system.schedule('GrabSinaStockAfterNoonHalf', sch4, gs);
 */
global class GrabSchedular implements Schedulable {
    global void execute(SchedulableContext sc) {
        StockFuture.grabStockRealTimeInfo();
    }
}
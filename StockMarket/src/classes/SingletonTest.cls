@isTest
private class SingletonTest {

    static testMethod void testSingleton() {
        Singleton s1 = Singleton.instance();
        Singleton s2 = Singleton.instance();
        System.assertEquals(s1, s2);

        s1.count();
        s2.count();
        System.assertEquals(3, Singleton.instance().count());
    }

}
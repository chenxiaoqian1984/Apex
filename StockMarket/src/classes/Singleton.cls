public with sharing class Singleton {

    private Singleton(){}

	private static Singleton instance;

	public static Singleton instance(){
		if(null == instance){
			instance = new Singleton();
		}
		return instance;
	}

	private Integer count = 0;

	public Integer count(){
		return ++this.count;
	}
}
public abstract without sharing class BaseDao {

    //定义查询语句
    public String sosql_all {set;get;}

    public class DaoException extends Exception{}

    /**
     [queryByString 执行查询语句queryString]
     * @param  queryString [description]
     * @return             [description]
     */
    public virtual List<SObject> queryByString(String queryString){
        if(String.isBlank(queryString)){
            return null;
        }
        return Database.query(queryString);
    }

    /**
     [queryByCondition 通过条件查询SObject，条件字符串中不能带有变量]
     * @param  condition [description]
     * @return           [description]
     */
    public virtual List<SObject> queryByCondition(String condition){
        if(String.isBlank(sosql_all)){
            System.debug('Soql for sosql_all is empty!');
            return null;
        }
        if(String.isBlank(condition)){
            return null;
        }
        return Database.query(sosql_all + ' '+ condition);
    }

	/**
     [remove 删除SObjects]
     * @param  sobjs [description]
     * @return      [description]
     */
    public virtual List<String> remove(List<SObject> sobjs){
        if(null == sobjs || sobjs.isEmpty()){
            return null;
        }

        Database.DeleteResult[] drList = Database.delete(sobjs, false);

        List<String> removedIds = new List<String>();

        String message = '';

        for(Database.DeleteResult dr : drList) {
            if (dr.isSuccess()) {
                removedIds.add(dr.getId());
            }else {
                System.debug('The following error has occurred.');
                for(Database.Error err : dr.getErrors()) {
                    message += err.getStatusCode() + ': ' + err.getMessage();
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('sobjs fields that affected this error: ' + err.getFields());
                }
            }
        }

        if(String.isNotBlank(message)){
            throw new DaoException(message);
        }

        return removedIds;
    }

    /**
     [save 保存SObjects]
     * @param  sobjs     [description]
     * @param  insertOrUpdate [true:inser data,false:update data]
     * @return                [description]
     */
    public virtual List<String> save(List<SObject> sobjs, Boolean insertOrUpdate){

    	if(null == sobjs || sobjs.isEmpty()){
    		return null;
    	}

    	Database.SaveResult[] upList = insertOrUpdate?Database.insert(sobjs, false):Database.update(sobjs, false);

    	List<String> savedIds = new List<String>();

        String message = '';

    	for (Database.SaveResult sr : upList) {
			if (sr.isSuccess()) {
				savedIds.add(sr.getId());
			} else {
				System.debug('The following error has occurred.');
				for(Database.Error err : sr.getErrors()) {
                    message += err.getStatusCode() + ': ' + err.getMessage();
					System.debug(err.getStatusCode() + ': ' + err.getMessage());
					System.debug('sobjs fields that affected this error: ' + err.getFields());
				}
			}
		}

        if(String.isNotBlank(message)){
            throw new DaoException(message);
        }
		return savedIds;

    }
    
}
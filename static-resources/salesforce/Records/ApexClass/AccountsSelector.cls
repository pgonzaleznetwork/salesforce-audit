public class AccountsSelector  extends fflib_SObjectSelector
{
    public AccountsSelector()
    {
        super();
    }

    public AccountsSelector(Boolean includeFieldSetFields, Boolean enforceCRUD, Boolean enforceFLS, Boolean sortSelectFields)
    {
        super(includeFieldSetFields, enforceCRUD, enforceFLS, sortSelectFields);
    }
    
    public List<Schema.SObjectField> getSObjectFieldList()
    {
        return new List<Schema.SObjectField> {
            Account.Name,
            Account.Description,
            Account.AnnualRevenue
        };
    }
    
    public Schema.SObjectType getSObjectType()
    {
        return Account.sObjectType;
    }
    
    public override String getOrderBy()
    {
        return 'Name DESC, AnnualRevenue ASC NULLS LAST';
    }

    public List<Account> selectById(Set<ID> idSet) {
        return (List<Account>) selectSObjectsById(idSet);
    }
}
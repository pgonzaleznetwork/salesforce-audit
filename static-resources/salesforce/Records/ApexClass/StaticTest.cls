public class StaticTest {
    
    public static Boolean staticBoolean = getValue();
    
    public static Boolean getValue(){
        System.debug('executing the initialization code');
        return true;
    }

}
public class TemplateClass {
    
    public static void hello(){
        List<EmailTemplate> templates = [SELECT Id FROM EmailTemplate];
    }

}
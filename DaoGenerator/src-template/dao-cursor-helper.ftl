 

<#--
############################## readContentValue ############################## 
-->
    public ContentValues readContentValues(Cursor cursor, int offset) {
        ContentValues values = new ContentValues();
<#list entity.properties as property> 
        values.put(Properties.${property.propertyName?cap_first}.columnName,cursor.isNull(offset + ${property_index})? null: cursor.get${toCursorType[property.propertyType]}(offset + ${property_index})  );
</#list>  
        return values;
    }

    public ContentValues readContentValues(${entity.className} entity) {
        ContentValues values = new ContentValues();
<#list entity.properties as property> 
        values.put(Properties.${property.propertyName?cap_first}.columnName, <#if
   property.propertyType == "Date">entity.get${property.propertyName?cap_first}()==null? null: entity.get${property.propertyName?cap_first}().getTime() <#elseif 
   property.notNull>entity.get${property.propertyName?cap_first}() <#else
   > entity.get${property.propertyName?cap_first}() </#if
   >);
</#list>  
        return values;
    }    

     public ${entity.className} readEntity(ContentValues values) {
        ${entity.className} entity = new ${entity.className}();
<#list entity.properties as property>   
        entity.set${property.propertyName?cap_first}(<#if
   property.propertyType == "Date">values.getAs${toContentValueType[property.propertyType]}(Properties.${property.propertyName?cap_first}.columnName)==null? null: new ${property.javaType}(values.getAs${toContentValueType[property.propertyType]}(Properties.${property.propertyName?cap_first}.columnName)) <#else
   >values.getAs${toContentValueType[property.propertyType]}(Properties.${property.propertyName?cap_first}.columnName)</#if
   >); 
</#list>        
        //   attachEntity(entity)
        return entity;
     }
 <#--
############################## cursorHelper ############################## 
--> 

    public ${entity.className}CursorHelper getCursorHelper(Cursor cursor){
        ${entity.className}CursorHelper helper = new ${entity.className}CursorHelper();
        if (cursor!=null) {
        	helper.initWrapper(cursor);
        }
        return helper;
    }
    
    public static class ${entity.className}CursorHelper {
        
       public boolean isNotInit = true;
        
<#list entity.properties as property>        
        public int ${property.propertyName}Idx = -1;
</#list>          

        public ${entity.className}CursorHelper initWrapper(Cursor cursor) { 
<#list entity.properties as property>        
            ${property.propertyName}Idx = cursor.getColumnIndex(Properties.${property.propertyName?cap_first}.columnName);
</#list>     
            isNotInit = false;
            return this;
        }
    <#-- ### Read as map ### -->    
    public ContentValues readContentValues(Cursor cursor) {
        if (isNotInit) {
           initWrapper(cursor);
        }
        ContentValues values = new ContentValues(); 
<#list entity.properties as property> 
        if (${property.propertyName}Idx > -1) {
           values.put(Properties.${property.propertyName?cap_first}.columnName,cursor.isNull(${property.propertyName}Idx)? null: cursor.get${toCursorType[property.propertyType]}(${property.propertyName}Idx)<#if  property.propertyType == "Boolean"> !=0</#if>  );
        }
</#list>  
        return values;
    }  
    
     public android.os.Bundle readBundleValues(Cursor cursor) {
        if (isNotInit) {
           initWrapper(cursor);
        }
        android.os.Bundle values = new android.os.Bundle(); 
<#list entity.properties as property>      
        if (${property.propertyName}Idx > -1) {
           values.put${property.propertyType}(Properties.${property.propertyName?cap_first}.columnName,cursor.isNull(${property.propertyName}Idx)? null: cursor.get${toCursorType[property.propertyType]}(${property.propertyName}Idx)<#if  property.propertyType == "Boolean"> !=0</#if>  );
        }   
</#list>  
        return values;
     }        

    <#-- ### UI Field Writer ### -->    
    private ${entity.className}CursorHelper setTextWithIdx(android.widget.TextView view, Cursor cursor, int idx) {
        view.setText(cursor.getString(idx));
        return this;
    }
         
    <#-- ### Property Accessors ### -->            
<#list entity.properties as property>    
        public ${property.javaType} get${property.propertyName?cap_first}(Cursor cursor) {   
            ${property.javaType} cursorVal = cursor.get${toCursorType[property.propertyType]}(${property.propertyName}Idx)<#if  property.propertyType == "Boolean"> !=0</#if>;
    //${property.propertyType} 
         <#if property.propertyType == "Date"
>            return new ${property.javaType}(cursorVal);<#else
>            return cursorVal;</#if>   
        }          

  <#if  property.propertyType == "Date">     
        public ${toCursorType[property.propertyType]} get${property.propertyName?cap_first}Db(Cursor cursor) {   
            return cursor.get${toCursorType[property.propertyType]}(${property.propertyName}Idx);
        }          
  </#if>      
  
   <#-- ### UI Field Writer ###  --> 
  <#if  property.propertyType == "String">     
        public ${entity.className}CursorHelper setText${property.propertyName?cap_first}(android.widget.TextView view, Cursor cursor) {
            return setTextWithIdx(view, cursor, ${property.propertyName}Idx);
        }       
  </#if>       
     
</#list>     
         
    }
        

    

 

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

    public ${entity.className}CursorHelper get${entity.className}CursorHelper(Cursor cursor){
        return new ${entity.className}CursorHelper().initWrapper(cursor);
    }
    
    public static class ${entity.className}CursorHelper {
        
        boolean isNotInit = true;
        
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

         
        
<#list entity.properties as property>    
        public ${property.javaType} get${property.propertyName?cap_first}(Cursor cursor) {   
            ${toCursorType[property.propertyType]} cursorVal = cursor.get${toCursorType[property.propertyType]}(${property.propertyName}Idx);
    //${property.propertyType} 
         <#if  property.propertyType == "Boolean"
>              return cursorVal.intValue()  == 1 ;<#elseif
           property.propertyType == "Date"
>            return new ${property.javaType}(cursorVal);<#else
>            return cursorVal;</#if>   
        }          

  <#if  property.propertyType == "Date">     
        public ${toCursorType[property.propertyType]} get${property.propertyName?cap_first}Db(Cursor cursor) {   
            return cursor.get${toCursorType[property.propertyType]}(${property.propertyName}Idx);
        }          
  </#if>       
</#list>     
         
    }
        

    

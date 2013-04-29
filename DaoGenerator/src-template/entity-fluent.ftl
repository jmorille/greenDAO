 
 <#--
##########################################
########## Fluent Api ######
##########################################
-->
 
<#list entity.properties as property>
  
   public ${entity.className} with${property.propertyName?cap_first}(${property.javaType} ${property.propertyName}) {
        set${property.propertyName?cap_first}( ${property.propertyName});
        return this;
    }
</#list>


<#--
##########################################
########## To-One Relations ##############
##########################################
-->
<#list entity.toOneRelations as toOne> 
     public ${entity.className} with${toOne.name?cap_first}(${toOne.targetEntity.className} ${toOne.name}) { 
        set${toOne.name?cap_first}(${toOne.name});
        return this;
     }
</#list>
 
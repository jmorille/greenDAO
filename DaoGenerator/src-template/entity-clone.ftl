 
 <#--
##########################################
########## Constructor clone        ######
##########################################
-->
 
     public ${entity.className}(${entity.className} other) {
<#list entity.properties as property>
        this.${property.propertyName} = other.${property.propertyName};
</#list>
    }
    
    
 
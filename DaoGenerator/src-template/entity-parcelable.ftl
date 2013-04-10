<#assign toParcelType = {"Boolean":"Byte", "Byte":"Short", "Short":"Int", "Int":"Int", "Long":"Long", "Float":"Float", "Double":"Double", "String":"String", "ByteArray":"ByteArray" }/>
 
 <#--
##########################################
########## Parcelable operations ######
##########################################
-->
<#if entity.parceable>

//  @Override
  public int describeContents() {
    return 0;
  }
    
//  @Override
  public void writeToParcel(Parcel dest, int flags) {
<#list entity.properties as property>
   <#if toParcelType[property.propertyType]??>
      <#if !property.notNull>if (${property.propertyName}!=null) {
        dest.writeByte((byte)1);
      </#if><#if  property.propertyType == "Boolean">
        dest.write${toParcelType[property.propertyType]}((byte)(${property.propertyName}  ? 1 : 0)); <#else
      > dest.write${toParcelType[property.propertyType]}(${property.propertyName});</#if> 
      <#if !property.notNull>} else { dest.writeByte((byte)0); }</#if> 
   <#elseif  property.propertyType == "Date">
      if (${property.propertyName} != null) {
        dest.writeByte((byte)(1));
        dest.writeLong(${property.propertyName}.getTime());
      } else {
         dest.writeByte((byte)(0));
      } <#else>
        dest.writeParcelable( ${property.propertyName}, flags);
      </#if>  
   </#list>
  }
 
  public static final Parcelable.Creator<${entity.className}> CREATOR = new Parcelable.Creator<${entity.className}>() {
        public ${entity.className} createFromParcel(Parcel in) {
            ${entity.className} entity =  new ${entity.className}();
 <#list entity.properties as property> 
    <#if toParcelType[property.propertyType]?? && property.notNull>
            entity.${property.propertyName} = in.read${toParcelType[property.propertyType]}() <#if  property.propertyType == "Boolean"> == 1 </#if>;<#elseif 
    toParcelType[property.propertyType]??>
            if (in.readByte() == 1) {
                 entity.${property.propertyName} = in.read${toParcelType[property.propertyType]}() <#if  property.propertyType == "Boolean"> == 1 </#if>;
            } else {
                 entity.${property.propertyName} = null;
            }  <#elseif 
    property.propertyType == "Date">
            if (in.readByte() == 1) {
              entity.${property.propertyName} = new ${property.javaType}(in.readLong());
            } else {
              entity.${property.propertyName} = null;
            } <#else>
            ${property.javaType}.CREATOR.createFromParcel(in);
    </#if> 
 
</#list>
            return entity;
        }

        public ${entity.className}[] newArray(int size) {
            return new ${entity.className}[size];
        }
    };
    
</#if>     

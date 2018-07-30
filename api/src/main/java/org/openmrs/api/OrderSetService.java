/**
 * This Source Code Form is subject to the terms of the Mozilla Public License,
 * v. 2.0. If a copy of the MPL was not distributed with this file, You can
 * obtain one at http://mozilla.org/MPL/2.0/. OpenMRS is also distributed under
 * the terms of the Healthcare Disclaimer located at http://openmrs.org/license.
 *
 * Copyright (C) OpenMRS Inc. OpenMRS is a registered trademark and the OpenMRS
 * graphic logo is a trademark of OpenMRS Inc.
 */
package org.openmrs.api;

import java.util.List;

import org.openmrs.OrderSet;
import org.openmrs.OrderSetAttribute;
import org.openmrs.OrderSetAttributeType;
import org.openmrs.OrderSetMember;
import org.openmrs.annotation.Authorized;
import org.openmrs.api.db.OrderSetDAO;
import org.openmrs.util.PrivilegeConstants;

/**
 * Contains methods pertaining to creating/deleting/voiding Order Sets.
 * 
 * @since 1.12
 */
public interface OrderSetService extends OpenmrsService {
	
	/**
	 * Setter for the OrderSet data access object. The dao is used for saving and getting orders
	 * to/from the database
	 *
	 * @param dao The data access object to use
	 */
	void setOrderSetDAO(OrderSetDAO dao);
	
	/**
	 * Save or update the given <code>orderSet</code> in the database. If the OrderSet is retired
	 * it will set retired by and retired date.
	 * If OrderSetMembers are retired, it will set retired by and retired date.
	 *
	 * @param orderSet the OrderSet to save
	 * @return the OrderSet that was saved
	 * @throws APIException
	 */
	@Authorized( { PrivilegeConstants.MANAGE_ORDER_SETS })
	OrderSet saveOrderSet(OrderSet orderSet) throws APIException;
	
	/**
	 * Gets all OrderSets that match the specified parameters excluding discontinuation orderSets.
	 *
	 * @param includeRetired Specifies whether retired orders should be included or not
	 * @return list of OrderSets matching the parameters
	 * @throws APIException
	 */
	@Authorized(PrivilegeConstants.GET_ORDER_SETS)
	List<OrderSet> getOrderSets(boolean includeRetired) throws APIException;
	
	/**
	 * Gets a specific OrderSet with the matched orderSet Id.
	 *
	 * @param orderSetId Specifies a saved orderSet id.
	 * @return OrderSet
	 * @throws APIException
	 */
	@Authorized(PrivilegeConstants.GET_ORDER_SETS)
	OrderSet getOrderSet(Integer orderSetId) throws APIException;
	
	/**
	 * Gets a specific OrderSet with the matched orderSet uuid.
	 *
	 * @param orderSetUuid Specifies a saved orderSet uuid.
	 * @return an orderSet
	 * @throws APIException
	 */
	@Authorized(PrivilegeConstants.GET_ORDER_SETS)
	OrderSet getOrderSetByUuid(String orderSetUuid) throws APIException;
	
	/**
	 * Retires and OrderSet, with matched OrderSet
	 * 
	 * @param orderSet Specifies the OrderSet to be retired
	 * @param retireReason Specifies the reason why the OrderSet has to be retired
	 * @return an orderSet
	 * @throws APIException
	 */
	@Authorized( { PrivilegeConstants.MANAGE_ORDER_SETS })
	OrderSet retireOrderSet(OrderSet orderSet, String retireReason) throws APIException;
	
	/**
	 * UnRetires and OrderSet, with matched OrderSet
	 * 
	 * @param orderSet Specifies the OrderSet to be retired
	 * @return an orderSet
	 * @throws APIException
	 */
	@Authorized( { PrivilegeConstants.MANAGE_ORDER_SETS })
	OrderSet unretireOrderSet(OrderSet orderSet) throws APIException;
	

	/**
	 * Get OrderSetMember by uuid
	 *
	 * @param uuid
	 * @return
	 * @should find object given valid uuid
	 * @should return null if no object found with given uuid
	 */
	@Authorized(PrivilegeConstants.GET_ORDER_SETS)
	OrderSetMember getOrderSetMemberByUuid(String uuid);
	
	/**
	 * @return all {@link OrderSetAttributeType}s
	 * @should return all orderSet attribute types including retired ones
	 */
	@Authorized(PrivilegeConstants.GET_ORDER_SET_ATTRIBUTE_TYPES)
	List<OrderSetAttributeType> getAllOrderSetAttributeTypes();

	/**
	 * @param id
	 * @return the {@link OrderSetAttributeType} with the given internal id
	 * @should return the orderSet attribute type with the given id
	 * @should return null if no orderSet attribute type exists with the given id
	 */
	@Authorized(PrivilegeConstants.GET_ORDER_SET_ATTRIBUTE_TYPES)
	OrderSetAttributeType getOrderSetAttributeType(Integer id);
	
	/**
	 * @param uuid
	 * @return the {@link OrderSetAttributeType} with the given uuid
	 * @should return the orderSet attribute type with the given uuid
	 * @should return null if no orderSet attribute type exists with the given uuid
	 */
	@Authorized(PrivilegeConstants.GET_ORDER_SET_ATTRIBUTE_TYPES)
	OrderSetAttributeType getOrderSetAttributeTypeByUuid(String uuid);
	
	/**
	 * Creates or updates the given orderSet attribute type in the database
	 * 
	 * @param orderSetAttributeType
	 * @return the OrderSetAttributeType created/saved
	 * @should create a new orderSet attribute type
	 * @should edit an existing orderSet attribute type
	 */
	@Authorized(PrivilegeConstants.MANAGE_ORDER_SET_ATTRIBUTE_TYPES)
	OrderSetAttributeType saveOrderSetAttributeType(OrderSetAttributeType orderSetAttributeType);
	
	/**
	 * Retires the given orderSet attribute type in the database
	 * 
	 * @param orderSetAttributeType
	 * @return the orderSetAttribute retired
	 * @should retire a orderSet attribute type
	 */
	@Authorized(PrivilegeConstants.MANAGE_ORDER_SET_ATTRIBUTE_TYPES)
	OrderSetAttributeType retireOrderSetAttributeType(OrderSetAttributeType orderSetAttributeType, String reason);
	
	/**
	 * Restores a orderSet attribute type that was previous retired in the database
	 * 
	 * @param orderSetAttributeType
	 * @return the OrderSetAttributeType unretired
	 * @should unretire a retired orderSet attribute type
	 */
	@Authorized(PrivilegeConstants.MANAGE_ORDER_SET_ATTRIBUTE_TYPES)
	OrderSetAttributeType unretireOrderSetAttributeType(OrderSetAttributeType orderSetAttributeType);
	
	/**
	 * Completely removes a orderSet attribute type from the database
	 * 
	 * @param orderSetAttributeType
	 * @should completely remove a orderSet attribute type
	 */
	@Authorized(PrivilegeConstants.PURGE_ORDER_SET_ATTRIBUTE_TYPES)
	void purgeOrderSetAttributeType(OrderSetAttributeType orderSetAttributeType);

	/**
	 * Retrieves a OrderSetAttributeType object based on the name provided
	 *
	 * @param orderSetAttributeTypeName
	 * @return the {@link OrderSetAttributeType} with the specified name
	 * @should return the orderSet attribute type with the specified name
	 * @should return null if no orderSet attribute type exists with the specified name
	 */
	@Authorized(PrivilegeConstants.GET_ORDER_SET_ATTRIBUTE_TYPES)
	OrderSetAttributeType getOrderSetAttributeTypeByName(String orderSetAttributeTypeName);
	
	/**
	 * @param uuid
	 * @return the {@link OrderSetAttribute} with the given uuid
	 * @since 1.9
	 * @should get the order set attribute with the given uuid
	 * @should return null if no order set attribute has the given uuid
	 */
	@Authorized(PrivilegeConstants.GET_ORDER_SETS)
	OrderSetAttribute getOrderSetAttributeByUuid(String uuid);

}

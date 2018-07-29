/**
 * This Source Code Form is subject to the terms of the Mozilla Public License,
 * v. 2.0. If a copy of the MPL was not distributed with this file, You can
 * obtain one at http://mozilla.org/MPL/2.0/. OpenMRS is also distributed under
 * the terms of the Healthcare Disclaimer located at http://openmrs.org/license.
 *
 * Copyright (C) OpenMRS Inc. OpenMRS is a registered trademark and the OpenMRS
 * graphic logo is a trademark of OpenMRS Inc.
 */
package org.openmrs;

import java.io.*;
import java.util.Date;
import java.util.Locale;

import org.openmrs.api.APIException;
import org.springframework.validation.Errors;
import org.springframework.validation.ValidationUtils;

/**
 * @since 2.2
 */
public class ChemoAdminDosingInstructions implements DosingInstructions {

  private Integer dosingAdjustmentPercentage;
  private String dosingDilutionInstructions;
  private String dosingTimingInstructions;

	/**
	 * @see DosingInstructions#getDosingInstructions(DrugOrder)
	 */
	@Override
	public String getDosingInstructionsAsString(Locale locale) {

    System.out.printf("ENTER ChemoAdminDosingInstructions::getDosingInstructionsAsString(): %s\n",locale.toString());

    // canonical format of encoded chemo admin dosing instruction string:
    // "{"adjustment": "<int>", "dilution": "<string>", "timing": "<string>"}

    // encode chemo admin instructions into seralized JSON format for persisting as a string
    StringBuilder encodedInstructions = new StringBuilder();
    encodedInstructions.append("{\"adjustment\": \"");
    encodedInstructions.append(Integer.toString(this.getDosingAdjustmentPercentage()));
    encodedInstructions.append("\", \"dilution\": \"");
    encodedInstructions.append(this.getDosingDilutionInstructions());
    encodedInstructions.append("\", \"timing\": \"");
    encodedInstructions.append(this.getDosingTimingInstructions());
    encodedInstructions.append("\"}");

    System.out.printf("EXIT ChemoAdminDosingInstructions::setDosingInstructions(): %s\n",encodedInstructions.toString());

    // return seralized JSON string containing chemo admin dosing instructions
		return encodedInstructions.toString();
	}

	/**
	 * @see DosingInstructions#setDosingInstructions(DrugOrder)
	 */
	@Override
	public void setDosingInstructions(DrugOrder order) {

    //System.err.printf("ENTER ChemoAdminDosingInstructions::setDosingInstructions(): %s\n",order.toString());

    // set dosing instruction type to "chemo admin" type
		order.setDosingType(this.getClass());

    // decode chemo admin dosing instruction stored

    // canonical format of encoded chemo admin dosing instruction string:
    // "{"adjustment": "<int>", "dilution": "<string>", "timing": "<string>"}

    //order.setDosingInstructions("I added this in ChemoAdminDosingInstructions::setDosingInstructions() method!!");

    //System.err.printf("EXIT ChemoAdminDosingInstructions::setDosingInstructions(): %s\n",order.toString());

    // store dosing instructions seralized JSON string into DrugOrder object
		//order.setDosingInstructions(getDosingInstructionsAsString(Locale.getDefault()));
	}

	/**
	 * @see DosingInstructions#getDosingInstructions(DrugOrder)
	 */
	@Override
	public DosingInstructions getDosingInstructions(DrugOrder order) throws APIException {
		if (!order.getDosingType().equals(this.getClass())) {
			throw new APIException("DrugOrder.error.dosingTypeIsMismatched", new Object[] { this.getClass(),
			        order.getDosingType() });
		}
		ChemoAdminDosingInstructions chemoAdminDosingInstructions = new ChemoAdminDosingInstructions();
    chemoAdminDosingInstructions.setDosingAdjustmentPercentage(this.getDosingAdjustmentPercentage());
		chemoAdminDosingInstructions.setDosingDilutionInstructions(this.getDosingDilutionInstructions());
    chemoAdminDosingInstructions.setDosingTimingInstructions(this.getDosingTimingInstructions());
		return chemoAdminDosingInstructions;
	}

	@Override
	public void validate(DrugOrder order, Errors errors) {
		ValidationUtils.rejectIfEmpty(errors, "dosingInstructions",
		    "DrugOrder.error.dosingInstructionsIsNullForDosingTypeAdjustment");
	}

	@Override
	public Date getAutoExpireDate(DrugOrder order) {
		return null;
	}

  public Integer getDosingAdjustmentPercentage() {
		return dosingAdjustmentPercentage;
	}

	public void setDosingAdjustmentPercentage(Integer dosingAdjustmentPercentage) {
		this.dosingAdjustmentPercentage = dosingAdjustmentPercentage;
	}

	public String getDosingDilutionInstructions() {
		return dosingDilutionInstructions;
	}

	public void setDosingDilutionInstructions(String dosingDilutionInstructions) {
		this.dosingDilutionInstructions = dosingDilutionInstructions;
	}

  public String getDosingTimingInstructions() {
		return dosingTimingInstructions;
	}

	public void setDosingTimingInstructions(String dosingTimingInstructions) {
		this.dosingTimingInstructions = dosingTimingInstructions;
	}
}

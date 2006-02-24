<%@ include file="/WEB-INF/template/include.jsp" %>
<%@ page import="org.openmrs.PatientName" %>
<%@ page import="org.openmrs.PatientIdentifier" %>
<%@ page import="org.openmrs.PatientAddress" %>

<openmrs:require privilege="Edit Patients" otherwise="/login.htm" redirect="/admin/patients/patient.form"/>

<%@ include file="/WEB-INF/template/header.jsp" %>
<%@ include file="localHeader.jsp" %>

<script src="<%= request.getContextPath() %>/scripts/validation.js"></script>

<script>
	// Saves the last tab clicked on (aka "current" or "selected" tab)
	var lastTab = new Array();
	lastTab["identifier"] = null;
	lastTab["name"]		  = null;
	lastTab["address"]	  = null;
	
	// Number of objects stored.  Needed for 'add new' purposes.
	// starts at -1 due to the extra 'blank' data div in the *Boxes dib
	var numObjs = new Array();
	numObjs["identifier"]	= -1;
	numObjs["name"]			= -1;
	numObjs["address"]		= -1;
	
	function initializeChildren(obj, type) {
		if (obj.hasChildNodes()) {
			var child = obj.firstChild;
			while (child != null) {
				if (child.nodeName == "DIV") {
					child.style.display = "none";
					numObjs[type] = numObjs[type] + 1;
				}
				child = child.nextSibling;
			}
		}
	}
	
	function selectTab(tab, type) {
		if (tab != null && tab.id != null) {
			var data = document.getElementById(tab.id + "Data");
			if (data != null) {
				tab.className = "selected";                             //set the tab as selected
				data.style.display = "";                                //show the data box
				if (lastTab[type] != null && lastTab[type] != tab) {    //if there was a last tab
					lastTab[type].className = "";                       //set the last tab as unselected
					var lastData = document.getElementById(lastTab[type].id + "Data");
					if (lastData != null) 
						lastData.style.display = "none";                //hide last data tab
				}
				lastTab[type] = tab;             //new tab is now the last tab
				tab.blur();                      //get rid of the ugly dotted border the browser creates.
			}
		}
		return false;
	}
	
	function addNew(type) {
		var newData = document.getElementById(type + "Data");
		if (newData != null) {
			var tabToClone = document.getElementById(type + "Tab");
			var tabClone = tabToClone.cloneNode(true);
			tabClone.id = type + numObjs[type];
			tabClone.style.display = "";
			var parent = tabToClone.parentNode;
			parent.insertBefore(tabClone, tabToClone);

			var dataClone = newData.cloneNode(true);
			dataClone.id = type + numObjs[type] + "Data";
			parent = newData.parentNode;
			parent.insertBefore(dataClone, newData);

			numObjs[type] = numObjs[type] + 1;
		}

		return selectTab(tabClone, type);
	}
	
	function removeTab(obj, type) {
		var data = obj.parentNode;
		var tabId = data.id.substring(0, data.id.lastIndexOf("Data"));
		var tab = document.getElementById(tabId);
		var tabToSelect = null;			
		
		if (data != null && tab != null) {
			var tabparent = tab.parentNode;

			var sibling = tab.nextSibling;
			while (tabToSelect == null && sibling != tabparent.lastChild) {
				if (sibling.id == null || sibling.className == "addNew" || sibling.style.display == "none")
					sibling = sibling.nextSibling;
				else
					tabToSelect = sibling;
			}
			if (tabToSelect == null || tabToSelect == tabparent.lastChild) {
				sibling = tab.previousSibling;
				while (tabToSelect == null && sibling != tabparent.firstChild) {
					if (sibling.id == null || sibling.className == "addNew")
						sibling = sibling.previousSibling;
					else
						tabToSelect = sibling;
				}
			}
			
			if (tabToSelect != null && tabToSelect.id != null) {
				//only remove this node if it is not the last
				tabparent.removeChild(tab);
				var dataparent = data.parentNode;
				dataparent.removeChild(data);
			}
			
		}
		
		return selectTab(tabToSelect, type);
	}
	
	function modifyTab(obj, value, child) {
		var parent = obj.parentNode;
		while (parent.nodeName != "DIV") {
			parent = parent.parentNode;
		}
		var tabId = parent.id.substring(0, parent.id.lastIndexOf("Data"));  //strip 'Data' from div id
		var tab = document.getElementById(tabId);
		tab.childNodes[child].innerHTML = value;
	}
	
	function voidedBoxClick(chk) {
		var parent = chk.parentNode;
		while (parent.id.indexOf("Data") == -1)
			parent = parent.parentNode;
		var tabId = parent.id.substring(0, parent.id.lastIndexOf("Data"));
		var tab = document.getElementById(tabId);
		if (chk.checked == true)
			tab.style["text-decoration"] = "";	//TODO find previous text-decoration ?
		else
			tab.style["text-decoration"] = "line-through";
	}
	
	function removeBlankData() {
		var obj = document.getElementById("identifierData");
		if (obj != null)
			obj.parentNode.removeChild(obj);
		obj = document.getElementById("nameData");
		if (obj != null)
			obj.parentNode.removeChild(obj);
		obj = document.getElementById("addressData");
		if (obj != null)
			obj.parentNode.removeChild(obj);
	}
	
</script>

<style>
	.tabBar {
		float: left;
		font-size: 11px;
		width: 150px;
	}
		.tabBar a {
			display: block;
			border-width: 2px;
			border-style: none solid none none;
			border-color: navy;
			background-color: WhiteSmoke;
			text-decoration: none;
			padding: 4px;
			}
			.tabBar a:hover {
				text-decoration: underline;
			}
		.tabBar .selected {
			border-width: 2px;
			border-style: solid none solid solid;
			border-color: navy;
		}
	.tabBoxes {
		margin-left: 148px;
		border: 2px solid navy;
		padding: 3px;
		min-height: 150px;
	}
	#pInformationBox .tabBoxes {
		margin-left: 1px;
	}
	.addNew, .removeTab {
		font-size: 10px;
		float: right;
		margin: 3px;
		cursor: pointer;
	}
	
</style>

<h2><spring:message code="Patient.title"/></h2>

<spring:hasBindErrors name="patient">
	<spring:message code="fix.error"/>
	<div class="error">
		<c:forEach items="${errors.allErrors}" var="error">
			<spring:message code="${error.code}" text="${error.code}"/><br/><!-- ${error} -->
		</c:forEach>
	</div>
</spring:hasBindErrors>

<form method="post" onSubmit="removeBlankData()">

	<h3><spring:message code="Patient.identifiers"/></h3>
		<spring:hasBindErrors name="patient.identifiers">
			<span class="error">${error.errorMessage}</span><br/>
		</spring:hasBindErrors>
		<div id="pIds">
			<div class="tabBar" id="pIdTabBar">
				<c:forEach var="identifier" items="${patient.identifiers}" varStatus="status">
					<a href="javascript:return false;" onClick="return selectTab(this, 'identifier');" id="identifier${status.index}" <c:if test="${identifier.voided}">class='voided'</c:if>><span>${identifier.identifierType.name}</span>&nbsp;</a>
				</c:forEach>
				<a href="javascript:return false;" onClick="return selectTab(this, 'identifier');" id="identifierTab" style="display: none"><span></span>&nbsp;</a>
				<input type="button" onClick="return addNew('identifier');" class="addNew" id="identifier" value="Add New Identifier"/>
			</div>
			<div class="tabBoxes" id="identifierDataBoxes">
				<c:forEach var="identifier" items="${patient.identifiers}" varStatus="status">
					<spring:nestedPath path="patient.identifiers[${status.index}]">
						<div id="identifier${status.index}Data" class="tabBox">
							<%@ include file="include/patientIdentifier.jsp" %>
							<!-- <input type="button" onClick="return removeTab(this, 'identifier');" class="removeTab" value="Remove this identifier"/><br/> --> <br/>
						</div>
					</spring:nestedPath>
				</c:forEach>
				<div id="identifierData" class="tabBox">
					<spring:nestedPath path="emptyIdentifier">
						<%@ include file="include/patientIdentifier.jsp" %>
						<!-- <input type="button" onClick="return removeTab(this, 'identifier');" class="removeTab" value="Remove this identifier"/><br/> --> <br/>
					</spring:nestedPath>
				</div>
			</div>
		</div>
	
	<br style="clear: both" />
	
	<h3><spring:message code="Patient.names"/></h3>
		<spring:hasBindErrors name="patient.names">
			<span class="error">${error.errorMessage}</span><br/>
		</spring:hasBindErrors>
		<div id="pNames">
			<div class="tabBar" id="pNameTabBar">
				<c:forEach var="name" items="${patient.names}" varStatus="status">
					<a href="javascript:return false;" onClick="return selectTab(this, 'name');" id="name${status.index}" <c:if test="${name.voided}">class='voided'</c:if>><span>${name.givenName}</span>&nbsp;<span>${name.familyName}</span></a>
				</c:forEach>
				<a href="javascript:return false;" onClick="return selectTab(this, 'name');" id="nameTab" style="display: none"><span></span>&nbsp;<span></span></a>
				<input type="button" onClick="return addNew('name');" class="addNew" id="name" value="Add New Name"/>
			</div>
			<div class="tabBoxes" id="nameDataBoxes">
				<c:forEach var="name" items="${patient.names}" varStatus="status">
					<spring:nestedPath path="patient.names[${status.index}]">
						<div id="name${status.index}Data" class="tabBox">
							<%@ include file="include/patientName.jsp" %>
							<!-- <input type="button" onClick="return removeTab(this, 'name');" class="removeTab" value="Remove this name"/><br/> --> <br/>
						</div>
					</spring:nestedPath>
				</c:forEach>
				<div id="nameData" class="tabBox">
					<spring:nestedPath path="emptyName">
						<%@ include file="include/patientName.jsp" %>
						<!-- <input type="button" onClick="return removeTab(this, 'name');" class="removeTab" value="Remove this name"/><br/> --> <br/>
					</spring:nestedPath>
				</div>
			</div>
		</div>
	
	<br style="clear: both" />
	
	<h3><spring:message code="Patient.addresses"/></h3>
		<spring:hasBindErrors name="patient.addresses">
			<span class="error">${error.errorMessage}</span><br/>
		</spring:hasBindErrors>
		<div id="pAddresses">
			<div class="tabBar" id="pAddressesTabBar">
				<c:forEach var="address" items="${patient.addresses}" varStatus="status">
					<a href="javascript:return false;" onClick="return selectTab(this, 'address');" id="address${status.index}" <c:if test="${address.voided}">class='voided'</c:if>><span>${address.cityVillage}</span>&nbsp;</a>
				</c:forEach>
				<a href="javascript:return false;" onClick="return selectTab(this, 'address');" id="addressTab" style="display: none"><span></span>&nbsp;</a>
				<input type="button" onClick="return addNew('address');" class="addNew" id="address" value="Add New Address"/>			
			</div>
			<div class="tabBoxes" id="addressDataBoxes">
				<c:forEach var="address" items="${patient.addresses}" varStatus="status">
					<spring:nestedPath path="patient.addresses[${status.index}]">
						<div id="address${status.index}Data" class="tabBox">
							<%@ include file="include/patientAddress.jsp" %>
							<!-- <input type="button" onClick="return removeTab(this, 'name');" class="removeTab" value="Remove this address"/><br/> --> <br/>
						</div>
					</spring:nestedPath>
				</c:forEach>
				<div id="addressData" class="tabBox">
					<spring:nestedPath path="emptyAddress">
						<%@ include file="include/patientAddress.jsp" %>
						<!-- <input type="button" onClick="return removeTab(this, 'name');" class="removeTab" value="Remove this address"/><br/> --> <br/>
					</spring:nestedPath>
				</div>
			</div>
		</div>
	
	<h3><spring:message code="Patient.information"/></h3>
		<div class="tabBox" id="pInformationBox">
			<div class="tabBoxes">
				<%@ include file="include/patientInfo.jsp" %>
			</div>
		</div>	

	<br />
	<spring:bind path="patient.patientId">
		
		<c:if test="${status.errorMessage != ''}"><span class="error">${status.errorMessage}</span></c:if>
	</spring:bind>
	<input type="submit" name="action" id="saveButton" value='<spring:message code="Patient.save"/>' />
	
	<c:if test="${patient.patientId != null}">
	<openmrs:hasPrivilege privilege="Delete Patients">
		 &nbsp; &nbsp; &nbsp;
		<input type="submit" name="action" value="<spring:message code="Patient.delete"/>" onclick="return confirm('Are you sure you want to delete this ENTIRE PATIENT?')"/>
	</openmrs:hasPrivilege>
</c:if>
	
</form>

<script>
	
	var array = new Array(3);
	array[0] = "identifier";
	array[1] = "name";
	array[2] = "address";
	for (var i = 0; i < array.length; i ++) {
		var id = array[i];
		var dataBoxes = document.getElementById(id + "DataBoxes");
		initializeChildren(dataBoxes, id);
		if (numObjs[id] < 1) {
			addNew(id);
		}
		selectTab(document.getElementById(id + "0"), id);
	}
	
</script>

<%@ include file="/WEB-INF/template/footer.jsp" %>
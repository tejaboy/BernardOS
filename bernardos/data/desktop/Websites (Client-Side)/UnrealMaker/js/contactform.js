// JavaScript Document
function validateForm() {
    var name = document.forms["contact"]["name"].value;
	var email = document.forms["contact"]["email"].value;
    if (name == null || name == "") {
        alert("Name must not be blank.");
        return false;
    }
	
    if (email == null || email == "") {
        alert("Email must not be blank.");
        return false;
    }
	
	var text = document.forms["contact"]["text"].value;
    if (text == null || text == "") {
        alert("Text must not be blank.");
        return false;
    }
	
	// Everything is good
	return alert("Sending!");
}

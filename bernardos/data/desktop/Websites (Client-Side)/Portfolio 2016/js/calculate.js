// Download the Javascript online but heavily modified to meet my needs. Understand the Javascript code.

function price() {
    
    var rank = document.calc.rank;
    var posts = document.calc.totalPosts;
	
	if (rank.value == 1) {
		var minRate = '0.000045';
	}
	else if (rank.value == "2") {
		var minRate = '0.00006';
	}
	else if (rank.value == "3") {
		var minRate = '0.00013';
	}
	else if (rank.value == "4") {
		var minRate = '0.0003';
	}
	else if (rank.value == "5") {
		var minRate = '0.0005';
	}
	else if (rank.value == "6") {
		var minRate = '0.0007';
	}
	else if (rank.value == "7") {
		var minRate = '0.0008';
	}
    
    var totalAmount = minRate * posts.value;
	totalAmount = totalAmount.toFixed(8);
    
	document.getElementById("totalAmount").value = totalAmount;
}
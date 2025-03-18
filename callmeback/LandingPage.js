// Declaring variables
let answers = null;
let checkboxes = null;

const setRadioChecks = () => {
if (sessionStorage.getItem("answers") !== null) {
  answers = JSON.parse(sessionStorage.getItem("answers"));
  resetRadios();
} else {
  answers = {
    question1: "no",
    question2: "no",
    question3: "no",
    question4: "no",
    question5: "no",
  };
}
if (sessionStorage.getItem("checkboxes") !== null) {
  checkboxes = JSON.parse(sessionStorage.getItem("checkboxes"));
  resetChecks();
} else {
  checkboxes = {
    checkbox1: false,
    checkbox2: false,
    checkbox3: false,
  };
}

//checkConditions();
}

// resets the radio buttons to match what is stored
const resetRadios = () => {
  // Loop through answers and set radio button selection
  Object.keys(answers).forEach((question) => {
    let selectedValue = answers[question]; // "yes" or "no"
    let radioButton = document.querySelector(
      `input[name="${question}"][value="${selectedValue}"]`
    );
    if (radioButton) {
      radioButton.checked = true;
    }
  });
};

// resets the check boxes to match what is stored
const resetChecks = () => {
  checkboxes.forEach((isChecked, index) => {
    let checkboxElement = document.getElementById(`checkbox${index + 1}`);
    if (checkboxElement) {
      checkboxElement.checked = isChecked;
    }
  });
};

// Function to handle radio button change
const handleChange = (question, value) => {
  answers[question] = value;
  sessionStorage.setItem("answers", JSON.stringify(answers));
  checkConditions();
};

// Function to handle checkbox change
const handleCheckboxChange = () => {
  checkboxes.checkbox1 = document.getElementById("checkbox1").checked;
  checkboxes.checkbox2 = document.getElementById("checkbox2").checked;
  checkboxes.checkbox3 = document.getElementById("checkbox3").checked;

  sessionStorage.setItem("checkboxes", JSON.stringify(checkboxes));
  checkConditions();
};

// Function to check if all conditions are met
const checkConditions = () => {
  const allRadioYes = Object.values(answers).every(
    (answer) => answer === "yes"
  );
  const allCheckboxChecked = Object.values(checkboxes).every(
    (checked) => checked === true
  );

  // Display the button only if all radio buttons are "yes" and all checkboxes are checked
  const submitButton = document.getElementById("submitButton");
  if (!allRadioYes || !allCheckboxChecked) {
    submitButton.style.display = "none";
    sessionStorage.removeItem("submitVisible");
  } else {
    submitButton.style.display = "block";
    sessionStorage.setItem("submitVisible", "true");
  }
};

//checks if there is data in session storage
setRadioChecks();

// Displays a hyphen at the appropriate points for the users contact number
document
  .getElementById("mce-PHONE")
  .addEventListener("input", function (event) {
    // Remove any non-numeric characters
    let input = event.target.value.replace(/\D/g, "");
    let formattedInput = "";

    if (input.length > 0) {
      formattedInput = input.substring(0, 2);
    }
    if (input.length >= 3) {
      formattedInput += "-" + input.substring(2, 5);
    }
    if (input.length >= 6) {
      formattedInput += "-" + input.substring(5, 9);
    }

    event.target.value = formattedInput;
  });

// Restore state when the page loads
document.addEventListener("DOMContentLoaded", function () {
  if (sessionStorage.getItem("submitVisible") === "true") {
    document.getElementById("submitButton").style.display = "block";
  } else {
    document.getElementById("submitButton").style.display = "none";
  }
  //setRadioChecks();
});

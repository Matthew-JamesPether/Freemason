// Declaring variables
let answers = null;
let checkboxes = null;

// Checks if radio buttons and checkboxes are in session storage
const setRadioChecks = () => {
  if (sessionStorage.getItem("answers") !== null) {
    answers = JSON.parse(sessionStorage.getItem("answers"));
  } else {
    answers = {
      question1: null,
      question2: null,
      question3: null,
      question4: null,
      question5: null,
    };
  }
  if (sessionStorage.getItem("checkboxes") !== null) {
    checkboxes = JSON.parse(sessionStorage.getItem("checkboxes"));
  } else {
    checkboxes = {
      checkbox1: null,
      checkbox2: null,
      checkbox3: null,
    };
  }
  // calls reset methods
  resetRadios();
  resetChecks();
};

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
  Object.keys(checkboxes).forEach((isChecked, index) => {
    let checkboxElement = document.getElementById(`checkbox${index + 1}`);
    if (checkboxElement && checkboxes[isChecked] != null) {
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

//Calls method to check session storage
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
});

// Listens to which default buttons the user selects
const [navEntry] = performance.getEntriesByType("navigation");
// Checks if user selects the reload button and resets the page
if (navEntry) {
  if (navEntry.type === "reload") {
    sessionStorage.clear();
    window.location.replace(window.location.href);
  }
}

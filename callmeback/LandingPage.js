// Declaring variables
const answers = {
  question1: "no",
  question2: "no",
  question3: "no",
  question4: "no",
  question5: "no",
};
const checkboxes = {
  checkbox1: false,
  checkbox2: false,
  checkbox3: false,
};

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

// Function to handle radio button change
const handleChange = (question, value) => {
  answers[question] = value;
  checkConditions();
};

// Function to handle checkbox change
const handleCheckboxChange = () => {
  checkboxes.checkbox1 = document.getElementById("checkbox1").checked;
  checkboxes.checkbox2 = document.getElementById("checkbox2").checked;
  checkboxes.checkbox3 = document.getElementById("checkbox3").checked;
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
  } else {
    submitButton.style.display = "block";
  }
};

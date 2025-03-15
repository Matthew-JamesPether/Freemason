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
const [navEntry] = performance.getEntriesByType("navigation");

if (navEntry && navEntry.type === "reload") {
    console.log("User refreshed the page!");
}
// On page load, check sessionStorage for saved state
window.addEventListener("load", () => {
  if (sessionStorage.getItem("answers") && sessionStorage.getItem("checkboxes")) {
    const savedAnswers = JSON.parse(sessionStorage.getItem("answers"));
    const savedCheckboxes = JSON.parse(sessionStorage.getItem("checkboxes"));

    // Restore the saved answers and checkbox values
    Object.keys(savedAnswers).forEach((key) => {
      answers[key] = savedAnswers[key];
    });
    Object.keys(savedCheckboxes).forEach((key) => {
      checkboxes[key] = savedCheckboxes[key];
    });

    // Re-render button visibility based on saved state
    checkConditions();
  }
});

// Displays a hyphen at the appropriate points for the users contact number
document
  .getElementById("mce-PHONE")
  .addEventListener("input", function (event) {
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
  sessionStorage.setItem("answers", JSON.stringify(answers)); // Save answers in sessionStorage
  checkConditions();
};

// Function to handle checkbox change
const handleCheckboxChange = () => {
  checkboxes.checkbox1 = document.getElementById("checkbox1").checked;
  checkboxes.checkbox2 = document.getElementById("checkbox2").checked;
  checkboxes.checkbox3 = document.getElementById("checkbox3").checked;
  sessionStorage.setItem("checkboxes", JSON.stringify(checkboxes)); // Save checkboxes state in sessionStorage
  checkConditions();
};

// Function to check if all conditions are met
const checkConditions = () => {
  const allRadioYes = Object.values(answers).every((answer) => answer === "yes");
  const allCheckboxChecked = Object.values(checkboxes).every((checked) => checked === true);

  // Display the button only if all radio buttons are "yes" and all checkboxes are checked
  const submitButton = document.getElementById("submitButton");
  if (!allRadioYes || !allCheckboxChecked) {
    submitButton.style.display = "none";
  } else {
    submitButton.style.display = "block";
  }
};

// Clear sessionStorage on refresh
window.addEventListener("beforeunload", () => {
  sessionStorage.clear(); // Clear session storage when the page is refreshed
});
<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Bootstrap Modal with Table Example</title>
  <!-- Bootstrap CSS -->
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>

<body>
<button id="btnSubmit">Submit</button>
<select id="ddlOptions" name="ddlOptions" multiple>
  <option value="option1">Option 1</option>
  <option value="option2">Option 2</option>
  <option value="option3">Option 3</option>
  <!-- Add more options as needed -->
</select>


  <!-- Bootstrap JavaScript bundle (includes Popper.js) -->
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
<script>
  // Attach event listener to the button click event
  document.getElementById('btnSubmit').addEventListener('click', function() {
    // Get the selected options from the dropdown list
    var selectedOptions = [];
    var dropdown = document.getElementById('ddlOptions');
    for (var i = 0; i < dropdown.options.length; i++) {
      if (dropdown.options[i].selected) {
        selectedOptions.push(dropdown.options[i].value);
      }
    }

    // Do something with the selected options
    console.log(selectedOptions);
    // You can perform additional operations or send the selected options to the server

    // Optional: Prevent the default form submission
    return false;
  });
</script>

</html>

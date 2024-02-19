document.addEventListener('DOMContentLoaded', function() {
  const resourceForm = document.getElementById('resourceForm');
  const feedback = document.getElementById('feedback');

  resourceForm.addEventListener('submit', function(event) {
    event.preventDefault();

    const formData = new FormData(resourceForm);
    const data = {};
    formData.forEach((value, key) => {
      data[key] = value;
    });

    createAzureResources(data);
  });

  function createAzureResources(data) {
    // You would send the data to your backend to handle Terraform execution
    // For this example, let's just log the data
    console.log(data);

    // Display feedback to the user
    feedback.innerHTML = 'Creating Azure resources...';
  }
});
 

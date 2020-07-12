// This is where it all goes :)
function updateMeasurementUnits(_event) {
  const units = ['oz', 'ml', 'cl', 'gill'];
  let selectedUnits = document.querySelector('input[type=radio][name=units]:checked')['value'];
  for(let unit of units) {
    let measuresInUnit = document.querySelectorAll('.measure .' + unit);
    if (unit === selectedUnits) {
      for (let measureInUnit of measuresInUnit) {
        measureInUnit.classList.remove('inactiveUnit');
        measureInUnit.classList.add('activeUnit');
      }
    } else {
      for (let measureInUnit of measuresInUnit) {
        measureInUnit.classList.add('inactiveUnit');
        measureInUnit.classList.remove('activeUnit');
      }
    }
  }
}
window.onload = (event) => {
  if (document.querySelectorAll('.measure').length > 0) {
    let selectors = document.querySelectorAll('input[type=radio][name=units]');
    for (let selector of selectors) {
      selector.addEventListener('change', (event) => {
        updateMeasurementUnits(event);
      });
    };
    updateMeasurementUnits(event);
  }
};

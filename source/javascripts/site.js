// This is where it all goes :)
function renderResults(query, queryResults) {
  let resultsContainer = document.querySelector('#cocktails-search-results');
  let resultsTemplate = resultsContainer.querySelector('#cocktails-search-results-result-template');
  let resultsGoHere = resultsContainer.querySelector('#cocktails-search-results-container');

  let resultsTitle = resultsContainer.querySelector('#cocktails-search-results-title')

  resultsTitle.innerHTML = '' + queryResults.length + ' cocktail' + (queryResults.length == 1 ? '' : 's') + ' with: '+query;

  if (queryResults.length === 0) {

    resultsGoHere.innerHTML = '<p>Nothing found</p>'

  } else {

    let inject = (str, obj) => str.replace(/\${(.*?)}/g, (x,g)=> obj[g]);

    let resultsHtml = queryResults.map((queryResult, idx) => {
      return '<li>' + inject(resultsTemplate.text, queryResult) + '</li>'
    });

    resultsGoHere.innerHTML = '<ul>' + resultsHtml.join('') + '</ul>';
  }
}

function showResults() {
  let results = document.querySelector('#cocktails-search-results');
  results.classList.add('open');
  results.setAttribute('aria-hidden', 'false');
}

function hideResults() {
  let results = document.querySelector('#cocktails-search-results');
  results.classList.remove('open');
  results.setAttribute('aria-hidden', 'true');
}

function attachSearchBehaviour() {
  let form = document.querySelector('#cocktails-search');
  let input = form.querySelector('input[name=q]');
  let submit = form.querySelector('input[type=submit]')

  form.addEventListener('submit', function (e) {
    e.preventDefault();
    showResults();
  })

  input.addEventListener('input', function (e) {
    e.preventDefault();
    let query = e.target.value;
    search(query, function (r) {
      console.log(r);
      renderResults(query, r)
    })
  })

  let results = document.querySelector('#cocktails-search-results');
  let closeButton = results.querySelector('button');
  closeButton.addEventListener('click', function (e) {
    e.preventDefault()
    hideResults()
  })
}

let searchInterface = {};

function getResults(query) {
  let results = []
  searchInterface.lunrIndex.search(query).forEach(function (item, index) {
    results.push(searchInterface.lunrData.docs[item.ref])
  })
  return results
}

function search(query, callback) {
  console.log("Searching for", query);
  if (query === '') {
    hideResults();
    return
  }
  // The index has not been downloaded yet, exit early and wait.
  if (!searchInterface.lunrIndex) {
    document.addEventListener('lunrIndexLoaded', function () {
      search(query, callback)
    });
    return;
  }
  showResults();
  results = getResults(query);
  console.log(results);
  callback(results);
};

function setupSearch() {
  let form = document.querySelector('#cocktails-search');

  document.addEventListener('lunrIndexLoaded', function (event) {
    console.log('index loaded! - ready to search');
  }, false);

  attachSearchBehaviour();

  let oReq = new XMLHttpRequest();
  oReq.addEventListener("load", function (event) {
    searchInterface.lunrData = oReq.response;
    searchInterface.lunrIndex = lunr.Index.load(searchInterface.lunrData.index)
    // replaceStopWordFilter()
    let loadevent = new CustomEvent('lunrIndexLoaded', { detail: { searchInterface } });
    document.dispatchEvent(loadevent);
  });
  oReq.open("GET", "/search.json");
  oReq.responseType = 'json';
  oReq.send();
}

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
function setupMeasurements() {
  if (document.querySelectorAll('.measure').length > 0) {
    let selectors = document.querySelectorAll('input[type=radio][name=units]');
    for (let selector of selectors) {
      selector.addEventListener('change', (event) => {
        updateMeasurementUnits(event);
      });
    };
    updateMeasurementUnits(event);
  }
}
window.onload = (event) => {
  setupMeasurements();
  setupSearch();
};

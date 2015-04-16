var PracticesController = Paloma.controller('Practices');

// Executes when Rails User#new is executed.
PracticesController.prototype.index = function() {
  var revHist    = this.params['rev_hist'],
      production = this.params['production'];

  var blue        = '#348fe2',
      blueLight   = '#5da5e8',
      blueDark    = '#1993E4',
      aqua        = '#49b6d6',
      aquaLight   = '#6dc5de',
      aquaDark    = '#3a92ab',
      green       = '#00acac',
      greenLight  = '#33bdbd',
      greenDark   = '#008a8a',
      orange      = '#f59c1a',
      orangeLight = '#f7b048',
      orangeDark  = '#c47d15',
      dark        = '#2d353c',
      grey        = '#b6c2c9',
      purple      = '#727cb6',
      purpleLight = '#8e96c5',
      purpleDark  = '#5b6392',
      red         = '#ff5b57';

  var _formatNumberWithCommas = function(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
  };

  var _formatReadableDate = function(date) {
    var options = {
      year: "numeric", month: "short", day: "numeric"
    };
    return date.toLocaleTimeString("en-us", options).split(',').splice(0, 1)[0];
  };

  var loadProductionLineChart = function () {
    Morris.Line({
      element: 'production-line-chart',
      data: production,
      xkey: 'period',
      ykeys: ['total_price'],
      labels: ['Total Production'],
      preUnits: '$',
      resize: true,
      lineColors: [blue],
      xLabelFormat: function (x) { return _formatReadableDate(x); },
      yLabelFormat: function (y) { return '$' + _formatNumberWithCommas(Math.round(y * 100) / 100); }
    });
  };
      
  var loadRevenueAreaChart = function() {
    Morris.Area({
      element: 'revenue-area-chart',
      data: revHist,
      xkey: 'period',
      ykeys: ['unpaid_claims', 'paid_claims', 'payments'],
      labels: ['Unpaid Claims', 'Paid Claims', 'Patient Payments'],
      pointSize: 2,
      hideHover: 'auto',
      preUnits: '$',
      resize: true,
      lineColors: [orangeLight, orange, orangeDark],
      xLabelFormat: function (x) { return _formatReadableDate(x); },
      yLabelFormat: function (y) { return '$' + _formatNumberWithCommas(Math.round(y * 100) / 100); }
    });
  };

  loadProductionLineChart();
  loadRevenueAreaChart();
};
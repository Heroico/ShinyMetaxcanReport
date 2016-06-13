(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
})(window,document,'script','https://www.google-analytics.com/analytics.js','ga');

ga('create', 'UA-61894206-5', 'auto');
ga('send', 'pageview');

//They don't work. I don't know why.
$(document).on('change', '#display', function(e) {
  ga('send', 'event', 'Display', $(e.currentTarget).val());
});

$(document).on('change', '#pheno', function(e) {
  ga('send', 'event', 'Phenotype Selection', $(e.currentTarget).val());
});

$(document).on('change', '#tissue', function(e) {
  ga('send', 'event', 'Tissue Selection', $(e.currentTarget).val());
});

//Too cuttlery for now.
//$(document).on('input', '#gene_name', function(e) {
//    ga('send', 'event', 'Gene Name Selection', $(e.currentTarget).val());
//});



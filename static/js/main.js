
document.querySelectorAll('.tab-btn').forEach(function(btn) {
    btn.addEventListener('click', function() {
        var group = btn.closest('[data-tabs]');
        if (!group) return;
        group.querySelectorAll('.tab-btn').forEach(function(b) { b.classList.remove('active'); });
        group.querySelectorAll('.tab-panel').forEach(function(p) { p.style.display = 'none'; });
        btn.classList.add('active');
        var panel = group.querySelector('[data-panel="' + btn.dataset.tab + '"]');
        if (panel) panel.style.display = 'block';
    });
});


document.querySelectorAll('form[data-confirm]').forEach(function(form) {
    form.addEventListener('submit', function(e) {
        if (!confirm(form.dataset.confirm)) {
            e.preventDefault();
        }
    });
});


var liveSearch = document.getElementById('liveSearch');
if (liveSearch) {
    liveSearch.addEventListener('input', function() {
        var q = liveSearch.value.toLowerCase();
        document.querySelectorAll('[data-searchable]').forEach(function(row) {
            row.style.display = row.textContent.toLowerCase().indexOf(q) !== -1 ? '' : 'none';
        });
    });
}